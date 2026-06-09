import 'package:flutter/material.dart';
import '../models/meditation_session.dart';
import '../services/database_service.dart';

class SessionProvider extends ChangeNotifier {
  List<MeditationSession> _sessions = [];
  bool _isLoading = false;

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

  Future<void> loadSessions() async {
    _isLoading = true;
    
    // Safely defer notifyListeners to the next microtask queue
    // to avoid triggering rebuilds during the build phase.
    Future.microtask(() => notifyListeners());

    try {
      _sessions = await DatabaseService.getAllSessions();
      await _refreshStats();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _refreshStats() async {
    _totalSessions = await DatabaseService.getTotalSessionCount();
    _totalDurationSeconds = await DatabaseService.getTotalDurationAllTime();
    _averageDurationSeconds = await DatabaseService.getAverageDuration();
    _currentStreak = await DatabaseService.getCurrentStreak();
    _longestStreak = await DatabaseService.getLongestStreak();
    _todayDurationSeconds = await DatabaseService.getTodayDuration();

    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeekDt = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    _thisWeekDurationSeconds = await DatabaseService.getTotalDurationInRange(
      startOfWeekDt,
      startOfWeekDt.add(const Duration(days: 7)),
    );

    final startOf14Days = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 13));
    _last14DaysDurationSeconds = await DatabaseService.getTotalDurationInRange(
      startOf14Days,
      startOf14Days.add(const Duration(days: 14)),
    );

    final startOfMonth = DateTime(now.year, now.month, 1);
    _thisMonthDurationSeconds = await DatabaseService.getTotalDurationInRange(
      startOfMonth,
      startOfMonth.add(const Duration(days: 32)),
    );

    final startOfYear = DateTime(now.year, 1, 1);
    _thisYearDurationSeconds = await DatabaseService.getTotalDurationInRange(
      startOfYear,
      startOfYear.add(const Duration(days: 366)),
    );
  }

  Future<List<MeditationSession>> getSessionsForDate(DateTime date) async {
    return DatabaseService.getSessionsForDate(date);
  }

  Future<List<MeditationSession>> getSessionsInRange(DateTime start, DateTime end) async {
    return DatabaseService.getSessionsInRange(start, end);
  }

  Future<void> deleteSession(String id) async {
    await DatabaseService.deleteSession(id);
    await loadSessions();
  }

  Future<void> deleteAllSessions() async {
    await DatabaseService.deleteAllSessions();
    await loadSessions();
  }

  Future<List<WeeklyDataPoint>> getWeeklyData({int weeks = 8}) async {
    final now = DateTime.now();
    final data = <WeeklyDataPoint>[];

    for (int i = weeks - 1; i >= 0; i--) {
      final weekStart = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: now.weekday - 1 + (i * 7)));
      final weekEnd = weekStart.add(const Duration(days: 7));
      final duration = await DatabaseService.getTotalDurationInRange(weekStart, weekEnd);
      data.add(WeeklyDataPoint(
        label: 'W${weeks - i}',
        durationSeconds: duration,
      ));
    }

    return data;
  }

  Future<List<DailyDataPoint>> getDailyData({int days = 30}) async {
    final now = DateTime.now();
    final data = <DailyDataPoint>[];

    for (int i = days - 1; i >= 0; i--) {
      final date = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      final duration = await DatabaseService.getTotalDurationForDate(date);
      final daySessions = await DatabaseService.getSessionsForDate(date);
      data.add(DailyDataPoint(
        date: date,
        durationSeconds: duration,
        sessionCount: daySessions.length,
      ));
    }

    return data;
  }

  Future<List<MonthlyDataPoint>> getMonthlyData({int months = 12}) async {
    final now = DateTime.now();
    final data = <MonthlyDataPoint>[];

    for (int i = months - 1; i >= 0; i--) {
      final monthStart = DateTime(now.year, now.month - i, 1);
      final monthEnd = DateTime(now.year, now.month - i + 1, 1);
      final duration = await DatabaseService.getTotalDurationInRange(monthStart, monthEnd);
      const monthNames = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      data.add(MonthlyDataPoint(
        label: monthNames[monthStart.month - 1],
        durationSeconds: duration,
      ));
    }

    return data;
  }

  Future<List<YearlyDataPoint>> getYearlyData() async {
    final now = DateTime.now();
    final data = <YearlyDataPoint>[];

    // Determine the oldest year with session data.
    final oldestTimestamp = await DatabaseService.getOldestSessionTimestamp();
    final oldestYear = oldestTimestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(oldestTimestamp).year
        : now.year;

    final yearsCount = now.year - oldestYear + 1;

    for (int i = 0; i < yearsCount; i++) {
      final year = now.year - i;
      final yearStart = DateTime(year, 1, 1);
      final yearEnd = DateTime(year + 1, 1, 1);
      final duration = await DatabaseService.getTotalDurationInRange(yearStart, yearEnd);
      data.add(YearlyDataPoint(
        label: '$year',
        durationSeconds: duration,
      ));
    }

    return data;
  }
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
}

class MonthlyDataPoint {
  final String label;
  final int durationSeconds;
  MonthlyDataPoint({required this.label, required this.durationSeconds});
}

class YearlyDataPoint {
  final String label;
  final int durationSeconds;
  YearlyDataPoint({required this.label, required this.durationSeconds});
}