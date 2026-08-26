import '../models/meditation_session.dart';

/// One calendar day's practice time, bucketed into [SessionCalendar.slotCount]
/// six-hour slots of the day (00-06, 06-12, 12-18, 18-24) for a heatmap-style view.
class SessionCalendarDay {
  final DateTime date;
  final List<int> slotSeconds;

  const SessionCalendarDay({required this.date, required this.slotSeconds});

  int get totalSeconds => slotSeconds.fold(0, (sum, value) => sum + value);
}

/// Buckets sessions into fixed-size day/time-of-day grids for calendar views
/// and plain-text calendar reports.
class SessionCalendar {
  SessionCalendar._();

  static const int slotCount = 4;

  static int slotIndex(DateTime startTime) => startTime.hour ~/ 6;

  static List<SessionCalendarDay> build({
    required DateTime startDate,
    required int days,
    required Iterable<MeditationSession> sessions,
  }) {
    final normalizedStart = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
    );
    final values = List.generate(days, (_) => List.filled(slotCount, 0));
    final endDate = normalizedStart.add(Duration(days: days));

    for (final session in sessions) {
      if (session.startTime.isBefore(normalizedStart) ||
          !session.startTime.isBefore(endDate)) {
        continue;
      }

      final sessionDate = DateTime(
        session.startTime.year,
        session.startTime.month,
        session.startTime.day,
      );
      final dayIndex = sessionDate.difference(normalizedStart).inDays;
      values[dayIndex][slotIndex(session.startTime)] += session.durationSeconds;
    }

    return List.generate(
      days,
      (index) => SessionCalendarDay(
        date: normalizedStart.add(Duration(days: index)),
        slotSeconds: List.unmodifiable(values[index]),
      ),
    );
  }

  static String buildReport(Iterable<SessionCalendarDay> rows) {
    final buffer = StringBuffer('Date(YYYY-MM-DD)|Duration(HH:MM:SS)\n');
    for (final row in rows) {
      final date =
          '${row.date.year}-${row.date.month.toString().padLeft(2, '0')}-${row.date.day.toString().padLeft(2, '0')}';
      buffer.writeln('$date|${formatHms(row.totalSeconds)}');
    }
    return buffer.toString().trimRight();
  }

  static String formatHms(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remaining = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${remaining.toString().padLeft(2, '0')}';
  }
}
