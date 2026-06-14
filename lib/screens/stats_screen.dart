import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../providers/settings_provider.dart';
import '../services/translation_service.dart';
import '../services/csv_data_service.dart';
import '../theme/colors.dart';
import '../theme/app_theme.dart';
import '../utils/time_utils.dart';
import '../models/meditation_session.dart';
import '../widgets/session_card.dart';
import '../widgets/edit_session_dialog.dart';
import '../services/database_service.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late DateTime _sessionStartDate;
  late DateTime _sessionEndDate;

  DateTime? _oldestDate;

  // Make futures nullable to avoid LateInitializationError during first build.
  Future<List<dynamic>>? _weeklyDataFuture;
  Future<List<dynamic>>? _monthlyDataFuture;
  Future<List<dynamic>>? _yearlyDataFuture;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _sessionEndDate = DateTime(now.year, now.month, now.day);
    _sessionStartDate = _sessionEndDate.subtract(const Duration(days: 6));
    _tabController = TabController(length: 5, vsync: this);

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

    _refreshOldestDate();
  }

  void _refreshOldestDate() {
    DatabaseService.getOldestSessionTimestamp().then((timestamp) {
      if (timestamp != null && mounted) {
        setState(() {
          _oldestDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
        });
      }
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
        (settingsProvider.themeMode == 'deviceTheme' &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);
    final theme = isDark ? AppTheme.darkTheme : AppTheme.lightTheme;

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: Text(t.translate('stats.title')),
          // Delete-all button is inside the Sessions tab
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: t.translate('stats.overview')),
              Tab(text: t.translate('stats.sessions')),
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
            _buildSessionsTab(context, sessionProvider),
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
          Text(
            t.translate('stats.thisPeriod'),
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          _buildPeriodRow(
            context,
            t.translate('stats.today'),
            provider.todayDurationSeconds,
          ),
          _buildPeriodRow(
            context,
            t.translate('stats.thisWeek'),
            provider.thisWeekDurationSeconds,
          ),
          _buildPeriodRow(
            context,
            t.translate('stats.last14Days'),
            provider.last14DaysDurationSeconds,
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

  Widget _buildSessionsTab(BuildContext context, SessionProvider provider) {
    final t = TranslationService.of(context);
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Filter sessions by date range
    final filteredSessions = provider.sessions
        .where((s) {
          final d = DateTime(
            s.startTime.year,
            s.startTime.month,
            s.startTime.day,
          );
          return d.isAtSameMomentAs(_sessionStartDate) ||
              d.isAfter(_sessionStartDate);
        })
        .where((s) {
          final d = DateTime(
            s.startTime.year,
            s.startTime.month,
            s.startTime.day,
          );
          return d.isAtSameMomentAs(_sessionEndDate) ||
              d.isBefore(_sessionEndDate);
        })
        .toList();

    if (filteredSessions.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.self_improvement,
              size: 80,
              color: AppColors.primaryLight.withAlpha(100),
            ),
            const SizedBox(height: 16),
            Text(
              t.translate('history.noSessions'),
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 8),
            Text(
              t.translate('history.noSessionsDesc'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      );
    }

    final groupedSessions = <String, List<MeditationSession>>{};
    for (final session in filteredSessions) {
      final dateKey =
          '${session.startTime.year}-${session.startTime.month.toString().padLeft(2, '0')}-${session.startTime.day.toString().padLeft(2, '0')}';
      groupedSessions.putIfAbsent(dateKey, () => []);
      groupedSessions[dateKey]!.add(session);
    }

    final sortedDates = groupedSessions.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Column(
      children: [
        // ─── Action bar ──────────────────────────────────────────
        _buildSessionsActionBar(context, provider, filteredSessions),
        const Divider(height: 1),
        // ─── Session list ────────────────────────────────────────
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 24),
            itemCount: sortedDates.length,
            itemBuilder: (context, index) {
              final dateKey = sortedDates[index];
              final sessions = groupedSessions[dateKey]!;
              final date = DateTime.parse(dateKey);

              final totalSeconds = sessions.fold(
                0,
                (sum, s) => sum + s.durationSeconds,
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Row(
                      children: [
                        Text(
                          TimeUtils.formatDate(date),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(20),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${sessions.length} ${sessions.length == 1 ? t.translate('history.session') : t.translate('history.sessions')}',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          TimeUtils.formatDurationReadable(totalSeconds),
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondaryLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...sessions.map(
                    (session) => SessionCard(
                      id: session.id,
                      startTime: session.startTime,
                      durationSeconds: session.durationSeconds,
                      completed: session.completed,
                      onDelete: () => _confirmDelete(context, session.id),
                      onEdit: () => _onEditSession(context, session),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSessionsActionBar(
    BuildContext context,
    SessionProvider provider,
    List<MeditationSession> filteredSessions,
  ) {
    final t = TranslationService.of(context);
    final theme = Theme.of(context);

    final filteredTotalSeconds = filteredSessions.fold(
      0,
      (sum, s) => sum + s.durationSeconds,
    );
    final sessionCount = filteredSessions.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Row 1: From / To date pickers ──
          Row(
            children: [
              _buildDateChip(
                context,
                label: t.translate('stats.from'),
                date: _sessionStartDate,
                onTap: () => _pickDate(isStart: true),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: AppColors.textSecondaryLight,
                ),
              ),
              _buildDateChip(
                context,
                label: t.translate('stats.to'),
                date: _sessionEndDate,
                onTap: () => _pickDate(isStart: false),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // ── Row 2: Summary + action buttons ──
          Row(
            children: [
              Expanded(
                child: Text(
                  '$sessionCount ${sessionCount == 1 ? t.translate('history.session') : t.translate('history.sessions')} — ${TimeUtils.formatDurationReadable(filteredTotalSeconds)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // ── Copy button ──
              IconButton(
                icon: const Icon(Icons.copy_rounded, size: 20),
                tooltip: t.translate('stats.copy'),
                onPressed: () => _copySessionsToClipboard(
                  context,
                  filteredSessions,
                  _sessionStartDate,
                  _sessionEndDate,
                ),
                visualDensity: VisualDensity.compact,
              ),
              // ── Export button ──
              IconButton(
                icon: const Icon(Icons.file_upload_outlined, size: 20),
                tooltip: t.translate('stats.exportFiltered'),
                onPressed: () => _exportFilteredSessions(
                  context,
                  filteredSessions,
                  _sessionStartDate,
                  _sessionEndDate,
                ),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateChip(
    BuildContext context, {
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today,
              size: 14,
              color: AppColors.textSecondaryLight,
            ),
            const SizedBox(width: 4),
            Text(
              '$label ${_formatShortDate(date)}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  String _formatShortDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _pickDate({required bool isStart}) async {
    final initial = isStart ? _sessionStartDate : _sessionEndDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: _oldestDate ?? DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _sessionStartDate = DateTime(picked.year, picked.month, picked.day);
          // Ensure start is not after end
          if (_sessionStartDate.isAfter(_sessionEndDate)) {
            _sessionEndDate = _sessionStartDate;
          }
        } else {
          _sessionEndDate = DateTime(picked.year, picked.month, picked.day);
          // Ensure end is not before start
          if (_sessionEndDate.isBefore(_sessionStartDate)) {
            _sessionStartDate = _sessionEndDate;
          }
        }
      });
    }
  }

  void _copySessionsToClipboard(
    BuildContext context,
    List<MeditationSession> sessions,
    DateTime startDate,
    DateTime endDate,
  ) {
    final t = TranslationService.of(context);

    final buffer = StringBuffer();
    final rangeLabel =
        '${_formatShortDate(startDate)} — ${_formatShortDate(endDate)}';
    buffer.writeln('${t.translate('stats.title')} — $rangeLabel');
    buffer.writeln('─' * 32);
    buffer.writeln();

    // Group by date
    final grouped = <String, List<MeditationSession>>{};
    for (final session in sessions) {
      final key =
          '${session.startTime.year}-${session.startTime.month.toString().padLeft(2, '0')}-${session.startTime.day.toString().padLeft(2, '0')}';
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(session);
    }

    final sortedDates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    int totalSeconds = 0;
    for (final dateKey in sortedDates) {
      final daySessions = grouped[dateKey]!;
      final dayTotal = daySessions.fold(0, (sum, s) => sum + s.durationSeconds);
      totalSeconds += dayTotal;

      buffer.writeln(
        '$dateKey — ${TimeUtils.formatDurationReadable(dayTotal)} (${daySessions.length} ${daySessions.length == 1 ? t.translate('history.session') : t.translate('history.sessions')})',
      );
      for (final session in daySessions) {
        final status = session.completed ? '✓' : '✗';
        buffer.writeln(
          '  $status ${TimeUtils.formatDurationReadable(session.durationSeconds)} ${session.notes != null ? '- ${session.notes}' : ''}',
        );
      }
    }

    buffer.writeln();
    buffer.writeln('─' * 32);
    final count = sessions.length;
    buffer.writeln(
      '${t.translate('stats.totalTime')}: ${TimeUtils.formatDurationReadable(totalSeconds)} — $count ${count == 1 ? t.translate('history.session') : t.translate('history.sessions')}',
    );

    Clipboard.setData(ClipboardData(text: buffer.toString()));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.translate('stats.copied')),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _exportFilteredSessions(
    BuildContext context,
    List<MeditationSession> sessions,
    DateTime startDate,
    DateTime endDate,
  ) async {
    if (sessions.isEmpty) return;

    try {
      final filename =
          'ekatimer_${_formatShortDate(startDate)}_${_formatShortDate(endDate)}.csv';
      await CsvDataService.exportSessionsToCsv(sessions, filename: filename);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              TranslationService.of(context).translate('stats.exported'),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${TranslationService.of(context).translate('stats.exportFailed')}: $e',
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _onEditSession(
    BuildContext context,
    MeditationSession session,
  ) async {
    final updated = await showEditSessionDialog(context, session);
    if (updated != null && context.mounted) {
      await context.read<SessionProvider>().updateSession(updated);
      _refreshOldestDate();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(TranslationService.of(context).translate('editSession.updated')),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _confirmDelete(BuildContext context, String id) {
    final t = TranslationService.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.translate('history.deleteSession')),
        content: Text(t.translate('history.deleteConfirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(t.translate('history.cancel')),
          ),
          TextButton(
            onPressed: () {
              context.read<SessionProvider>().deleteSession(id);
              _refreshOldestDate();
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(t.translate('history.delete')),
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
      final end = (i + itemsPerRow < data.length)
          ? i + itemsPerRow
          : data.length;
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
                final height = maxSeconds > 0
                    ? (seconds / maxSeconds) * 100.0
                    : 0.0;

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
                                : Theme.of(
                                    context,
                                  ).dividerColor.withValues(alpha: 0.15),
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
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
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
                ...List.generate(
                  itemsPerRow - rowData.length,
                  (_) => const Expanded(child: SizedBox.shrink()),
                ),
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
