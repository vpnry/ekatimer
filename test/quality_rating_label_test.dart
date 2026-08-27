import 'package:ekatimer/widgets/quality_rating_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('3.5 renders three full stars, one half star, and one empty', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: QualityRatingLabel(rating: 3.5, iconSize: 16, starSpacing: 0),
        ),
      ),
    );

    final slots = tester
        .widgetList<FractionalStarIcon>(find.byType(FractionalStarIcon))
        .toList();
    expect(slots, hasLength(5));
    expect(slots.map((slot) => slot.fillFraction), [1, 1, 1, 0.5, 0]);
    expect(find.text('3.5'), findsOneWidget);
    expect(find.bySemanticsLabel('3.5 / 5'), findsOneWidget);
  });

  testWidgets('0.0 keeps five empty star slots visible', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: QualityRatingLabel(rating: 0))),
    );

    final slots = tester
        .widgetList<FractionalStarIcon>(find.byType(FractionalStarIcon))
        .toList();
    expect(slots, hasLength(5));
    expect(slots.every((slot) => slot.fillFraction == 0), isTrue);
  });

  group('partial star ink cutoff', () {
    test('empty and full slots cut exactly at the edges', () {
      expect(FractionalStarIcon.inkCutoff(0), 0);
      expect(FractionalStarIcon.inkCutoff(1), 1);
    });

    test('half cuts on the center line so 2.5 reads as a clean half star', () {
      // A star is symmetric about its vertical axis, so half its ink must sit
      // on either side of the middle. Sampling makes this approximate rather
      // than exact, hence the tolerance.
      expect(FractionalStarIcon.inkCutoff(0.5), closeTo(0.5, 0.01));
    });

    test('a tenth of the ink reaches well past the thin left point', () {
      // The old width-based cut put this at 0.1, inside the tapering point,
      // where it was invisible.
      expect(FractionalStarIcon.inkCutoff(0.1), greaterThan(0.2));
    });

    test('nine tenths stops well short of the right point', () {
      // Likewise 0.9 used to cut at 0.9 and looked like a whole star.
      expect(FractionalStarIcon.inkCutoff(0.9), lessThan(0.8));
    });

    test('each tenth cuts further right than the one below it', () {
      var previous = FractionalStarIcon.inkCutoff(0);
      for (var tenth = 1; tenth <= 10; tenth++) {
        final cutoff = FractionalStarIcon.inkCutoff(tenth / 10);
        expect(
          cutoff,
          greaterThan(previous),
          reason: '0.$tenth should be distinguishable from the step below',
        );
        previous = cutoff;
      }
    });

    test('cutoffs are symmetric about the center', () {
      for (var tenth = 1; tenth <= 4; tenth++) {
        final low = FractionalStarIcon.inkCutoff(tenth / 10);
        final high = FractionalStarIcon.inkCutoff(1 - tenth / 10);
        expect(
          low + high,
          closeTo(1, 0.02),
          reason: '0.$tenth and its complement should mirror each other',
        );
      }
    });
  });
}
