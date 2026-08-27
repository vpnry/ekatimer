import 'package:flutter/material.dart';
import '../models/meditation_session.dart';
import '../models/user_profile.dart';
import '../services/database_service.dart';
import '../services/persistence_service.dart';
import '../utils/time_utils.dart';

class SessionProvider extends ChangeNotifier {
  List<MeditationSession> _sessions = [];
  bool _isLoading = false;
  String _activeProfileId = UserProfile.defaultId;
  int _loadGeneration = 0;

  int _totalSessions = 0;
  int _totalDurationSeconds = 0;
  double _averageDurationSeconds = 0;
  int _currentStreak = 0;
  int _longestStreak = 0;
  int _todayDurationSeconds = 0;
  int _thisWeekDurationSeconds = 0;
  int _last14DaysDurationSeconds = 0;
  int _thisMonthDurationSeconds = 0;
  int _thisYearDurationSeconds = 0;

  List<MeditationSession> get sessions => _sessions;
  bool get isLoading => _isLoading;
  String get activeProfileId => _activeProfileId;
  int get totalSessions => _totalSessions;
  int get totalDurationSeconds => _totalDurationSeconds;
  double get averageDurationSeconds => _averageDurationSeconds;
  int get currentStreak => _currentStreak;
  int get longestStreak => _longestStreak;
  int get todayDurationSeconds => _todayDurationSeconds;
  int get thisWeekDurationSeconds => _thisWeekDurationSeconds;
  int get last14DaysDurationSeconds => _last14DaysDurationSeconds;
  int get thisMonthDurationSeconds => _thisMonthDurationSeconds;
  int get thisYearDurationSeconds => _thisYearDurationSeconds;

