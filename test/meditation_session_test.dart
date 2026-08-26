import 'package:ekatimer/models/meditation_session.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('quality survives database map round-trip', () {
    final session = MeditationSession(
      id: 'session-1',
      startTime: DateTime(2026, 8, 14, 6),
      endTime: DateTime(2026, 8, 14, 6, 30),
      durationSeconds: 1800,
      quality: '4',
    );

    final restored = MeditationSession.fromMap(session.toMap());

    expect(restored.quality, '4');
  });

  test('profile survives database map round-trip', () {
    final session = MeditationSession(
      id: 'profile-session',
      profileId: 'profile-b',
      startTime: DateTime(2026, 8, 15, 7),
      durationSeconds: 900,
    );

    expect(MeditationSession.fromMap(session.toMap()).profileId, 'profile-b');
  });

  test('notes survive database map round-trip', () {
    final session = MeditationSession(
      id: 'session-with-note',
      startTime: DateTime(2026, 8, 15, 6),
      durationSeconds: 1800,
      notes: 'Restless at first, then calm.\nBreathing became subtle.',
    );

    final restored = MeditationSession.fromMap(session.toMap());

    expect(
      restored.notes,
      'Restless at first, then calm.\nBreathing became subtle.',
    );
  });

  test('old database rows without quality remain readable', () {
    final restored = MeditationSession.fromMap({
      'id': 'old-session',
      'startTime': DateTime(2026, 8, 14, 6).millisecondsSinceEpoch,
      'endTime': null,
      'durationSeconds': 60,
      'targetDurationSeconds': 60,
      'timerMode': 'timed',
      'completed': 1,
      'notes': null,
    });

    expect(restored.quality, isNull);
    expect(restored.profileId, 'default');
  });

  test('copyWith can clear quality', () {
    final session = MeditationSession(
      id: 'session-1',
      startTime: DateTime(2026, 8, 14, 6),
      durationSeconds: 60,
      quality: 'Focused',
    );

    expect(session.copyWith(clearQuality: true).quality, isNull);
  });

  test('copyWith can update and clear notes', () {
    final session = MeditationSession(
      id: 'session-1',
      startTime: DateTime(2026, 8, 15, 6),
      durationSeconds: 60,
      notes: 'Original note',
    );

    expect(session.copyWith(notes: 'Updated note').notes, 'Updated note');
    expect(session.copyWith(clearNotes: true).notes, isNull);
  });
}
