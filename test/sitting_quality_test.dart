import 'package:ekatimer/utils/sitting_quality.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('normalizes optional numeric quality to one decimal place', () {
    expect(SittingQuality.normalize(' 3.5 '), '3.5');
    expect(SittingQuality.normalize('4'), '4.0');
    expect(SittingQuality.normalize('2,5'), '2.5');
    expect(SittingQuality.normalize('0'), '0.0');
    expect(SittingQuality.normalize('0.9'), '0.9');
    expect(SittingQuality.normalize('   '), isNull);
    expect(SittingQuality.normalize('-0.1'), isNull);
    expect(SittingQuality.normalize('0.00'), isNull);
    expect(SittingQuality.normalize('5.1'), isNull);
    expect(SittingQuality.normalize('calm'), isNull);
  });

  test('formats plain-text ratings with a visual star glyph', () {
    expect(SittingQuality.display('0'), '0.0★');
    expect(SittingQuality.display('1'), '1.0★');
    expect(SittingQuality.display('3.5'), '3.5★');
    expect(SittingQuality.display('5'), '5.0★');
  });

  test('accepts one decimal from zero through five', () {
    expect(SittingQuality.rating('0.0'), 0);
    expect(SittingQuality.rating('0.9'), 0.9);
    expect(SittingQuality.rating('1.0'), 1);
    expect(SittingQuality.rating('4.5'), 4.5);
    expect(SittingQuality.rating('5.5'), isNull);
    expect(SittingQuality.rating('2.2'), 2.2);
    expect(SittingQuality.rating('2.25'), isNull);
  });

  test('treats blank as valid but rejects non-numeric input', () {
    expect(SittingQuality.isValidInput(''), isTrue);
    expect(SittingQuality.isValidInput('0.0'), isTrue);
    expect(SittingQuality.isValidInput('3.5'), isTrue);
    expect(SittingQuality.isValidInput('Deep and calm'), isFalse);
  });

  test('renders ratings as five stars', () {
    expect(SittingQuality.stars(0), '☆☆☆☆☆');
    expect(SittingQuality.stars(1), '★☆☆☆☆');
    expect(SittingQuality.stars(2), '★★☆☆☆');
    expect(SittingQuality.stars(5), '★★★★★');
  });

  test('preserves fractional fill across five visual star slots', () {
    expect(SittingQuality.starFillFractions(0), [0, 0, 0, 0, 0]);
    expect(SittingQuality.starFillFractions(3.5), [1, 1, 1, 0.5, 0]);
    expect(SittingQuality.starFillFractions(2.2), [1, 1, 0.2, 0, 0]);
    expect(SittingQuality.starFillFractions(5), [1, 1, 1, 1, 1]);
  });

  test(
    'averages numeric quality including zero and ignores missing values',
    () {
      expect(SittingQuality.average(['0', null, '4', 'own note']), 2.0);
      expect(SittingQuality.average([null, '', 'own note']), isNull);
    },
  );
}
