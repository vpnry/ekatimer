import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../providers/settings_provider.dart';
import '../services/translation_service.dart';
import '../models/meditation_session.dart';
import '../theme/colors.dart';
import '../theme/app_theme.dart';
import '../utils/time_utils.dart';
import '../widgets/session_card.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SessionProvider>().loadSessions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = TranslationService.of(context);
    final sessionProvider = context.watch<SessionProvider>();
    final settingsProvider = context.watch<SettingsProvider>();

    final isDark = settingsProvider.themeMode == 'dark' ||
        (settingsProvider.themeMode == 'system' &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);
    final theme = isDark ? AppTheme.darkTheme : AppTheme.lightTheme;

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: Text(t.translate('history.title')),
          actions: [
            if (sessionProvider.sessions.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.delete_sweep_outlined),
                onPressed: _confirmClearAll,
                tooltip: t.translate('history.clearAll'),
              ),
          ],
        ),
        body: _buildContent(context, sessionProvider),
      ),
    );
  }

  Widget _buildContent(BuildContext context, SessionProvider provider) {
    final t = TranslationService.of(context);
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.sessions.isEmpty) {
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
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w300,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              t.translate('history.noSessionsDesc'),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
            ),
          ],
        ),
      );
    }

    final groupedSessions = <String, List<MeditationSession>>{};
    for (final session in provider.sessions) {
      final dateKey =
          '${session.startTime.year}-${session.startTime.month.toString().padLeft(2, '0')}-${session.startTime.day.toString().padLeft(2, '0')}';
      groupedSessions.putIfAbsent(dateKey, () => []);
      groupedSessions[dateKey]!.add(session);
    }

    final sortedDates = groupedSessions.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final dateKey = sortedDates[index];
        final sessions = groupedSessions[dateKey]!;
        final date = DateTime.parse(dateKey);

        final totalSeconds =
            sessions.fold(0, (sum, s) => sum + s.durationSeconds);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Text(
                    TimeUtils.formatDate(date),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
            ...sessions.map((session) => SessionCard(
                  id: session.id,
                  startTime: session.startTime,
                  durationSeconds: session.durationSeconds,
                  completed: session.completed,
                  onDelete: () => _confirmDelete(session.id),
                )),
          ],
        );
      },
    );
  }

  void _confirmDelete(String id) {
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
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(t.translate('history.delete')),
          ),
        ],
      ),
    );
  }

  void _confirmClearAll() {
    final t = TranslationService.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.translate('history.clearAllTitle')),
        content: Text(t.translate('history.clearAllConfirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(t.translate('history.cancel')),
          ),
          TextButton(
            onPressed: () {
              context.read<SessionProvider>().deleteAllSessions();
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(t.translate('history.clearAllBtn')),
          ),
        ],
      ),
    );
  }
}
