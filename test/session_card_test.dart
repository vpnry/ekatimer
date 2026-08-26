import 'package:ekatimer/widgets/session_card.dart';
import 'package:ekatimer/services/translation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildCard({
    DateTime? endTime,
    String? quality,
    String? notes,
    VoidCallback? onEdit,
  }) {
    return TranslationService(
      translations: const {
        'en': {
          'quality.label': 'Quality',
          'quality.level.3': 'Obstacles were overcome',
        },
      },
      locale: 'en',
      child: MaterialApp(
        home: Scaffold(
          body: SessionCard(
            id: 'session-1',
            startTime: DateTime(2026, 8, 13, 5, 52),
            endTime: endTime,
            durationSeconds: 11 * 60,
            quality: quality,
            notes: notes,
            onEdit: onEdit,
          ),
        ),
      ),
    );
  }

  testWidgets('shows the stored end time', (tester) async {
    await tester.pumpWidget(buildCard(endTime: DateTime(2026, 8, 13, 6, 5)));

    expect(find.text('5:52 AM → 6:05 AM'), findsOneWidget);
    expect(find.text('11m'), findsOneWidget);
  });

  testWidgets('derives end time when an old session has none', (tester) async {
    await tester.pumpWidget(buildCard());

    expect(find.text('5:52 AM → 6:03 AM'), findsOneWidget);
    expect(find.text('11m'), findsOneWidget);
  });

  testWidgets('shows decimal quality beside duration', (tester) async {
    await tester.pumpWidget(buildCard(quality: '3.5'));

    expect(find.text('5:52 AM → 6:03 AM'), findsOneWidget);
    expect(find.text('11m'), findsOneWidget);
    expect(find.text('3.5'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('session-quality')),
        matching: find.byIcon(Icons.star_rounded),
      ),
      findsNWidgets(4),
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('session-quality')),
        matching: find.byIcon(Icons.star_border_rounded),
      ),
      findsNWidgets(5),
    );
    expect(find.text('3.5*'), findsNothing);
  });

  testWidgets('does not expand legacy free-text quality', (tester) async {
    await tester.pumpWidget(buildCard(quality: 'Calm and focused'));

    expect(find.text('5:52 AM → 6:03 AM'), findsOneWidget);
    expect(find.byKey(const ValueKey('session-quality')), findsNothing);
  });

  testWidgets('shows only the note text supplied by the user', (tester) async {
    await tester.pumpWidget(
      buildCard(quality: '2', notes: 'Restless at the beginning.'),
    );

    expect(find.text('Restless at the beginning.'), findsOneWidget);
    expect(find.byIcon(Icons.notes_rounded), findsNothing);
  });

  testWidgets('shows the complete note without ellipsis', (tester) async {
    final note = List.filled(40, 'complete note').join(' ');
    await tester.pumpWidget(buildCard(notes: note));

    final noteText = tester.widget<Text>(
      find.byKey(const ValueKey('session-notes')),
    );
    expect(noteText.data, note);
    expect(noteText.maxLines, isNull);
    expect(noteText.overflow, isNull);
    expect(find.text('Show more'), findsNothing);
  });

  testWidgets('shows the pencil when an edit callback is supplied', (
    tester,
  ) async {
    await tester.pumpWidget(buildCard());
    expect(find.byKey(const ValueKey('session-edit-button')), findsNothing);

    await tester.pumpWidget(buildCard(onEdit: () {}));
    expect(find.byKey(const ValueKey('session-edit-button')), findsOneWidget);
  });
}
