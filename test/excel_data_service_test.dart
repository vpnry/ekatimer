import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:ekatimer/models/meditation_session.dart';
import 'package:ekatimer/services/excel_data_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('creates a valid Excel archive with complete session columns', () {
    final session = MeditationSession(
      id: 'session-1',
      startTime: DateTime(2026, 8, 14, 13),
      endTime: DateTime(2026, 8, 14, 13, 30),
      durationSeconds: 1800,
      targetDurationSeconds: 1800,
      timerMode: 'timed',
      completed: true,
      quality: '4.5',
      notes: 'Calm & clear\u000B',
    );

    final bytes = ExcelDataService.buildWorkbookBytes([session]);
    final archive = ZipDecoder().decodeBytes(bytes);
    final names = archive.files.map((file) => file.name).toSet();

    expect(names, contains('[Content_Types].xml'));
    expect(names, contains('xl/workbook.xml'));
    expect(names, contains('xl/styles.xml'));
    expect(names, contains('xl/worksheets/sheet1.xml'));

    final worksheet = archive.files.singleWhere(
      (file) => file.name == 'xl/worksheets/sheet1.xml',
    );
    final xml = utf8.decode(worksheet.content as List<int>);

    expect(xml, contains('2026-08-14'));
    expect(xml, contains('13:00:00'));
    expect(xml, contains('13:30:00'));
    expect(xml, contains('00:30:00'));
    expect(
      xml,
      contains(
      '<c r="H2" t="inlineStr"><is><t xml:space="preserve">4.5</t></is></c>',
      ),
    );
    expect(xml, contains('Calm &amp; clear'));
    expect(xml, contains('<autoFilter ref="A1:I2"/>'));
  });
}
