// lib/screens/settings_screen.dart

import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/session_provider.dart';
import '../models/timer_mode.dart';
import '../services/translation_service.dart';
import '../services/csv_data_service.dart';
import '../theme/colors.dart';
import '../theme/app_theme.dart';
import '../widgets/sound_picker.dart';
import '../widgets/vibration_picker.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final t = TranslationService.of(context);

    final isDark =
        settings.themeMode == 'dark' ||
        (settings.themeMode == 'system' &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);
    final theme = isDark ? AppTheme.darkTheme : AppTheme.lightTheme;

    final languages = TranslationService.supportedLanguages;

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(title: Text(t.translate('settings.title'))),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            _buildSectionHeader(context, t.translate('settings.timerSettings')),
            _buildListTile(
              context,
              icon: Icons.timer_outlined,
              title: t.translate('settings.defaultTimerMode'),
              trailing: DropdownButton<TimerMode>(
                value: settings.defaultTimerMode,
                underline: const SizedBox(),
                items: TimerMode.values.map((mode) {
                  return DropdownMenuItem(
                    value: mode,
                    child: Text(_modeLabel(t, mode)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) settings.setTimerMode(value);
                },
              ),
            ),

            const Divider(),

            _buildSectionHeader(
              context,
              t.translate('settings.delayBeforeStart'),
            ),
            _buildListTile(
              context,
              icon: Icons.timer_off_outlined,
              title: t.translate('settings.delaySeconds'),
              subtitle: settings.sessionDelaySeconds > 0
                  ? t.translate(
                      'settings.delayCount',
                      args: {'seconds': '${settings.sessionDelaySeconds}'},
                    )
                  : t.translate('settings.disabled'),
              trailing: SizedBox(
                width: 160,
                child: Slider(
                  value: settings.sessionDelaySeconds.toDouble(),
                  min: 0,
                  max: 60,
                  divisions: 12,
                  label: settings.sessionDelaySeconds > 0
                      ? '${settings.sessionDelaySeconds}s'
                      : 'Off',
                  onChanged: (value) => settings.setSessionDelay(value.round()),
                ),
              ),
            ),

            const Divider(),

            _buildSectionHeader(context, t.translate('settings.soundSettings')),
            _buildListTile(
              context,
              icon: Icons.volume_up_outlined,
              title: t.translate('settings.sessionVolume'),
              trailing: SizedBox(
                width: 120,
                child: Slider(
                  value: settings.soundConfig.volume.toDouble(),
                  min: 0,
                  max: 100,
                  divisions: 10,
                  label: '${settings.soundConfig.volume}%',
                  onChanged: (value) => settings.setVolume(value.round()),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SoundPicker(
                label: t.translate('settings.startSound'),
                currentSound: settings.soundConfig.startSound,
                onChanged: (sound) => settings.setStartSound(sound),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SoundPicker(
                label: t.translate('settings.endSound'),
                currentSound: settings.soundConfig.endSound,
                onChanged: (sound) => settings.setEndSound(sound),
              ),
            ),

            const Divider(),

            _buildSectionHeader(context, t.translate('settings.intervalBell')),
            _buildIntervalTile(
              context,
              icon: Icons.repeat_one_outlined,
              title: t.translate('settings.intervalSound'),
              subtitle: settings.soundConfig.intervalMinutes > 0
                  ? t.translate(
                      'settings.everyMin',
                      args: {
                        'minutes': '${settings.soundConfig.intervalMinutes}',
                      },
                    )
                  : t.translate('settings.disabled'),
              value: settings.soundConfig.intervalMinutes,
              maxValue: 60,
              soundValue: settings.soundConfig.intervalSound,
              onMinutesChanged: (m) => settings.setIntervalMinutes(m),
              onSoundChanged: (s) => settings.setIntervalSound(s),
            ),
            _buildIntervalTile(
              context,
              icon: Icons.notifications_outlined,
              title: t.translate('settings.mindfulnessBell'),
              subtitle: settings.soundConfig.bellIntervalMinutes > 0
                  ? t.translate(
                      'settings.everyMin',
                      args: {
                        'minutes':
                            '${settings.soundConfig.bellIntervalMinutes}',
                      },
                    )
                  : t.translate('settings.disabled'),
              value: settings.soundConfig.bellIntervalMinutes,
              maxValue: 60,
              soundValue: settings.soundConfig.bellSound,
              onMinutesChanged: (m) => settings.setBellIntervalMinutes(m),
              onSoundChanged: (s) => settings.setBellSound(s),
            ),

            const Divider(),

            _buildSectionHeader(
              context,
              t.translate('settings.vibrationSettings'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: VibrationPicker(
                label: t.translate('settings.startVibration'),
                currentVibration: settings.vibrationConfig.startVibration,
                onChanged: (vib) => settings.setStartVibration(vib),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: VibrationPicker(
                label: t.translate('settings.endVibration'),
                currentVibration: settings.vibrationConfig.endVibration,
                onChanged: (vib) => settings.setEndVibration(vib),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: VibrationPicker(
                label: t.translate('settings.intervalVibration'),
                currentVibration: settings.vibrationConfig.intervalVibration,
                onChanged: (vib) => settings.setIntervalVibration(vib),
              ),
            ),

            const Divider(),

            _buildSectionHeader(context, t.translate('settings.display')),
            _buildListTile(
              context,
              icon: Icons.language,
              title: t.translate('settings.language'),
              trailing: DropdownButton<String>(
                value: settings.locale,
                underline: const SizedBox(),
                items: languages.keys.map((code) {
                  return DropdownMenuItem(
                    value: code,
                    child: Text(languages[code] ?? code),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) settings.setLocale(value);
                },
              ),
            ),
            _buildListTile(
              context,
              icon: Icons.phone_android_outlined,
              title: t.translate('settings.screenDuring'),
              subtitle:
                  AppConstants.screenControlLabels[settings.screenControl] ??
                  t.translate('settings.dim'),
              trailing: DropdownButton<String>(
                value: settings.screenControl,
                underline: const SizedBox(),
                items: ['on', 'dim', 'off'].map((control) {
                  return DropdownMenuItem(
                    value: control,
                    child: Text(
                      AppConstants.screenControlLabels[control] ?? control,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) settings.setScreenControl(value);
                },
              ),
            ),
            _buildListTile(
              context,
              icon: Icons.dark_mode_outlined,
              title: t.translate('settings.theme'),
              subtitle:
                  AppConstants.themeModeLabels[settings.themeMode] ??
                  t.translate('settings.system'),
              trailing: DropdownButton<String>(
                value: settings.themeMode,
                underline: const SizedBox(),
                items: ['system', 'light', 'dark'].map((mode) {
                  return DropdownMenuItem(
                    value: mode,
                    child: Text(AppConstants.themeModeLabels[mode] ?? mode),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) settings.setThemeMode(value);
                },
              ),
            ),
            // Transparent Widget toggle – Android only
            if (!Platform.isIOS)
              SwitchListTile(
                secondary: const Icon(Icons.widgets_outlined),
                title: Text(t.translate('settings.transparentWidget')),
                // subtitle: Text(
                //   t.translate('settings.transparentWidgetDesc'),
                //   style: const TextStyle(fontSize: 13),
                // ),
                value: settings.transparentWidget,
                onChanged: (value) => settings.setTransparentWidget(value),
              ),

            const Divider(),

            _buildSectionHeader(context, t.translate('settings.dailyReminder')),
            SwitchListTile(
              secondary: const Icon(Icons.notifications_active_outlined),
              title: Text(t.translate('settings.dailyReminder')),
              subtitle: Text(t.translate('settings.reminderDesc')),
              value: settings.reminderEnabled,
              onChanged: (value) => settings.setReminderEnabled(value),
            ),
            if (settings.reminderEnabled)
              _buildListTile(
                context,
                icon: Icons.access_time,
                title: t.translate('settings.reminderTime'),
                subtitle:
                    '${settings.reminderHour.toString().padLeft(2, '0')}:${settings.reminderMinute.toString().padLeft(2, '0')}',
                onTap: () => _pickReminderTime(context, settings),
              ),

            const Divider(),

            _buildSectionHeader(
              context,
              t.translate('settings.dataManagement'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: isDark
                        ? Colors.white.withAlpha(25)
                        : Colors.black.withAlpha(12),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildDataButton(
                          context,
                          icon: Icons.file_download_outlined,
                          label: t.translate('settings.importCSV'),
                          onTap: () => _importCsv(context),
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDataButton(
                          context,
                          icon: Icons.file_upload_outlined,
                          label: t.translate('settings.exportCSV'),
                          onTap: () => _exportCsv(context),
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Divider(),

            _buildSectionHeader(context, t.translate('settings.about')),
            _buildListTile(
              context,
              icon: Icons.info_outline,
              title: AppConstants.appName,
              subtitle: 'Version ${AppConstants.appVersion}',
            ),
            _buildListTile(
              context,
              icon: Icons.gavel_outlined,
              title: t.translate('settings.licenseAttribution'),
              onTap: () => _showLicenseAttributionDialog(context),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  String _modeLabel(TranslationService t, TimerMode mode) {
    switch (mode) {
      case TimerMode.timed:
        return t.translate('home.mode.timed');
      case TimerMode.endAt:
        return t.translate('home.mode.endAt');
      case TimerMode.unlimited:
        return t.translate('home.mode.unlimited');
    }
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null
          ? Text(subtitle, style: const TextStyle(fontSize: 13))
          : null,
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildIntervalTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required int value,
    required int maxValue,
    required String soundValue,
    required ValueChanged<int> onMinutesChanged,
    required ValueChanged<String> onSoundChanged,
  }) {
    final controller = TextEditingController(text: value > 0 ? '$value' : '');
    return ExpansionTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 13)),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            children: [
              const Text('Every'),
              const SizedBox(width: 8),
              SizedBox(
                width: 64,
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'Off',
                    hintStyle: const TextStyle(fontSize: 14),
                  ),
                  style: const TextStyle(fontSize: 14),
                  onSubmitted: (text) {
                    final parsed = int.tryParse(text);
                    if (parsed != null && parsed > 0) {
                      onMinutesChanged(parsed.clamp(1, maxValue));
                    } else {
                      onMinutesChanged(0);
                    }
                  },
                ),
              ),
              const SizedBox(width: 4),
              const Text('min'),
              const Spacer(),
              TextButton(
                onPressed: () => onMinutesChanged(0),
                child: const Text('Off'),
              ),
            ],
          ),
        ),
        if (value > 0)
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
            child: SoundPicker(
              label: 'Sound',
              currentSound: soundValue,
              onChanged: onSoundChanged,
            ),
          ),
      ],
    );
  }

  Widget _buildDataButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    final primaryColor = isDark ? AppColors.primaryLight : AppColors.primary;
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: isDark
            ? Colors.white.withAlpha(12)
            : AppColors.primary.withAlpha(15),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: primaryColor, size: 24),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _exportCsv(BuildContext context) async {
    final scaffold = ScaffoldMessenger.of(context);

    try {
      await CsvDataService.exportToCsv();
      if (context.mounted) {
        scaffold.showSnackBar(
          SnackBar(
            content: Text('Data exported successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        scaffold.showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _importCsv(BuildContext context) async {
    final scaffold = ScaffoldMessenger.of(context);

    try {
      final sessions = await CsvDataService.pickAndParseCsv();

      if (!context.mounted) return;

      if (sessions == null) {
        // User cancelled file picker
        return;
      }

      if (sessions.isEmpty) {
        scaffold.showSnackBar(
          SnackBar(
            content: const Text('No valid session data found in CSV.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      // Show confirmation dialog
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Import Sessions'),
          content: Text(
            'Found ${sessions.length} session${sessions.length == 1 ? '' : 's'} in the CSV file.\n\n'
            'Import them into ekaTimer?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Import'),
            ),
          ],
        ),
      );

      if (confirm != true || !context.mounted) return;

      final count = await CsvDataService.importSessions(sessions);

      if (!context.mounted) return;

      // Refresh session data so stats update immediately
      if (count > 0) {
        context.read<SessionProvider>().loadSessions();
      }

      scaffold.showSnackBar(
        SnackBar(
          content: Text('$count session${count == 1 ? '' : 's'} imported'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (context.mounted) {
        scaffold.showSnackBar(
          SnackBar(
            content: Text('Import failed: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showLicenseAttributionDialog(BuildContext context) {
    final t = TranslationService.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.translate('settings.licenseAttribution')),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── ekaTimer ─────────────────────────────────────────
              _buildSectionLabel(context, 'ekaTimer'),
              const SizedBox(height: 8),
              _LicenseBox(
                'This program is distributed in the hope that it will be useful, '
                'but WITHOUT ANY WARRANTY; without even the implied warranty of '
                'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.',
              ),
              const SizedBox(height: 12),
              const Text(
                'While ekaTimer is not a fork of Meditation Assistant, many of its '
                'features and behaviours were derived from studying and '
                're-implementing concepts found in that project.',
              ),
              const SizedBox(height: 8),
              const Text(
                'Accordingly, ekaTimer is distributed under the GNU General Public '
                'License v3 (GPLv3), in recognition of the GPLv3 licence applied to '
                'Meditation Assistant by Trevor Slocum.',
              ),
              const SizedBox(height: 8),
              Text(
                'Source code: https://github.com/vpnry/ekatimer',
                style: Theme.of(context).textTheme.bodySmall,
              ),

              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 12),

              // ── Meditation Assistant ──────────────────────────────
              _buildSectionLabel(context, 'Meditation Assistant'),
              const SizedBox(height: 8),
              const Text(
                'ekaTimer is a Dart/Flutter reimplementation inspired by '
                'Meditation Assistant, originally authored by Trevor Slocum.',
              ),
              const SizedBox(height: 8),
              const Text(
                'Author: Trevor Slocum',
                style: TextStyle(fontSize: 13),
              ),
              const Text(
                'Source: https://codeberg.org/tslocum/meditationassistant',
                style: TextStyle(fontSize: 13),
              ),

              const SizedBox(height: 24),

              // ── Audio Attributions ────────────────────────────────
              _buildSectionLabel(context, 'Audio Attributions'),
              const SizedBox(height: 16),
              _buildSectionLabel(context, 'Free Dhamma Distribution'),
              const SizedBox(height: 8),
              const Text(
                'Sadhu.wav',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const Text('Author: Ven. Pa-Auk Tawya Sayadaw'),
              const Text(
                'Adapted from the Pa-Auk Forest Monastery\'s Chanting Audio - Free Distribution.',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 20),
              _buildSectionLabel(context, 'CC0 1.0 Universal (Public Domain)'),
              const SizedBox(height: 8),
              _LicenseBox(
                'bell.wav\n'
                'gardenbird.wav\n'
                'bowl.wav\n'
                'bowlstrong.wav\n'
                'watch.wav',
              ),
              const SizedBox(height: 8),
              const Text(
                'Source: Joseph Sardin (BigSoundBank.com)',
                style: TextStyle(fontSize: 13),
              ),

              const SizedBox(height: 20),

              _buildSectionLabel(context, 'Creative Commons Attribution 4.0'),
              const SizedBox(height: 8),
              const Text(
                'ThreeBowl.wav',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const Text('Author: naturenotesuk'),
              const Text(
                'https://freesound.org/s/667491/',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 10),
              const Text(
                'gong.wav',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const Text('Author: reinsamba'),
              const Text(
                'https://freesound.org/s/46062/',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: Text(t.translate('settings.close')),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Future<void> _pickReminderTime(
    BuildContext context,
    SettingsProvider settings,
  ) async {
    final now = DateTime.now();
    final initial = DateTime(
      now.year,
      now.month,
      now.day,
      settings.reminderHour,
      settings.reminderMinute,
    );

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      settings.setReminderTime(picked.hour, picked.minute);
    }
  }
}

class _LicenseBox extends StatelessWidget {
  final String text;
  const _LicenseBox(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontFamily: 'monospace',
          height: 1.5,
          color: Colors.black,
        ),
      ),
    );
  }
}
