import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/meditation_session.dart';
import '../models/practice_table_data.dart';
import '../services/translation_service.dart';
import '../theme/colors.dart';
import '../utils/sitting_quality.dart';
import '../utils/time_utils.dart';
import 'quality_rating_label.dart';

typedef PracticeDateLabelBuilder = String Function(DateTime date);
typedef PracticeDurationLabelBuilder = String Function(int durationSeconds);

/// A horizontally scrollable, date-based table of practice sessions.
///
/// Duration columns are numbered `1..N`, followed by the daily total (`T`)
/// and, when at least one quality was entered, one matching quality column
/// (`Q1..QN`) per session. Five session columns are always shown and extra
/// sessions are never hidden.
class PracticeStatsTable extends StatelessWidget {
  static const Key horizontalScrollKey = Key(
    'practice-stats-table-horizontal-scroll',
  );

  final Iterable<MeditationSession> sessions;
  final DateTime? startDate;
  final DateTime? endDate;
  final int minimumSessionColumns;
  final bool showQuality;
  final PracticeDateLabelBuilder? dateLabelBuilder;
  final PracticeDurationLabelBuilder? durationLabelBuilder;

  const PracticeStatsTable({
    super.key,
    required this.sessions,
    this.startDate,
    this.endDate,
    this.minimumSessionColumns = PracticeTableData.minimumVisibleSessionColumns,
    this.showQuality = true,
    this.dateLabelBuilder,
    this.durationLabelBuilder,
  });

  static const double _dateColumnWidth = 118;
  static const double _durationColumnWidth = 72;
  static const double _totalColumnWidth = 76;
  static const double _qualityColumnWidth = 52;

  @override
  Widget build(BuildContext context) {
    final translations = TranslationService.of(context);
    final data = PracticeTableData.fromSessions(
      sessions: sessions,
      startDate: startDate,
      endDate: endDate,
      minimumSessionColumns: minimumSessionColumns,
    );

    if (data.rows.isEmpty) {
      return Center(child: Text(translations.translate('stats.noData')));
    }

    final theme = Theme.of(context);
    final hasQuality = data.rows.any(
      (day) => day.sessions.any(
        (session) => SittingQuality.rating(session.quality) != null,
      ),
    );
    final showQualityColumns = showQuality && hasQuality;
    final columnWidths = <int, TableColumnWidth>{
      0: const FixedColumnWidth(_dateColumnWidth),
    };
    var columnIndex = 1;
    for (var index = 0; index < data.sessionColumnCount; index++) {
      columnWidths[columnIndex++] = const FixedColumnWidth(
        _durationColumnWidth,
      );
    }
    columnWidths[columnIndex++] = const FixedColumnWidth(_totalColumnWidth);
    if (showQualityColumns) {
      for (var index = 0; index < data.sessionColumnCount; index++) {
        columnWidths[columnIndex++] = const FixedColumnWidth(
          _qualityColumnWidth,
        );
      }
    }

    final tableWidth =
        _dateColumnWidth +
        data.sessionColumnCount * _durationColumnWidth +
        _totalColumnWidth +
        (showQualityColumns
            ? data.sessionColumnCount * _qualityColumnWidth
            : 0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : tableWidth;
        return SingleChildScrollView(
          key: horizontalScrollKey,
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: math.max(tableWidth, availableWidth),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Table(
                border: TableBorder.all(
                  color: theme.dividerColor.withValues(alpha: 0.55),
                  width: 0.7,
                ),
                columnWidths: columnWidths,
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  _buildHeaderRow(
                    context,
                    data.sessionColumnCount,
                    showQuality: showQualityColumns,
                  ),
                  for (var index = 0; index < data.rows.length; index++)
                    _buildDayRow(
                      context,
                      data.rows[index],
                      index,
                      data.sessionColumnCount,
                      showQuality: showQualityColumns,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  TableRow _buildHeaderRow(
    BuildContext context,
    int sessionColumnCount, {
    required bool showQuality,
  }) {
    final translations = TranslationService.of(context);
    return TableRow(
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
      ),
      children: [
        _cell(
          context,
          translations.translate('stats.calendar.date'),
          isHeader: true,
        ),
        for (var index = 1; index <= sessionColumnCount; index++)
          _cell(context, '$index', isHeader: true),
        Semantics(
          label: translations.translate('common.total'),
          excludeSemantics: true,
          child: _cell(context, 'T', isHeader: true),
        ),
        if (showQuality)
          for (var index = 1; index <= sessionColumnCount; index++)
            Semantics(
              label: '${translations.translate('quality.label')} $index',
              excludeSemantics: true,
              child: _cell(context, 'Q$index', isHeader: true),
            ),
      ],
    );
  }

  TableRow _buildDayRow(
    BuildContext context,
    PracticeTableDay day,
    int rowIndex,
    int sessionColumnCount, {
    required bool showQuality,
  }) {
    final theme = Theme.of(context);
    final dateLabel =
        dateLabelBuilder?.call(day.date) ?? TimeUtils.formatDate(day.date);
    final totalLabel = day.totalDurationSeconds == 0
        ? '0'
        : _formatDuration(day.totalDurationSeconds);

    return TableRow(
      decoration: rowIndex.isOdd
          ? BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.22,
              ),
            )
          : null,
      children: [
        _cell(
          context,
          dateLabel,
          key: ValueKey('practice-date-$rowIndex'),
          isDate: true,
        ),
        for (var index = 0; index < sessionColumnCount; index++)
          _cell(
            context,
            index < day.sessions.length
                ? _formatDuration(day.sessions[index].durationSeconds)
                : '',
            key: ValueKey('practice-duration-$rowIndex-${index + 1}'),
            hasValue: index < day.sessions.length,
          ),
        _cell(
          context,
          totalLabel,
          key: ValueKey('practice-total-$rowIndex'),
          hasValue: day.totalDurationSeconds > 0,
        ),
        if (showQuality)
          for (var index = 0; index < sessionColumnCount; index++)
            _cell(
              context,
              '',
              key: ValueKey('practice-quality-$rowIndex-${index + 1}'),
              hasValue: day.qualityAt(index) != null,
              qualityRating: day.qualityAt(index),
            ),
      ],
    );
  }

  String _formatDuration(int seconds) =>
      durationLabelBuilder?.call(math.max(0, seconds)) ??
      TimeUtils.formatDurationReadable(math.max(0, seconds));

  Widget _cell(
    BuildContext context,
    String text, {
    Key? key,
    bool isHeader = false,
    bool isDate = false,
    bool hasValue = false,
    double? qualityRating,
  }) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall?.copyWith(
      color: hasValue ? AppColors.primary : null,
      fontWeight: isHeader || isDate || hasValue
          ? FontWeight.w700
          : FontWeight.w400,
    );
    return Container(
      key: key,
      constraints: const BoxConstraints(minHeight: 50),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      color: hasValue ? AppColors.primary.withValues(alpha: 0.045) : null,
      child: qualityRating == null
          ? Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: textStyle,
            )
          : FittedBox(
              fit: BoxFit.scaleDown,
              child: QualityRatingLabel(
                rating: qualityRating,
                iconSize: 8,
                gap: 1,
                starSpacing: 0.5,
                compact: true,
                style: textStyle,
              ),
            ),
    );
  }
}
