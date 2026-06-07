import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../services/translation_service.dart';
import 'home_screen.dart';
import '../providers/timer_provider.dart';
import '../providers/settings_provider.dart';
import '../theme/colors.dart';
import '../theme/app_theme.dart';
import '../utils/time_utils.dart';

class CompleteScreen extends StatefulWidget {
  final int durationSeconds;
  final bool isTimedOut;

  const CompleteScreen({
    super.key,
    required this.durationSeconds,
    this.isTimedOut = true,
  });

  @override
  State<CompleteScreen> createState() => _CompleteScreenState();
}

class _CompleteScreenState extends State<CompleteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
    );
    _opacityAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
    );
    _controller.forward();

    // Reset the timer immediately when CompleteScreen is shown.
    // This puts TimerProvider into idle state, which _AppEntryState
    // detects via _onTimerStateChanged → clears _hasActiveSession
    // → sets _sessionResetComplete = true.
    // The Navigator stack is NOT touched here; CompleteScreen stays
    // visible for the user to read their stats. The stack is only
    // cleared when the user taps "Back to Home" OR when a widget tap
    // comes in (via _ensureMeditationScreen / _resetToHomeScreen).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<TimerProvider>().reset();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        backgroundColor: theme.colorScheme.surface,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.success.withAlpha(30),
                        border: Border.all(
                          color: AppColors.success,
                          width: 3,
                        ),
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 60,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  FadeTransition(
                    opacity: _opacityAnimation,
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Timer is already reset (done in initState).
                              // Just navigate home — _AppEntry's
                              // _onTimerStateChanged has already marked the
                              // app as reset, so the next widget tap will
                              // start a fresh session.
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => const MeditationHomeScreen(),
                                ),
                                (route) => false,
                              );
                            },
                            child: Text(t.translate('complete.backToHome')),
                          ),
                        ),

                        const SizedBox(height: 24),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white.withAlpha(15)
                                : Colors.black.withAlpha(8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Text(
                                t.translate('complete.meditationTime'),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: AppColors.textSecondaryLight,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                TimeUtils.formatDuration(widget.durationSeconds),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 48,
                                      letterSpacing: 4,
                                      color: AppColors.primary,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                TimeUtils.formatDurationReadable(
                                    widget.durationSeconds),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: AppColors.textSecondaryLight,
                                    ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        Text(
                          widget.isTimedOut
                              ? t.translate('complete.sessionComplete')
                              : t.translate('complete.sessionEnded'),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w300,
                                letterSpacing: 1,
                                color: AppColors.textSecondaryLight,
                              ),
                        ),

                        const SizedBox(height: 24),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withAlpha(20),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.accent.withAlpha(50),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.local_fire_department_rounded,
                                color: AppColors.accent,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                t.translate('complete.daysStreak', args: {
                                  'count': '${sessionProvider.currentStreak}',
                                  'unit': sessionProvider.currentStreak == 1
                                      ? t.translate('stats.day')
                                      : t.translate('stats.days'),
                                }),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: AppColors.accent,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        Row(
                          children: [
                            _buildMiniStat(
                              context,
                              label: t.translate('complete.sessions'),
                              value: '${sessionProvider.totalSessions}',
                              icon: Icons.self_improvement,
                            ),
                            const SizedBox(width: 12),
                            _buildMiniStat(
                              context,
                              label: t.translate('complete.totalTime'),
                              value: TimeUtils.formatDurationReadable(
                                  sessionProvider.totalDurationSeconds),
                              icon: Icons.access_time,
                            ),
                            const SizedBox(width: 12),
                            _buildMiniStat(
                              context,
                              label: t.translate('complete.bestStreak'),
                              value: '${sessionProvider.longestStreak} ${t.translate('stats.days')}',
                              icon: Icons.emoji_events,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniStat(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withAlpha(10)
              : Colors.black.withAlpha(5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: AppColors.primaryLight),
            const SizedBox(height: 6),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 14,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