  Future<void> loadSessions({String? profileId}) async {
    // Profile switches can overlap when the user taps quickly. Only the newest
    // request may publish results; otherwise a slower query for the old profile
    // can overwrite the newly selected profile after it completes.
    final generation = ++_loadGeneration;
    _isLoading = true;

    try {
      final requestedProfileId =
          profileId ?? await PersistenceService.loadActiveProfileId();
      if (generation != _loadGeneration) return;

      _activeProfileId = requestedProfileId;

      // Defer the loading notification so callers may invoke this during a
      // widget build without causing a synchronous rebuild exception.
      Future.microtask(() {
        if (generation == _loadGeneration) notifyListeners();
      });

      final sessions = await DatabaseService.getAllSessions(
        profileId: requestedProfileId,
      );
      final stats = await _loadStats(requestedProfileId);
      if (generation != _loadGeneration) return;

      // Publish sessions and their aggregates together so listeners never see
      // a session list from one profile with statistics from another.
      _sessions = sessions;
      _applyStats(stats);
    } catch (_) {
      if (generation == _loadGeneration) {
        _sessions = [];
        _applyStats(const _SessionStats.empty());
      }
      rethrow;
    } finally {
      if (generation == _loadGeneration) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<_SessionStats> _loadStats(String profileId) async {
    final totalSessions = await DatabaseService.getTotalSessionCount(
      profileId: profileId,
    );
    final totalDurationSeconds = await DatabaseService.getTotalDurationAllTime(
      profileId: profileId,
    );
    final averageDurationSeconds = await DatabaseService.getAverageDuration(
      profileId: profileId,
    );
    final currentStreak = await DatabaseService.getCurrentStreak(
      profileId: profileId,
    );
    final longestStreak = await DatabaseService.getLongestStreak(
      profileId: profileId,
    );
    final todayDurationSeconds = await DatabaseService.getTodayDuration(
      profileId: profileId,
    );

    // Every boundary below is built with TimeUtils' calendar-day helpers.
    // Offsetting by a fixed 24-hour Duration would drift by an hour across a
    // daylight-saving switch, pulling in or dropping sessions that sit near
    // midnight at the edges of these ranges.
    final now = DateTime.now();
    final startOfWeekDt = TimeUtils.startOfWeek(now);
    final thisWeekDurationSeconds =
        await DatabaseService.getTotalDurationInRange(
      startOfWeekDt,
      TimeUtils.addDays(startOfWeekDt, 7),
      profileId: profileId,
    );

    final startOf14Days = TimeUtils.addDays(TimeUtils.startOfDay(now), -13);
    final last14DaysDurationSeconds =
        await DatabaseService.getTotalDurationInRange(
      startOf14Days,
      TimeUtils.addDays(startOf14Days, 14),
      profileId: profileId,
    );

    // Database range queries use half-open [start, end) intervals. Calendar
    // constructors give exact next-month/year boundaries across variable month
    // lengths and leap years; adding a fixed number of days would overcount.
    final startOfMonth = DateTime(now.year, now.month, 1);
    final thisMonthDurationSeconds =
        await DatabaseService.getTotalDurationInRange(
      startOfMonth,
      DateTime(now.year, now.month + 1, 1),
      profileId: profileId,
    );

    final startOfYear = DateTime(now.year, 1, 1);
    final thisYearDurationSeconds =
        await DatabaseService.getTotalDurationInRange(
      startOfYear,
      DateTime(now.year + 1, 1, 1),
      profileId: profileId,
    );

    return _SessionStats(
      totalSessions: totalSessions,
      totalDurationSeconds: totalDurationSeconds,
      averageDurationSeconds: averageDurationSeconds,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      todayDurationSeconds: todayDurationSeconds,
      thisWeekDurationSeconds: thisWeekDurationSeconds,
      last14DaysDurationSeconds: last14DaysDurationSeconds,
      thisMonthDurationSeconds: thisMonthDurationSeconds,
      thisYearDurationSeconds: thisYearDurationSeconds,
    );
  }

  void _applyStats(_SessionStats stats) {
    _totalSessions = stats.totalSessions;
    _totalDurationSeconds = stats.totalDurationSeconds;
    _averageDurationSeconds = stats.averageDurationSeconds;
    _currentStreak = stats.currentStreak;
    _longestStreak = stats.longestStreak;
    _todayDurationSeconds = stats.todayDurationSeconds;
    _thisWeekDurationSeconds = stats.thisWeekDurationSeconds;
    _last14DaysDurationSeconds = stats.last14DaysDurationSeconds;
    _thisMonthDurationSeconds = stats.thisMonthDurationSeconds;
    _thisYearDurationSeconds = stats.thisYearDurationSeconds;
  }

  Future<List<MeditationSession>> getSessionsForDate(DateTime date) async {
    return DatabaseService.getSessionsForDate(
      date,
      profileId: _activeProfileId,
    );
  }

  Future<List<MeditationSession>> getSessionsInRange(
    DateTime start,
    DateTime end,
  ) async {
    return DatabaseService.getSessionsInRange(
      start,
      end,
      profileId: _activeProfileId,
    );
  }

  Future<void> updateSession(MeditationSession session) async {
    await DatabaseService.updateSession(session);
    await loadSessions(profileId: _activeProfileId);
  }

  Future<void> deleteSession(String id) async {
    await DatabaseService.deleteSession(id);
    await loadSessions(profileId: _activeProfileId);
  }

  Future<void> deleteAllSessions() async {
    await DatabaseService.deleteAllSessions(profileId: _activeProfileId);
    await loadSessions(profileId: _activeProfileId);
  }

  Future<void> deleteSessionsForProfile(String profileId) async {
    await DatabaseService.deleteSessionsForProfile(profileId);
    if (profileId == _activeProfileId) {
      await loadSessions(profileId: profileId);
    }
  }

  Future<List<WeeklyDataPoint>> getWeeklyData({int weeks = 8}) async {
    final now = DateTime.now();
    final profileId = _activeProfileId;
    final data = <WeeklyDataPoint>[];

    for (int i = weeks - 1; i >= 0; i--) {
      final weekStart = TimeUtils.addDays(TimeUtils.startOfWeek(now), -i * 7);
      final weekEnd = TimeUtils.addDays(weekStart, 7);
      final duration = await DatabaseService.getTotalDurationInRange(
        weekStart,
        weekEnd,
        profileId: profileId,
      );
      data.add(
        WeeklyDataPoint(label: 'W${weeks - i}', durationSeconds: duration),
      );
    }

    return data;
  }

  Future<List<DailyDataPoint>> getDailyData({int days = 30}) async {
    final now = DateTime.now();
    final profileId = _activeProfileId;
    final data = <DailyDataPoint>[];

    for (int i = days - 1; i >= 0; i--) {
      final date = TimeUtils.addDays(TimeUtils.startOfDay(now), -i);
      final duration = await DatabaseService.getTotalDurationForDate(
        date,
        profileId: profileId,
      );
      final daySessions = await DatabaseService.getSessionsForDate(
        date,
        profileId: profileId,
      );
      data.add(
        DailyDataPoint(
          date: date,
          durationSeconds: duration,
          sessionCount: daySessions.length,
        ),
      );
    }

    return data;
  }

  Future<List<MonthlyDataPoint>> getMonthlyData({int months = 12}) async {
    final now = DateTime.now();
    final profileId = _activeProfileId;
    final data = <MonthlyDataPoint>[];

    for (int i = months - 1; i >= 0; i--) {
      final monthStart = DateTime(now.year, now.month - i, 1);
      final monthEnd = DateTime(now.year, now.month - i + 1, 1);
      final duration = await DatabaseService.getTotalDurationInRange(
        monthStart,
        monthEnd,
        profileId: profileId,
      );
      const monthNames = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      data.add(
        MonthlyDataPoint(
          label: monthNames[monthStart.month - 1],
          durationSeconds: duration,
          startDate: monthStart,
        ),
      );
    }

    return data;
  }

  /// Unlike [getMonthlyData]'s rolling N-month window ending today, this
  /// returns all 12 calendar months of [year] (past, present, or future
  /// relative to today) for a fixed year-view chart.
  Future<List<MonthlyDataPoint>> getMonthlyDataForYear(int year) async {
    final yearStart = DateTime(year, 1, 1);
    final yearEnd = DateTime(year + 1, 1, 1);
    final sessions = await DatabaseService.getSessionsInRange(
      yearStart,
      yearEnd,
      profileId: _activeProfileId,
    );
    final durations = List<int>.filled(12, 0);
    for (final session in sessions) {
      durations[session.startTime.month - 1] += session.durationSeconds;
    }

    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return List.generate(
      12,
      (index) => MonthlyDataPoint(
        label: monthNames[index],
        durationSeconds: durations[index],
        startDate: DateTime(year, index + 1, 1),
      ),
    );
  }

  /// Calendar-month counterpart to [getDailyData]'s rolling N-day window:
  /// returns one entry per day of the given [year]/[month], for a month
  /// grid rather than a trailing window ending today.
  Future<List<DailyDataPoint>> getDailyDataForMonth(int year, int month) async {
    final monthStart = DateTime(year, month, 1);
    final monthEnd = DateTime(year, month + 1, 1);
    final sessions = await DatabaseService.getSessionsInRange(
      monthStart,
      monthEnd,
      profileId: _activeProfileId,
    );
    // Day 0 of the next month is the last day of this one, so this yields
    // the month's length without special-casing 28/29/30/31. Stepping back
    // a 24-hour Duration from monthEnd could land on the second-to-last day
    // across a daylight-saving switch and drop a row from the grid.
    final dayCount = DateTime(year, month + 1, 0).day;
    final durations = List<int>.filled(dayCount, 0);
    final counts = List<int>.filled(dayCount, 0);
    for (final session in sessions) {
      final index = session.startTime.day - 1;
      durations[index] += session.durationSeconds;
      counts[index]++;
    }

    return List.generate(
      dayCount,
      (index) => DailyDataPoint(
        date: DateTime(year, month, index + 1),
        durationSeconds: durations[index],
        sessionCount: counts[index],
      ),
    );
  }

  Future<List<YearlyDataPoint>> getYearlyData() async {
    final now = DateTime.now();
    final profileId = _activeProfileId;
    final data = <YearlyDataPoint>[];

    // Determine the oldest year with session data.
    final oldestTimestamp = await DatabaseService.getOldestSessionTimestamp(
      profileId: profileId,
    );
    final oldestYear = oldestTimestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(oldestTimestamp).year
        : now.year;

    final yearsCount = now.year - oldestYear + 1;

    for (int i = 0; i < yearsCount; i++) {
      final year = now.year - i;
      final yearStart = DateTime(year, 1, 1);
      final yearEnd = DateTime(year + 1, 1, 1);
      final duration = await DatabaseService.getTotalDurationInRange(
        yearStart,
        yearEnd,
        profileId: profileId,
      );
      data.add(
        YearlyDataPoint(label: '$year', durationSeconds: duration, year: year),
      );
    }

    return data;
  }
}

// Bundles every aggregate loadSessions() computes so _loadStats can finish
// (or fail) as one unit and _applyStats can publish them together —
// listeners never observe totals from a half-finished refresh.
class _SessionStats {
  final int totalSessions;
  final int totalDurationSeconds;
  final double averageDurationSeconds;
  final int currentStreak;
  final int longestStreak;
  final int todayDurationSeconds;
  final int thisWeekDurationSeconds;
  final int last14DaysDurationSeconds;
  final int thisMonthDurationSeconds;
  final int thisYearDurationSeconds;

  const _SessionStats({
    required this.totalSessions,
    required this.totalDurationSeconds,
    required this.averageDurationSeconds,
    required this.currentStreak,
    required this.longestStreak,
    required this.todayDurationSeconds,
    required this.thisWeekDurationSeconds,
    required this.last14DaysDurationSeconds,
    required this.thisMonthDurationSeconds,
    required this.thisYearDurationSeconds,
  });

  const _SessionStats.empty()
    : totalSessions = 0,
      totalDurationSeconds = 0,
      averageDurationSeconds = 0,
      currentStreak = 0,
      longestStreak = 0,
      todayDurationSeconds = 0,
      thisWeekDurationSeconds = 0,
      last14DaysDurationSeconds = 0,
      thisMonthDurationSeconds = 0,
      thisYearDurationSeconds = 0;
}

class WeeklyDataPoint {
  final String label;
  final int durationSeconds;
  WeeklyDataPoint({required this.label, required this.durationSeconds});
}

class DailyDataPoint {
  final DateTime date;
  final int durationSeconds;
  final int sessionCount;
  DailyDataPoint({
    required this.date,
    required this.durationSeconds,
    this.sessionCount = 0,
  });

  String get label => '${date.day}';
}

class MonthlyDataPoint {
  final String label;
  final int durationSeconds;
  final DateTime startDate;
  MonthlyDataPoint({
    required this.label,
    required this.durationSeconds,
    required this.startDate,
  });
}

class YearlyDataPoint {
  final String label;
  final int durationSeconds;
  final int year;
  YearlyDataPoint({
    required this.label,
    required this.durationSeconds,
    required this.year,
  });
}
