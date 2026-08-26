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
    expect(find.byIcon(Icons.star_border_rounded), findsNWidgets(5));
    expect(find.byIcon(Icons.star_rounded), findsNWidgets(4));
    expect(find.text('3.5'), findsOneWidget);
    expect(find.bySemanticsLabel('3.5 / 5'), findsOneWidget);
  });

  testWidgets('0.0 keeps five empty star slots visible', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: QualityRatingLabel(rating: 0))),
    );

    expect(find.byType(FractionalStarIcon), findsNWidgets(5));
    expect(find.byIcon(Icons.star_border_rounded), findsNWidgets(5));
    expect(find.byIcon(Icons.star_rounded), findsNothing);
  });
}
