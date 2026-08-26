import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ekatimer/services/csv_data_service.dart';

void main() {
  group('CsvDataService parsing', () {
    test('accepts a UTF-8 BOM and preserves non-ASCII notes', () async {
      const csv =
          '\uFEFFstartTime,durationSeconds,notes\n'
          '2026-08-26T06:30:00,900,"Napas tenang, pikiran jernih 🙏"\n';

      final sessions = await CsvDataService.parseCsvBytes(
        utf8.encode(csv),
        profileId: 'profile-a',
      );

      expect(sessions, hasLength(1));
      expect(sessions.single.profileId, 'profile-a');
      expect(sessions.single.durationSeconds, 900);
      expect(sessions.single.notes, 'Napas tenang, pikiran jernih 🙏');
    });

    test('accepts the two mandatory columns without optional columns', () async {
      const csv =
          'startTime,durationSeconds\n'
          '2026-08-26T06:30:00,600\n';

      final sessions = await CsvDataService.parseCsvString(
        csv,
        profileId: 'profile-b',
      );

      expect(sessions, hasLength(1));
      expect(sessions.single.durationSeconds, 600);
      expect(sessions.single.notes, isNull);
    });
  });
}
