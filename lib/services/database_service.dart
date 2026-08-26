// lib/services/database_service.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import '../utils/constants.dart';
import '../models/meditation_session.dart';

// Nearly every read/write below takes an optional `profileId`.
// Pass it to scope the call to one practitioner profile (see
// UserProfile); omit it to operate across all profiles at once, which
// only the backup/restore flows in BackupService should do.
class DatabaseService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, AppConstants.databaseName);

    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE sessions (
        id TEXT PRIMARY KEY,
        profileId TEXT NOT NULL DEFAULT 'default',
        startTime INTEGER NOT NULL,
        endTime INTEGER,
        durationSeconds INTEGER NOT NULL,
        targetDurationSeconds INTEGER NOT NULL DEFAULT 0,
        timerMode TEXT NOT NULL DEFAULT 'timed',
        completed INTEGER NOT NULL DEFAULT 1,
        quality TEXT,
        notes TEXT
      )
    ''');
  }

  static Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // Each branch is a one-way, additive migration keyed to the
    // AppConstants.databaseVersion at the time the column was added.
    // Never rewrite an old branch or renumber past versions here —
    // devices upgrading from that version must still run it.
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE sessions ADD COLUMN quality TEXT');
    }
    if (oldVersion < 4) {
      await db.execute(
        "ALTER TABLE sessions ADD COLUMN profileId TEXT NOT NULL DEFAULT 'default'",
      );
    }
  }

  static Future<void> insertSession(MeditationSession session) async {
    final db = await database;
    await db.insert(
      'sessions',
      session.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<MeditationSession>> getAllSessions({
    String? profileId,
  }) async {
    final db = await database;
    final maps = await db.query(
      'sessions',
      where: profileId == null ? null : 'profileId = ?',
      whereArgs: profileId == null ? null : [profileId],
      orderBy: 'startTime DESC',
    );
    return maps.map((map) => MeditationSession.fromMap(map)).toList();
  }

  static Future<List<MeditationSession>> getSessionsInRange(
    DateTime start,
    DateTime end, {
    String? profileId,
  }) async {
    final db = await database;
    final startMs = start.millisecondsSinceEpoch;
    final endMs = end.millisecondsSinceEpoch;
    final maps = await db.query(
      'sessions',
      where: profileId == null
          ? 'startTime >= ? AND startTime < ?'
          : 'profileId = ? AND startTime >= ? AND startTime < ?',
      whereArgs: profileId == null
          ? [startMs, endMs]
          : [profileId, startMs, endMs],
      orderBy: 'startTime DESC',
    );
    return maps.map((map) => MeditationSession.fromMap(map)).toList();
  }

  static Future<List<MeditationSession>> getSessionsForDate(
    DateTime date, {
    String? profileId,
  }) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return getSessionsInRange(startOfDay, endOfDay, profileId: profileId);
  }

  static Future<int> getTotalDurationInRange(
    DateTime start,
    DateTime end, {
    String? profileId,
  }) async {
    final sessions = await getSessionsInRange(start, end, profileId: profileId);
    int total = 0;
    for (final session in sessions) {
      total += session.durationSeconds;
    }
    return total;
  }

  static Future<int> getTodayDuration({String? profileId}) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    return getTotalDurationInRange(
      startOfDay,
      startOfDay.add(const Duration(days: 1)),
      profileId: profileId,
    );
  }

  static Future<int> getTotalDurationForDate(
    DateTime date, {
    String? profileId,
  }) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return getTotalDurationInRange(startOfDay, endOfDay, profileId: profileId);
  }

  static Future<int> getSessionCountInRange(
    DateTime start,
    DateTime end, {
    String? profileId,
  }) async {
    final sessions = await getSessionsInRange(start, end, profileId: profileId);
    return sessions.length;
  }

  static Future<int> getCurrentStreak({String? profileId}) async {
    final db = await database;
    final maps = await db.query(
      'sessions',
      columns: ['startTime'],
      where: profileId == null ? null : 'profileId = ?',
      whereArgs: profileId == null ? null : [profileId],
      orderBy: 'startTime DESC',
    );

    if (maps.isEmpty) return 0;

    final sessionDates =
        maps
            .map((m) {
              final dt = DateTime.fromMillisecondsSinceEpoch(
                m['startTime'] as int,
              );
              return DateTime(dt.year, dt.month, dt.day);
            })
            .toSet()
            .toList()
          ..sort((a, b) => b.compareTo(a));

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (!sessionDates.contains(today) && !sessionDates.contains(yesterday)) {
      return 0;
    }

    int streak = 0;
    var checkDate = sessionDates.contains(today) ? today : yesterday;

    while (sessionDates.contains(checkDate)) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    return streak;
  }

  static Future<int> getLongestStreak({String? profileId}) async {
    final db = await database;
    final maps = await db.query(
      'sessions',
      columns: ['startTime'],
      where: profileId == null ? null : 'profileId = ?',
      whereArgs: profileId == null ? null : [profileId],
      orderBy: 'startTime ASC',
    );

    if (maps.isEmpty) return 0;

    final sessionDates =
        maps
            .map((m) {
              final dt = DateTime.fromMillisecondsSinceEpoch(
                m['startTime'] as int,
              );
              return DateTime(dt.year, dt.month, dt.day);
            })
            .toSet()
            .toList()
          ..sort();

    if (sessionDates.isEmpty) return 0;

    int longest = 1;
    int current = 1;

    for (int i = 1; i < sessionDates.length; i++) {
      final diff = sessionDates[i].difference(sessionDates[i - 1]).inDays;
      if (diff == 1) {
        current++;
        if (current > longest) longest = current;
      } else if (diff > 1) {
        current = 1;
      }
    }

    return longest;
  }

  static Future<void> updateSession(MeditationSession session) async {
    final db = await database;
    await db.update(
      'sessions',
      session.toMap(),
      where: 'id = ?',
      whereArgs: [session.id],
    );
  }

  static Future<void> deleteSession(String id) async {
    final db = await database;
    await db.delete('sessions', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteAllSessions({String? profileId}) async {
    final db = await database;
    await db.delete(
      'sessions',
      where: profileId == null ? null : 'profileId = ?',
      whereArgs: profileId == null ? null : [profileId],
    );
  }

  // Readable alias for the profile-deletion case of deleteAllSessions,
  // used when a profile itself is deleted.
  static Future<void> deleteSessionsForProfile(String profileId) =>
      deleteAllSessions(profileId: profileId);

  static Future<void> batchInsertSessions(
    List<MeditationSession> sessions,
  ) async {
    final db = await database;
    final batch = db.batch();
    for (final session in sessions) {
      batch.insert(
        'sessions',
        session.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  /// Wipes every profile's sessions and reinserts [sessions] verbatim.
  /// Used only for a full-device "overwrite" backup restore
  /// ([DataImportMode.overwrite]); anything scoped to one profile should
  /// use [replaceSessionsForProfile] instead.
  static Future<void> replaceAllSessions(
    List<MeditationSession> sessions,
  ) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('sessions');
      final batch = txn.batch();
      for (final session in sessions) {
        batch.insert(
          'sessions',
          session.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }

  /// Replaces just [profileId]'s sessions with [sessions], leaving every
  /// other profile's data untouched. Used by CSV/Excel re-import and by
  /// merge-mode backup restore for a single profile.
  ///
  /// Guards against two ways a caller could corrupt the table: a session
  /// tagged with the wrong profileId, or two sessions sharing an id
  /// (which `ConflictAlgorithm.abort` would otherwise silently drop).
  static Future<void> replaceSessionsForProfile(
    String profileId,
    List<MeditationSession> sessions,
  ) async {
    if (sessions.any((session) => session.profileId != profileId)) {
      throw const FormatException(
        'Imported sessions do not belong to the active profile.',
      );
    }
    final sessionIds = sessions.map((session) => session.id).toSet();
    if (sessionIds.length != sessions.length) {
      throw const FormatException('Imported session identifiers are invalid.');
    }

    final db = await database;
    await db.transaction((txn) async {
      await txn.delete(
        'sessions',
        where: 'profileId = ?',
        whereArgs: [profileId],
      );
      final batch = txn.batch();
      for (final session in sessions) {
        batch.insert(
          'sessions',
          session.toMap(),
          conflictAlgorithm: ConflictAlgorithm.abort,
        );
      }
      await batch.commit(noResult: true);
    });
  }

  static Future<int> getTotalSessionCount({String? profileId}) async {
    final db = await database;
    final result = profileId == null
        ? await db.rawQuery('SELECT COUNT(*) as count FROM sessions')
        : await db.rawQuery(
            'SELECT COUNT(*) as count FROM sessions WHERE profileId = ?',
            [profileId],
          );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  static Future<int> getTotalDurationAllTime({String? profileId}) async {
    final db = await database;
    final result = profileId == null
        ? await db.rawQuery(
            'SELECT SUM(durationSeconds) as total FROM sessions',
          )
        : await db.rawQuery(
            'SELECT SUM(durationSeconds) as total FROM sessions WHERE profileId = ?',
            [profileId],
          );
    return (result.first['total'] as int?) ?? 0;
  }

  static Future<double> getAverageDuration({String? profileId}) async {
    final db = await database;
    final result = profileId == null
        ? await db.rawQuery('SELECT AVG(durationSeconds) as avg FROM sessions')
        : await db.rawQuery(
            'SELECT AVG(durationSeconds) as avg FROM sessions WHERE profileId = ?',
            [profileId],
          );
    return (result.first['avg'] as double?) ?? 0.0;
  }

  /// Returns the timestamp (milliseconds since epoch) of the oldest session,
  /// or null if there are no sessions.
  static Future<int?> getOldestSessionTimestamp({String? profileId}) async {
    final db = await database;
    final result = profileId == null
        ? await db.rawQuery('SELECT MIN(startTime) as minTime FROM sessions')
        : await db.rawQuery(
            'SELECT MIN(startTime) as minTime FROM sessions WHERE profileId = ?',
            [profileId],
          );
    return result.first['minTime'] as int?;
  }
}
