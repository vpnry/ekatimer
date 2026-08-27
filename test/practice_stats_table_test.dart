import 'package:ekatimer/models/meditation_session.dart';
import 'package:ekatimer/services/translation_service.dart';
import 'package:ekatimer/widgets/practice_stats_table.dart';
import 'package:ekatimer/widgets/quality_rating_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

MeditationSession _session(int index, DateTime date, {String? quality}) =>
    MeditationSession(
      id: 'session-$index',
      startTime: date.add(Duration(hours: index)),
      durationSeconds: (index + 1) * 60,
      quality: quality,
    );

Widget _app(Widget child) => TranslationService(
  translations: const {
    'en': {
      'stats.calendar.date': 'Date',
      'stats.noData': 'No data yet',
      'common.total': 'Total',
      'quality.label': 'Quality',
    },
  },
  locale: 'en',
  child: MaterialApp(home: Scaffold(body: child)),
);

void main() {
  testWidgets('shows decimal quality columns when a quality exists', (
    tester,
  ) async {
    final date = DateTime(2026, 8, 10);
    await tester.pumpWidget(
      _app(
        PracticeStatsTable(
          sessions: [_session(0, date, quality: '0.0')],
          dateLabelBuilder: (_) => 'Mon, 10 Aug',
        ),
      ),
    );

    expect(find.text('Date'), findsOneWidget);
    expect(find.text('Mon, 10 Aug'), findsOneWidget);
    expect(find.text('T'), findsOneWidget);
    expect(find.text('Q1'), findsOneWidget);
    expect(find.text('Q5'), findsOneWidget);
    expect(find.byKey(const ValueKey('practice-duration-0-5')), findsOneWidget);
    expect(find.byKey(const ValueKey('practice-quality-0-5')), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('practice-quality-0-1')),
        matching: find.text('0.0'),
      ),
      findsOneWidget,
    );
    final zeroSlots = tester
        .widgetList<FractionalStarIcon>(
          find.descendant(
            of: find.byKey(const ValueKey('practice-quality-0-1')),
            matching: find.byType(FractionalStarIcon),
          ),
        )
        .toList();
    expect(zeroSlots, hasLength(5));
    expect(zeroSlots.every((slot) => slot.fillFraction == 0), isTrue);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('practice-quality-0-2')),
        matching: find.text(''),
      ),
      findsOneWidget,
    );
  });

  testWidgets('keeps a sixth chronological session and quality visible', (
    tester,
  ) async {
    final date = DateTime(2026, 8, 11);
    final sessions = List.generate(
      6,
      (index) => _session(index, date, quality: '${(index % 5) + 1}.0'),
    ).reversed.toList();

    await tester.pumpWidget(_app(PracticeStatsTable(sessions: sessions)));

    expect(find.text('Q6'), findsOneWidget);
    expect(find.byKey(const ValueKey('practice-duration-0-6')), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('practice-duration-0-6')),
        matching: find.text('6m'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('practice-quality-0-6')),
        matching: find.text('1.0'),
      ),
      findsOneWidget,
    );
    final sixthSlots = tester
        .widgetList<FractionalStarIcon>(
          find.descendant(
            of: find.byKey(const ValueKey('practice-quality-0-6')),
            matching: find.byType(FractionalStarIcon),
          ),
        )
        .toList();
    expect(sixthSlots.map((slot) => slot.fillFraction), [1, 0, 0, 0, 0]);
  });

  testWidgets('uses a horizontal scroll view for the wide table', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _app(
        PracticeStatsTable(
          sessions: [_session(0, DateTime(2026, 8, 12), quality: '3')],
        ),
      ),
    );

    final scrollView = tester.widget<SingleChildScrollView>(
      find.byKey(PracticeStatsTable.horizontalScrollKey),
    );
    expect(scrollView.scrollDirection, Axis.horizontal);
    expect(
      tester
          .state<ScrollableState>(
            find.descendant(
              of: find.byKey(PracticeStatsTable.horizontalScrollKey),
              matching: find.byType(Scrollable),
            ),
          )
          .position
          .maxScrollExtent,
      greaterThan(0),
    );
  });

  testWidgets('hides all quality columns when no quality was entered', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(PracticeStatsTable(sessions: [_session(0, DateTime(2026, 8, 12))])),
    );

    expect(find.text('Q1'), findsNothing);
    expect(find.byKey(const ValueKey('practice-quality-0-1')), findsNothing);
  });

  testWidgets('explicitly hides quality columns when calendar toggle is off', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        PracticeStatsTable(
          sessions: [_session(0, DateTime(2026, 8, 12), quality: '3.5')],
          showQuality: false,
        ),
      ),
    );

    expect(find.text('Q1'), findsNothing);
    expect(find.text('Q5'), findsNothing);
    expect(find.byKey(const ValueKey('practice-quality-0-1')), findsNothing);
  });

  testWidgets('shows the translated empty-state label', (tester) async {
    await tester.pumpWidget(_app(const PracticeStatsTable(sessions: [])));

    expect(find.text('No data yet'), findsOneWidget);
  });
}
