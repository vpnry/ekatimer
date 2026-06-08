import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../providers/settings_provider.dart';
import '../services/translation_service.dart';
import '../theme/colors.dart';
import '../theme/app_theme.dart';
import '../utils/time_utils.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Make futures nullable to avoid LateInitializationError during first build.
  Future<List<dynamic>>? _weeklyDataFuture;
  Future<List<dynamic>>? _monthlyDataFuture;
  Future<List<dynamic>>? _yearlyDataFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // Safely load the data after the initial widget build frame completes.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    final provider = context.read<SessionProvider>();
    final loadFuture = provider.loadSessions();

    setState(() {
      _weeklyDataFuture = loadFuture.then((_) => provider.getWeeklyData());
      _monthlyDataFuture = loadFuture.then((_) => provider.getMonthlyData());
      _yearlyDataFuture = loadFuture.then((_) => provider.getYearlyData());
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Generates short durations to fit clean labels on small screens.
  String _formatShortDuration(int seconds) {
    if (seconds <= 0) return '';
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m';
    } else {
      return '${remainingSeconds}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = TranslationService.of(context);
    final sessionProvider = context.watch<SessionProvider>();
    final settingsProvider = context.watch<SettingsProvider>();

    final isDark =
        settingsProvider.themeMode == 'dark' ||
        (settingsProvider.themeMode == 'system' &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);
    final theme = isDark ? AppTheme.darkTheme : AppTheme.lightTheme;

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: Text(t.translate('stats.title')),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: t.translate('stats.overview')),
              Tab(text: t.translate('stats.weekly')),
              Tab(text: t.translate('stats.monthly')),
              Tab(text: t.translate('stats.yearly')),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(context, sessionProvider),
            _buildWeeklyTab(context, sessionProvider),
            _buildMonthlyTab(context, sessionProvider),
            _buildYearlyTab(context, sessionProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context, SessionProvider provider) {
    final t = TranslationService.of(context);
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildBigCard(
                  context,
                  label: t.translate('stats.totalSessions'),
                  value: '${provider.totalSessions}',
                  icon: Icons.self_improvement,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildBigCard(
                  context,
                  label: t.translate('stats.currentStreak'),
                  value:
                      '${provider.currentStreak} ${provider.currentStreak == 1 ? t.translate('stats.day') : t.translate('stats.days')}',
                  icon: Icons.local_fire_department,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildBigCard(
                  context,
                  label: t.translate('stats.totalTime'),
                  value: TimeUtils.formatDurationReadable(
                    provider.totalDurationSeconds,
                  ),
                  icon: Icons.access_time,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildBigCard(
                  context,
                  label: t.translate('stats.bestStreak'),
                  value:
                      '${provider.longestStreak} ${provider.longestStreak == 1 ? t.translate('stats.day') : t.translate('stats.days')}',
                  icon: Icons.emoji_events,
                  color: AppColors.primaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.show_chart_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.translate('stats.averageSession'),
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text(
                        TimeUtils.formatDurationReadable(
                          provider.averageDurationSeconds.round(),
                        ),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(t.translate('stats.thisPeriod'), style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          _buildPeriodRow(context, t.translate('stats.today'), provider.todayDurationSeconds),
          _buildPeriodRow(
            context,
            t.translate('stats.thisWeek'),
            provider.thisWeekDurationSeconds,
          ),
          _buildPeriodRow(
            context,
            t.translate('stats.thisMonth'),
            provider.thisMonthDurationSeconds,
          ),
          _buildPeriodRow(
            context,
            t.translate('stats.thisYear'),
            provider.thisYearDurationSeconds,
          ),
        ],
      ),
    );
  }

  Widget _buildBigCard(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodRow(BuildContext context, String label, int seconds) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          const Spacer(),
          Text(
            TimeUtils.formatDurationReadable(seconds),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyTab(BuildContext context, SessionProvider provider) {
    final t = TranslationService.of(context);
    if (_weeklyDataFuture == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return FutureBuilder<List<dynamic>>(
      future: _weeklyDataFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.translate('stats.weeklyTitle'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 260,
                child: _buildBarChart(
                  context,
                  data: snapshot.data!,
                  barColor: AppColors.primary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMonthlyTab(BuildContext context, SessionProvider provider) {
    final t = TranslationService.of(context);
    if (_monthlyDataFuture == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return FutureBuilder<List<dynamic>>(
      future: _monthlyDataFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.translate('stats.monthlyTitle'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 260,
                child: _buildBarChart(
                  context,
                  data: snapshot.data!,
                  barColor: AppColors.primaryLight,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildYearlyTab(BuildContext context, SessionProvider provider) {
    final t = TranslationService.of(context);
    if (_yearlyDataFuture == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return FutureBuilder<List<dynamic>>(
      future: _yearlyDataFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!;
        const itemsPerRow = 6;
        final rowCount = (data.length + itemsPerRow - 1) ~/ itemsPerRow;
        const rowHeight = 160.0;
        final chartHeight = rowCount * rowHeight;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.translate('stats.yearlyTitle'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: chartHeight,
                child: _buildYearlyChart(
                  context,
                  data: data,
                  barColor: AppColors.primary.withAlpha(180),
                  itemsPerRow: itemsPerRow,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Yearly bar chart that splits years into multiple rows (e.g., 6 per row)
  /// so all years are visible without being squished.
  Widget _buildYearlyChart(
    BuildContext context, {
    required List<dynamic> data,
    required Color barColor,
    int itemsPerRow = 6,
  }) {
    final t = TranslationService.of(context);
    if (data.isEmpty) {
      return Center(
        child: Text(
          t.translate('stats.noData'),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    // Group data into rows of itemsPerRow each.
    final rows = <List<dynamic>>[];
    for (int i = 0; i < data.length; i += itemsPerRow) {
      final end = (i + itemsPerRow < data.length) ? i + itemsPerRow : data.length;
      rows.add(data.sublist(i, end));
    }

    return Column(
      children: rows.map((rowData) {
        final maxSeconds = rowData.fold<int>(
          0,
          (max, d) => d.durationSeconds > max ? d.durationSeconds : max,
        );

        return Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Real data bars.
              ...rowData.map((point) {
                final int seconds = point.durationSeconds;
                final bool hasValue = seconds > 0;
                final height = maxSeconds > 0 ? (seconds / maxSeconds) * 100.0 : 0.0;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 14,
                          child: hasValue
                              ? FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    _formatShortDuration(seconds),
                                    style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: height.clamp(4.0, 100.0),
                          decoration: BoxDecoration(
                            color: hasValue
                                ? barColor
                                : Theme.of(context).dividerColor.withValues(
                                    alpha: 0.15,
                                  ),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(6),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          height: 14,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              point.label,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              // Invisible spacers for partial last row so bar widths stay consistent.
              if (rowData.length < itemsPerRow)
                ...List.generate(itemsPerRow - rowData.length, (_) => const Expanded(child: SizedBox.shrink())),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Unified bar chart component which implements text fitting to prevent wrapping issues.
  Widget _buildBarChart(
    BuildContext context, {
    required List<dynamic> data,
    required Color barColor,
  }) {
    final t = TranslationService.of(context);
    if (data.isEmpty) {
      return Center(
        child: Text(
          t.translate('stats.noData'),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    final maxSeconds = data.fold<int>(
      0,
      (max, d) => d.durationSeconds > max ? d.durationSeconds : max,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: data.map((point) {
        final int seconds = point.durationSeconds;
        final bool hasValue = seconds > 0;
        final height = maxSeconds > 0 ? (seconds / maxSeconds) * 150.0 : 0.0;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Display label only if time exists. Fit to container width.
                SizedBox(
                  height: 16,
                  child: hasValue
                      ? FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            _formatShortDuration(seconds),
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                const SizedBox(height: 4),
                // Chart columns with responsive round edges.
                Container(
                  height: height.clamp(4.0, 150.0),
                  decoration: BoxDecoration(
                    color: hasValue
                        ? barColor
                        : Theme.of(context).dividerColor.withValues(
                            alpha: 0.15,
                          ), // Dim inactive bars
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // X-Axis labels scaled down to prevent text wraps.
                SizedBox(
                  height: 16,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      point.label,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
