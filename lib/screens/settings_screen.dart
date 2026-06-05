import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../models/timer_mode.dart';
import '../services/translation_service.dart';
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
            _buildListTile(
              context,
              icon: Icons.timelapse_outlined,
              title: t.translate('settings.defaultDuration'),
              subtitle: t.translate(
                'settings.defaultDurationSubtitle',
                args: {'minutes': '${settings.defaultDurationMinutes}'},
              ),
              trailing: SizedBox(
                width: 120,
                child: Slider(
                  value: settings.defaultDurationMinutes.toDouble(),
                  min: AppConstants.minTimerDurationMinutes.toDouble(),
                  max: AppConstants.maxTimerDurationMinutes.toDouble(),
                  divisions: 20,
                  label: '${settings.defaultDurationMinutes}',
                  onChanged: (value) =>
                      settings.setTimerDuration(value.round()),
                ),
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
              subtitle: 'GNU GPL v3.0',
              onTap: () => _showLicenseDialog(context),
            ),
            _buildListTile(
              context,
              icon: Icons.music_note_outlined,
              title: t.translate('settings.soundCredits'),
              subtitle: 'CC0 1.0 Universal',
              onTap: () => _showSoundCreditsDialog(context),
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
              Expanded(
                child: Slider(
                  value: value.toDouble(),
                  min: 0,
                  max: maxValue.toDouble(),
                  divisions: maxValue ~/ 5,
                  label: value > 0 ? '$value min' : 'Off',
                  onChanged: (v) => onMinutesChanged(v.round()),
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  value > 0 ? '$value min' : 'Off',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
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

  void _showSoundCreditsDialog(BuildContext context) {
    final t = TranslationService.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.translate('settings.soundCredits')),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Free Sound Library - CC0 1.0 Universal',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'bell.wav, gardenbird.wav, bowl.wav, bowlstrong.wav, gong.wav, watch.wav',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 16),
              const Text('Obtained from Joseph SARDIN - BigSoundBank.com'),
              const SizedBox(height: 8),
              const Text(
                'You are allowed to:\n'
                '• Share, copy, distribute and communicate the material by all means '
                'and in all formats.\n'
                '• Adapt, remix, transform and create from material.\n'
                '• Use, including for commercial purposes.\n'
                '• Without any restrictions.\n'
                '• Without asking permission.',
                style: TextStyle(fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 12),
              const Text(
                'This is:\n'
                'Creative Commons CC0 1.0 Universal\n'
                'Public Domain Dedication.',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              ),
              const SizedBox(height: 16),
              const Text(
                'https://creativecommons.org/publicdomain/zero/1.0/',
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

  void _showLicenseDialog(BuildContext context) {
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
              Text(
                'GNU General Public License v3.0 (GPLv3)',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text('ekaTimer is free software licensed under GPLv3.'),
              const SizedBox(height: 16),
              const Text(
                'Inspired by',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Meditation Assistant\n'
                'Author: Trevor Slocum\n'
                'https://codeberg.org/tslocum/meditationassistant',
              ),
              const SizedBox(height: 16),
              const Text(
                'Source Code',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text('https://github.com/vpnry/ekatimer'),
              const SizedBox(height: 16),
              const Text(
                'This program is distributed in the hope that it will be useful, '
                'but WITHOUT ANY WARRANTY; without even the implied warranty of '
                'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.',
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
