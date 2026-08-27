import 'dart:math' as math;

import '../utils/sitting_quality.dart';
import 'meditation_session.dart';

/// The sessions recorded on one local calendar date in a practice table.
class PracticeTableDay {
  final DateTime date;
  final List<MeditationSession> sessions;

  PracticeTableDay({
    required this.date,
    required Iterable<MeditationSession> sessions,
  }) : sessions = List.unmodifiable(sessions);

  int get totalDurationSeconds => sessions.fold(
    0,
    (total, session) => total + math.max(0, session.durationSeconds),
  );

  /// Returns the exact numeric sitting quality for [sessionIndex].
  ///
  /// Missing and legacy free-text qualities are deliberately returned as
  /// `null`, allowing the table to leave the value empty.
  double? qualityAt(int sessionIndex) {
    if (sessionIndex < 0 || sessionIndex >= sessions.length) return null;
    return SittingQuality.rating(sessions[sessionIndex].quality);
  }
}

/// Date rows and the dynamic session-column count used by a practice table.
class PracticeTableData {
  static const int minimumVisibleSessionColumns = 5;

  final List<PracticeTableDay> rows;
  final int sessionColumnCount;

  PracticeTableData._({
    required Iterable<PracticeTableDay> rows,
    required this.sessionColumnCount,
  }) : rows = List.unmodifiable(rows);

  /// Groups [sessions] by local calendar date and sorts each date's sessions
  /// chronologically.
  ///
  /// When [startDate] and/or [endDate] are supplied, every date in the
  /// inclusive range is retained, including dates without a session. Without
  /// explicit bounds, the range runs from the earliest to latest session.
  factory PracticeTableData.fromSessions({
    required Iterable<MeditationSession> sessions,
    DateTime? startDate,
    DateTime? endDate,
    int minimumSessionColumns = minimumVisibleSessionColumns,
  }) {
    final sortedSessions = sessions.toList()
      ..sort((first, second) {
        final timeOrder = first.startTime.compareTo(second.startTime);
        return timeOrder != 0 ? timeOrder : first.id.compareTo(second.id);
      });

    final firstSessionDate = sortedSessions.isEmpty
        ? null
        : _dateOnly(sortedSessions.first.startTime);
    final lastSessionDate = sortedSessions.isEmpty
        ? null
        : _dateOnly(sortedSessions.last.startTime);
    final explicitStart = startDate == null ? null : _dateOnly(startDate);
    final explicitEnd = endDate == null ? null : _dateOnly(endDate);
    final normalizedStart =
        explicitStart ??
        (explicitEnd == null
            ? firstSessionDate
            : _earlierOf(firstSessionDate, explicitEnd));
    final normalizedEnd =
        explicitEnd ??
        (explicitStart == null
            ? lastSessionDate
            : _laterOf(lastSessionDate, explicitStart));

    if (normalizedStart != null &&
        normalizedEnd != null &&
        normalizedStart.isAfter(normalizedEnd)) {
      throw ArgumentError.value(
        endDate,
        'endDate',
        'must not be before startDate',
      );
    }

    final sessionsByDate = <int, List<MeditationSession>>{};
    for (final session in sortedSessions) {
      final sessionDate = _dateOnly(session.startTime);
      if (normalizedStart != null && sessionDate.isBefore(normalizedStart)) {
        continue;
      }
      if (normalizedEnd != null && sessionDate.isAfter(normalizedEnd)) {
        continue;
      }
      sessionsByDate.putIfAbsent(_dateKey(sessionDate), () => []).add(session);
    }

    final rows = <PracticeTableDay>[];
    if (normalizedStart != null && normalizedEnd != null) {
      var date = normalizedStart;
      while (!date.isAfter(normalizedEnd)) {
        rows.add(
          PracticeTableDay(
            date: date,
            sessions: sessionsByDate[_dateKey(date)] ?? const [],
          ),
        );
        date = DateTime(date.year, date.month, date.day + 1);
      }
    }

    final widestDate = rows.fold<int>(
      0,
      (widest, row) => math.max(widest, row.sessions.length),
    );
    final requestedMinimum = math.max(
      minimumVisibleSessionColumns,
      minimumSessionColumns,
    );

    return PracticeTableData._(
      rows: rows,
      sessionColumnCount: math.max(requestedMinimum, widestDate),
    );
  }

  static DateTime _dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  static int _dateKey(DateTime value) =>
      value.year * 10000 + value.month * 100 + value.day;

  static DateTime _earlierOf(DateTime? first, DateTime second) =>
      first == null || second.isBefore(first) ? second : first;

  static DateTime _laterOf(DateTime? first, DateTime second) =>
      first == null || second.isAfter(first) ? second : first;
}
