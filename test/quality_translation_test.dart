import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('English quality guidance contains all six levels and honesty note', () {
    final translations =
        jsonDecode(
              File('assets/translations/translations.json').readAsStringSync(),
            )
            as Map<String, dynamic>;
    final english = translations['en'] as Map<String, dynamic>;

    expect(List.generate(6, (index) => english['quality.level.$index']), [
      'Use postures other than sitting for most of the session.',
      'Just sit, but the mind is all over the place, cannot settle on meditation object.',
      'There are hindrances and the mind is able to overcome the hindrances at the end of sitting.',
      'There are hindrances, mind is able to overcome the hindrances and eventually settle on meditation object.',
      'Little hindrances, the mind is comfortably settled on the meditation object with some wandering thoughts.',
      'Perfect sitting. The mind is one with the meditation object. No wandering thoughts at all.',
    ]);

    final notes = english['quality.notesBody'] as String;
    expect(notes, contains('observe patterns in her practice'));
    expect(notes, contains('troubleshoot her own meditation problems'));
    expect(notes, contains('absolute honesty with yourself'));
    expect(notes, contains('defeats the purpose'));
  });
}
