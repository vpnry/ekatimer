import 'package:ekatimer/models/meditation_session.dart';
import 'package:ekatimer/models/data_import_mode.dart';
import 'package:ekatimer/models/user_profile.dart';
import 'package:ekatimer/services/backup_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'backup preserves profiles, active profile, sessions, quality and note',
    () {
      const profiles = [
        UserProfile(id: 'default', name: 'Daw Sumedha'),
        UserProfile(id: 'evening', name: 'Evening Practice'),
      ];
      final sessions = [
        MeditationSession(
          id: 'session-1',
          profileId: 'evening',
          startTime: DateTime(2026, 8, 15, 18),
          endTime: DateTime(2026, 8, 15, 19),
          durationSeconds: 3600,
          quality: '4',
          notes: 'Settled after walking meditation.',
        ),
      ];

      final restored = BackupService.parseBackupJson(
        BackupService.buildBackupJson(
          profiles: profiles,
          activeProfileId: 'evening',
          sessions: sessions,
        ),
      );

      expect(restored.profiles.map((profile) => profile.name), [
        'Daw Sumedha',
        'Evening Practice',
      ]);
      expect(restored.activeProfileId, 'evening');
      expect(restored.sessions.single.profileId, 'evening');
      expect(restored.sessions.single.quality, '4');
      expect(
        restored.sessions.single.notes,
        'Settled after walking meditation.',
      );
    },
  );

  test('backup rejects a session assigned to an unknown profile', () {
    expect(
      () => BackupService.buildBackupJson(
        profiles: const [UserProfile(id: 'default', name: 'Meditator')],
        activeProfileId: 'default',
        sessions: [
          MeditationSession(
            id: 'orphan',
            profileId: 'missing',
            startTime: DateTime(2026, 8, 15),
            durationSeconds: 60,
          ),
        ],
      ),
      throwsFormatException,
    );
  });

  test('backup rejects duplicate session identifiers before writing', () {
    final session = MeditationSession(
      id: 'duplicate',
      startTime: DateTime(2026, 8, 15),
      durationSeconds: 60,
    );

    expect(
      () => BackupService.buildBackupJson(
        profiles: const [UserProfile(id: 'default', name: 'Meditator')],
        activeProfileId: 'default',
        sessions: [session, session.copyWith(durationSeconds: 90)],
      ),
      throwsFormatException,
    );
  });

  test('merge preserves local data and safely renames every conflict', () {
    const localProfiles = [
      UserProfile(id: 'default', name: 'Local'),
      UserProfile(id: 'shared', name: 'Shared'),
      UserProfile(id: 'local-retreat', name: 'Retreat'),
    ];
    final duplicate = MeditationSession(
      id: 'duplicate-session',
      profileId: 'shared',
      startTime: DateTime(2026, 8, 15, 6),
      durationSeconds: 600,
      quality: '3',
    );
    final conflicting = MeditationSession(
      id: 'conflicting-session',
      profileId: 'default',
      startTime: DateTime(2026, 8, 15, 7),
      durationSeconds: 600,
    );
    final incoming = AppBackup(
      profiles: const [
        UserProfile(id: 'default', name: 'Remote'),
        UserProfile(id: 'shared', name: 'Shared'),
        UserProfile(id: 'remote-retreat', name: 'Retreat'),
      ],
      activeProfileId: 'default',
      sessions: [
        duplicate.copyWith(quality: '3.0'),
        conflicting.copyWith(durationSeconds: 900),
        MeditationSession(
          id: 'new-session',
          profileId: 'remote-retreat',
          startTime: DateTime(2026, 8, 15, 8),
          durationSeconds: 1200,
        ),
      ],
    );

    final merged = BackupService.mergeBackup(
      existingProfiles: localProfiles,
      existingActiveProfileId: 'shared',
      existingSessions: [duplicate, conflicting],
      incoming: incoming,
    );

    expect(merged.activeProfileId, 'shared');
    expect(merged.profiles.map((profile) => profile.id), [
      'default',
      'shared',
      'local-retreat',
      'default-imported',
      'remote-retreat',
    ]);
    expect(merged.profiles.map((profile) => profile.name), [
      'Local',
      'Shared',
      'Retreat',
      'Remote',
      'Retreat (Imported)',
    ]);
    expect(merged.sessions.map((session) => session.id), [
      'duplicate-session',
      'conflicting-session',
      'conflicting-session-imported',
      'new-session',
    ]);
    expect(
      merged.sessions
          .firstWhere((session) => session.id == 'conflicting-session-imported')
          .profileId,
      'default-imported',
    );
    expect(
      merged.sessions
          .firstWhere((session) => session.id == 'new-session')
          .profileId,
      'remote-retreat',
    );
  });

  test(
    'session conflict suffix advances without overwriting prior imports',
    () {
      final local = MeditationSession(
        id: 'same',
        startTime: DateTime(2026, 8, 15),
        durationSeconds: 60,
      );
      final priorImport = local.copyWith(
        id: 'same-imported',
        durationSeconds: 75,
      );
      final result = BackupService.mergeSessionLists(
        existing: [local, priorImport],
        imported: [local.copyWith(durationSeconds: 90)],
      );

      expect(result.sessions.last.id, 'same-imported-2');
      expect(result.addedCount, 1);
      expect(result.renamedConflictCount, 1);
    },
  );

  test(
    'overwrite plan uses imported profiles, sessions and active profile',
    () {
      final incoming = AppBackup(
        profiles: const [UserProfile(id: 'remote', name: 'Remote')],
        activeProfileId: 'remote',
        sessions: [
          MeditationSession(
            id: 'remote-session',
            profileId: 'remote',
            startTime: DateTime(2026, 8, 15),
            durationSeconds: 60,
          ),
        ],
      );

      final plan = BackupService.createRestorePlan(
        mode: DataImportMode.overwrite,
        incoming: incoming,
        existingProfiles: const [UserProfile(id: 'default', name: 'Local')],
        existingActiveProfileId: 'default',
        existingSessions: const [],
      );

      expect(plan, same(incoming));
      expect(plan.activeProfileId, 'remote');
    },
  );
}
