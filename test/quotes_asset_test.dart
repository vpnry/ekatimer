import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('bundled practice reflections are available in en, id, and zh', () {
    final quotes =
        jsonDecode(File('assets/quotes/quotes.json').readAsStringSync())
            as Map<String, dynamic>;

    for (final locale in ['en', 'id', 'zh']) {
      final localeQuotes = quotes[locale] as List<dynamic>;
      expect(localeQuotes.length, greaterThanOrEqualTo(24));
      expect(localeQuotes.skip(6).length, 18);
      expect(localeQuotes.every((quote) => quote is String), isTrue);
      expect(
        localeQuotes.every((quote) => (quote as String).trim().isNotEmpty),
        isTrue,
      );
    }

    expect(
      (quotes['en'] as List<dynamic>)[6],
      startsWith('1. NOW is the precious and opportune moment'),
    );
    expect(
      (quotes['id'] as List<dynamic>)[6],
      startsWith('SEKARANG adalah saat yang berharga'),
    );
    expect((quotes['zh'] as List<dynamic>)[6], startsWith('1. 当下是珍贵的'));
  });
}
