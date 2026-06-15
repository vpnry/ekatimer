import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../services/translation_service.dart';
import '../providers/timer_provider.dart';
import '../providers/settings_provider.dart';
import '../theme/colors.dart';
import '../theme/app_theme.dart';
import '../utils/time_utils.dart';
import '../models/meditation_session.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../widgets/edit_session_dialog.dart';

class CompleteScreen extends StatefulWidget {
  final int durationSeconds;
  final bool isTimedOut;
  final String? sessionId;

  const CompleteScreen({
    super.key,
    required this.durationSeconds,
    this.isTimedOut = true,
    this.sessionId,
  });

  @override
  State<CompleteScreen> createState() => _CompleteScreenState();
}

class _CompleteScreenState extends State<CompleteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  String _motivation = '';

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
        context.read<TimerProvider>().reset(cancelAlarms: false);
        _loadMotivation();
      }
    });
  }

  Future<void> _loadMotivation() async {
    try {
      final locale = TranslationService.of(context).locale;
      final settings = context.read<SettingsProvider>();

      // First, try to load user-imported quotes — these completely replace
      // the built-in quotes when available.
      String? userQuotesJson;
      try {
        userQuotesJson = await settings.getUserQuotes();
      } catch (_) {
        // ignore
      }

      if (userQuotesJson != null) {
        // Use only the user's own quotes
        final allQuotes = <String>[];
        try {
          final userData = json.decode(userQuotesJson);
          if (userData is List) {
            allQuotes.addAll(userData.cast<String>());
          } else if (userData is Map) {
            final localeList = (userData[locale] as List?)?.cast<String>();
            final enList = (userData['en'] as List?)?.cast<String>();
            allQuotes.addAll(localeList ?? enList ?? []);
          }
        } catch (_) {
          // user quotes parse failed, fall through to bundled
        }

        if (allQuotes.isNotEmpty && mounted) {
          setState(() {
            _motivation = allQuotes[Random().nextInt(allQuotes.length)];
          });
          return;
        }
      }

      // Fall back to bundled quotes (only if no user quotes were loaded)
      try {
        final data = await rootBundle.loadString('assets/quotes/quotes.json');
        final bundled = json.decode(data) as Map<String, dynamic>;
        final localeQuotes =
            (bundled[locale] as List?)?.cast<String>() ?? [];
        final quotes = localeQuotes.isNotEmpty
            ? localeQuotes
            : ((bundled['en'] as List?)?.cast<String>() ?? []);

        if (quotes.isNotEmpty && mounted) {
          setState(() {
            _motivation = quotes[Random().nextInt(quotes.length)];
          });
          return;
        }
      } catch (_) {
        // bundled quotes not available
      }

      // Ultimate fallback
      if (mounted) {
        setState(() {
          _motivation = 'TipitakaPali.org';
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _motivation = 'TipitakaPali.org';
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = TranslationService.of(context);
    final settingsProvider = context.watch<SettingsProvider>();

    final isDark =
        settingsProvider.themeMode == 'dark' ||
        (settingsProvider.themeMode == 'deviceTheme' &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);
    final theme = isDark ? AppTheme.darkTheme : AppTheme.lightTheme;

    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(32, 8, 32, 32),
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
                        border: Border.all(color: AppColors.success, width: 3),
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
                              context.read<TimerProvider>().stopSounds();
                              Navigator.of(
                                context,
                              ).popUntil((route) => route.isFirst);
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
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white.withAlpha(15)
                                : Colors.black.withAlpha(8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Text(
                                t.translate('complete.meditationTime'),
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      color: AppColors.textSecondaryLight,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                TimeUtils.formatDuration(
                                  widget.durationSeconds,
                                ),
                                style: Theme.of(context).textTheme.headlineLarge
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
                                  widget.durationSeconds,
                                ),
                                style: Theme.of(context).textTheme.bodyLarge
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
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w300,
                                letterSpacing: 1,
                                color: AppColors.textSecondaryLight,
                              ),
                        ),

                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => _onEditSession(context),
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            label: Text(t.translate('editSession.title')),
                          ),
                        ),

                        const SizedBox(height: 24),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(10),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.primary.withAlpha(30),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Icon(
                                  Icons.format_quote_rounded,
                                  size: 20,
                                  color: AppColors.primary.withAlpha(100),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _motivation,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        height: 1.4,
                                      ),
                                ),
                              ),
                            ],
                          ),
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

  Future<void> _onEditSession(BuildContext context) async {
    final sessionProvider = context.read<SessionProvider>();

    // Find the session to edit — use sessionId if provided, otherwise use the most recent session.
    MeditationSession? session;
    if (widget.sessionId != null) {
      for (final s in sessionProvider.sessions) {
        if (s.id == widget.sessionId) {
          session = s;
          break;
        }
      }
    }
    session ??= sessionProvider.sessions.isNotEmpty
        ? sessionProvider.sessions.first
        : null;

    if (session == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              TranslationService.of(context).translate('editSession.notFound'),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    final updated = await showEditSessionDialog(context, session);
    if (updated != null && context.mounted) {
      await sessionProvider.updateSession(updated);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              TranslationService.of(context).translate('editSession.updated'),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }
}
