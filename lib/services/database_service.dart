// lib/services/database_service.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import '../utils/constants.dart';
import '../models/meditation_session.dart';

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
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE sessions (
        id TEXT PRIMARY KEY,
        startTime INTEGER NOT NULL,
        endTime INTEGER,
        durationSeconds INTEGER NOT NULL,
        targetDurationSeconds INTEGER NOT NULL DEFAULT 0,
        timerMode TEXT NOT NULL DEFAULT 'timed',
        completed INTEGER NOT NULL DEFAULT 1,
        notes TEXT
      )
    ''');
  }

  static Future<void> insertSession(MeditationSession session) async {
    final db = await database;
    await db.insert(
      'sessions',
      session.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<MeditationSession>> getAllSessions() async {
    final db = await database;
    final maps = await db.query(
      'sessions',
      orderBy: 'startTime DESC',
    );
    return maps.map((map) => MeditationSession.fromMap(map)).toList();
  }

  static Future<List<MeditationSession>> getSessionsInRange(
    DateTime start,
    DateTime end,
  ) async {
    final db = await database;
    final startMs = start.millisecondsSinceEpoch;
    final endMs = end.millisecondsSinceEpoch;
    final maps = await db.query(
      'sessions',
      where: 'startTime >= ? AND startTime < ?',
      whereArgs: [startMs, endMs],
      orderBy: 'startTime DESC',
    );
    return maps.map((map) => MeditationSession.fromMap(map)).toList();
  }

  static Future<List<MeditationSession>> getSessionsForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return getSessionsInRange(startOfDay, endOfDay);
  }

  static Future<int> getTotalDurationInRange(DateTime start, DateTime end) async {
    final sessions = await getSessionsInRange(start, end);
    int total = 0;
    for (final session in sessions) {
      total += session.durationSeconds;
    }
    return total;
  }

  static Future<int> getTodayDuration() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    return getTotalDurationInRange(startOfDay, startOfDay.add(const Duration(days: 1)));
  }

  static Future<int> getTotalDurationForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return getTotalDurationInRange(startOfDay, endOfDay);
  }

  static Future<int> getSessionCountInRange(DateTime start, DateTime end) async {
    final sessions = await getSessionsInRange(start, end);
    return sessions.length;
  }

  static Future<int> getCurrentStreak() async {
    final db = await database;
    final maps = await db.query(
      'sessions',
      columns: ['startTime'],
      orderBy: 'startTime DESC',
    );

    if (maps.isEmpty) return 0;

    final sessionDates = maps.map((m) {
      final dt = DateTime.fromMillisecondsSinceEpoch(m['startTime'] as int);
      return DateTime(dt.year, dt.month, dt.day);
    }).toSet().toList()
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

  static Future<int> getLongestStreak() async {
    final db = await database;
    final maps = await db.query(
      'sessions',
      columns: ['startTime'],
      orderBy: 'startTime ASC',
    );

    if (maps.isEmpty) return 0;

    final sessionDates = maps.map((m) {
      final dt = DateTime.fromMillisecondsSinceEpoch(m['startTime'] as int);
      return DateTime(dt.year, dt.month, dt.day);
    }).toSet().toList()
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

  static Future<void> deleteSession(String id) async {
    final db = await database;
    await db.delete('sessions', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteAllSessions() async {
    final db = await database;
    await db.delete('sessions');
  }

  static Future<void> batchInsertSessions(List<MeditationSession> sessions) async {
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

  static Future<int> getTotalSessionCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM sessions');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  static Future<int> getTotalDurationAllTime() async {
    final db = await database;
    final result = await db.rawQuery('SELECT SUM(durationSeconds) as total FROM sessions');
    return (result.first['total'] as int?) ?? 0;
  }

  static Future<double> getAverageDuration() async {
    final db = await database;
    final result = await db.rawQuery('SELECT AVG(durationSeconds) as avg FROM sessions');
    return (result.first['avg'] as double?) ?? 0.0;
  }
}
