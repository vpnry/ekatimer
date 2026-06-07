// lib/services/csv_data_service.dart

import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/meditation_session.dart';
import 'database_service.dart';

class CsvDataService {
  static const _headers = [
    'id',
    'startTime',
    'endTime',
    'durationSeconds',
    'targetDurationSeconds',
    'timerMode',
    'completed',
    'notes',
  ];

  /// Exports all sessions to a CSV file and opens the share sheet.
  static Future<String> exportToCsv() async {
    final sessions = await DatabaseService.getAllSessions();

    final rows = <List<dynamic>>[_headers];
    for (final session in sessions) {
      rows.add([
        session.id,
        session.startTime.toIso8601String(),
        session.endTime?.toIso8601String() ?? '',
        session.durationSeconds.toString(),
        session.targetDurationSeconds.toString(),
        session.timerMode,
        session.completed ? '1' : '0',
        session.notes ?? '',
      ]);
    }

    final csvString = Csv().encode(rows);

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/ekatimer_sessions.csv');
    await file.writeAsString(csvString);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: 'ekaTimer Session Data',
        text: 'Meditation session data from ekaTimer',
      ),
    );

    return file.path;
  }

  /// Picks and parses a CSV file, returning the list of parsed sessions
  /// without importing them yet. Returns null if user cancels file picker.
  static Future<List<MeditationSession>?> pickAndParseCsv() async {
    // Use FileType.any + withData:true for iOS sandbox compatibility
    // (path can be null on iOS; bytes are always populated with withData:true)
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      return null;
    }

    final pickedFile = result.files.single;

    // Validate it's a CSV file
    final name = pickedFile.name.toLowerCase();
    if (!name.endsWith('.csv') && !name.endsWith('.txt')) {
      throw FormatException('Please select a CSV file.');
    }

    // Read file content — use bytes for iOS sandbox support
    String csvString;
    if (pickedFile.bytes != null) {
      csvString = String.fromCharCodes(pickedFile.bytes!);
    } else if (pickedFile.path != null) {
      csvString = await File(pickedFile.path!).readAsString();
    } else {
      throw Exception('Could not read file.');
    }

    if (csvString.trim().isEmpty) return [];

    final rows = Csv().decode(csvString);
    if (rows.length < 2) return []; // header only or empty

    // Find column indices from header row
    final headerRow =
        rows[0].map((e) => e.toString().trim().toLowerCase()).toList();
    final startTimeIdx = headerRow.indexOf('starttime');
    final durationIdx = headerRow.indexOf('durationseconds');

    if (startTimeIdx == -1 || durationIdx == -1) {
      throw FormatException(
        'CSV file must have "startTime" and "durationSeconds" columns. '
        'Found columns: ${headerRow.join(", ")}',
      );
    }

    final idIdx = headerRow.indexOf('id');
    final endTimeIdx = headerRow.indexOf('endtime');
    final targetDurationIdx = headerRow.indexOf('targetdurationseconds');
    final timerModeIdx = headerRow.indexOf('timermode');
    final completedIdx = headerRow.indexOf('completed');
    final notesIdx = headerRow.indexOf('notes');

    final sessions = <MeditationSession>[];
    final uuid = const Uuid();

    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.length < 3) continue;

      try {
        final startTime = DateTime.parse(row[startTimeIdx].toString().trim());

        final durationSeconds =
            int.tryParse(row[durationIdx].toString().trim()) ?? 0;

        if (durationSeconds <= 0) continue;

        final id = idIdx != -1 &&
                row.length > idIdx &&
                row[idIdx].toString().trim().isNotEmpty
            ? row[idIdx].toString().trim()
            : uuid.v4();

        final endTimeStr = endTimeIdx != -1 && row.length > endTimeIdx
            ? row[endTimeIdx].toString().trim()
            : '';
        final endTime =
            endTimeStr.isNotEmpty ? DateTime.tryParse(endTimeStr) : null;

        final targetDuration = targetDurationIdx != -1 &&
                row.length > targetDurationIdx
            ? int.tryParse(row[targetDurationIdx].toString().trim()) ?? 0
            : 0;

        final timerMode = timerModeIdx != -1 && row.length > timerModeIdx
            ? row[timerModeIdx].toString().trim()
            : 'timed';

        final completed = completedIdx != -1 && row.length > completedIdx
            ? row[completedIdx].toString().trim() == '1'
            : true;

        final notes = notesIdx != -1 && row.length > notesIdx
            ? row[notesIdx].toString().trim()
            : null;

        sessions.add(MeditationSession(
          id: id,
          startTime: startTime,
          endTime: endTime,
          durationSeconds: durationSeconds,
          targetDurationSeconds: targetDuration,
          timerMode: timerMode,
          completed: completed,
          notes: notes?.isNotEmpty == true ? notes : null,
        ));
      } catch (_) {
        continue;
      }
    }

    return sessions;
  }

  /// Imports the given sessions into the database.
  static Future<int> importSessions(List<MeditationSession> sessions) async {
    if (sessions.isEmpty) return 0;
    await DatabaseService.batchInsertSessions(sessions);
    return sessions.length;
  }
}
