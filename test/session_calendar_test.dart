import 'package:ekatimer/models/meditation_session.dart';
import 'package:ekatimer/utils/session_calendar.dart';
import 'package:flutter_test/flutter_test.dart';

MeditationSession sessionAt(DateTime start, int seconds) => MeditationSession(
  id: start.toIso8601String(),
  startTime: start,
  durationSeconds: seconds,
);

void main() {
  test('groups sessions into four six-hour time slots', () {
    final rows = SessionCalendar.build(
      startDate: DateTime(2026, 8, 10),
      days: 1,
      sessions: [
        sessionAt(DateTime(2026, 8, 10, 0), 10),
        sessionAt(DateTime(2026, 8, 10, 5, 59), 20),
        sessionAt(DateTime(2026, 8, 10, 6), 30),
        sessionAt(DateTime(2026, 8, 10, 11, 59), 40),
        sessionAt(DateTime(2026, 8, 10, 12), 50),
        sessionAt(DateTime(2026, 8, 10, 17, 59), 60),
        sessionAt(DateTime(2026, 8, 10, 18), 70),
        sessionAt(DateTime(2026, 8, 10, 23, 59), 80),
      ],
    );

    expect(rows.single.slotSeconds, [30, 70, 110, 150]);
    expect(rows.single.totalSeconds, 360);
  });

  test('keeps empty days and ignores sessions outside the range', () {
    final rows = SessionCalendar.build(
      startDate: DateTime(2026, 8, 10, 18),
      days: 3,
      sessions: [
        sessionAt(DateTime(2026, 8, 9, 23, 59), 100),
        sessionAt(DateTime(2026, 8, 11, 8), 120),
        sessionAt(DateTime(2026, 8, 13), 200),
      ],
    );

    expect(rows.map((row) => row.totalSeconds), [0, 120, 0]);
  });

  test('builds the requested pipe-delimited text report', () {
    final rows = SessionCalendar.build(
      startDate: DateTime(2026, 8, 10),
      days: 2,
      sessions: [sessionAt(DateTime(2026, 8, 10, 8), 3661)],
    );

    expect(
      SessionCalendar.buildReport(rows),
      'Date(YYYY-MM-DD)|Duration(HH:MM:SS)\n'
      '2026-08-10|01:01:01\n'
      '2026-08-11|00:00:00',
    );
  });
}
