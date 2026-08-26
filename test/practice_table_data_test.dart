import 'package:ekatimer/models/meditation_session.dart';
import 'package:ekatimer/models/practice_table_data.dart';
import 'package:flutter_test/flutter_test.dart';

MeditationSession _session(
  String id,
  DateTime startTime, {
  int durationSeconds = 60,
  String? quality,
}) => MeditationSession(
  id: id,
  startTime: startTime,
  durationSeconds: durationSeconds,
  quality: quality,
);

void main() {
  test('builds date rows, retains empty dates, and sorts sessions by time', () {
    final data = PracticeTableData.fromSessions(
      startDate: DateTime(2026, 8, 10, 18),
      endDate: DateTime(2026, 8, 12, 6),
      sessions: [
        _session('late', DateTime(2026, 8, 10, 19), durationSeconds: 120),
        _session('early', DateTime(2026, 8, 10, 6), durationSeconds: 60),
      ],
    );

    expect(data.rows.map((row) => row.date), [
      DateTime(2026, 8, 10),
      DateTime(2026, 8, 11),
      DateTime(2026, 8, 12),
    ]);
    expect(data.rows.first.sessions.map((session) => session.id), [
      'early',
      'late',
    ]);
    expect(data.rows.map((row) => row.totalDurationSeconds), [180, 0, 0]);
    expect(data.sessionColumnCount, 5);
  });

  test('adds columns for every session beyond the five-column minimum', () {
    final date = DateTime(2026, 8, 13);
    final sessions = List.generate(
      7,
      (index) => _session(
        'session-$index',
        date.add(Duration(hours: 6 + index)),
        quality: '$index',
      ),
    );

    final data = PracticeTableData.fromSessions(sessions: sessions);

    expect(data.sessionColumnCount, 7);
    expect(data.rows.single.sessions, hasLength(7));
  });

  test('returns exact decimal qualities and treats invalid text as absent', () {
    final date = DateTime(2026, 8, 14);
    final data = PracticeTableData.fromSessions(
      sessions: [
        _session('zero', date, quality: '0.0'),
        _session('decimal', date.add(const Duration(hours: 1)), quality: '2.5'),
        _session('missing', date.add(const Duration(hours: 2))),
        _session('legacy', date.add(const Duration(hours: 3)), quality: 'calm'),
      ],
    );

    expect(List.generate(4, data.rows.single.qualityAt), <double?>[
      0,
      2.5,
      null,
      null,
    ]);
  });

  test('rejects an end date before the start date', () {
    expect(
      () => PracticeTableData.fromSessions(
        sessions: const [],
        startDate: DateTime(2026, 8, 12),
        endDate: DateTime(2026, 8, 10),
      ),
      throwsArgumentError,
    );
  });
}
