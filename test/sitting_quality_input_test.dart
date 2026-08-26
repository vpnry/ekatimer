import 'package:ekatimer/services/translation_service.dart';
import 'package:ekatimer/widgets/sitting_quality_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('optional field accepts a user-entered decimal rating', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      TranslationService(
        translations: const {
          'en': {
            'quality.title': 'Quality of sitting (optional)',
            'quality.hint': '0.0–5.0',
            'quality.scaleHint': 'Select a score',
            'quality.invalid': 'Enter 0.0 to 5.0',
            'quality.clear': 'Clear',
            'quality.label': 'Quality',
            'quality.level.4': 'Few hindrances; the mind settles comfortably.',
            'quality.notesTitle': 'Notes on Quality',
            'quality.notesBody': 'Tracking quality reveals practice patterns.',
          },
        },
        locale: 'en',
        child: MaterialApp(
          home: Scaffold(body: SittingQualityInput(controller: controller)),
        ),
      ),
    );

    expect(find.byKey(const ValueKey('quality-number-input')), findsOneWidget);
    expect(find.byIcon(Icons.star_border_rounded), findsNothing);
    expect(find.byIcon(Icons.star_rounded), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('quality-number-input')),
      '0.0',
    );
    await tester.pump();
    expect(controller.text, '0.0');
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('quality-rating-preview')),
        matching: find.text('0.0'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('quality-rating-preview')),
        matching: find.byIcon(Icons.star_rounded),
      ),
      findsNothing,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('quality-rating-preview')),
        matching: find.byIcon(Icons.star_border_rounded),
      ),
      findsNWidgets(5),
    );
    expect(find.text('0.0*'), findsNothing);

    expect(
      find.text('Tracking quality reveals practice patterns.'),
      findsNothing,
    );
    await tester.tap(find.text('Notes on Quality'));
    await tester.pumpAndSettle();
    expect(
      find.text('Tracking quality reveals practice patterns.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Clear'));
    await tester.pump();
    expect(controller.text, isEmpty);
  });
}
