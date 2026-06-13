import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import '../services/background_settings_service.dart';
import '../services/translation_service.dart';
import '../theme/colors.dart';

class AlarmHelpScreen extends StatefulWidget {
  const AlarmHelpScreen({super.key});

  @override
  State<AlarmHelpScreen> createState() => _AlarmHelpScreenState();
}

class _AlarmHelpScreenState extends State<AlarmHelpScreen>
    with WidgetsBindingObserver {
  bool _batteryIgnored = true;
  bool _batteryChecked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkBatteryStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _batteryChecked) {
      _checkBatteryStatus();
    }
  }

  Future<void> _checkBatteryStatus() async {
    if (!mounted) return;
    try {
      final ignored = await BackgroundSettingsService
          .isBatteryOptimizationIgnored();
      if (mounted) {
        setState(() {
          _batteryIgnored = ignored;
          _batteryChecked = true;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _batteryChecked = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = TranslationService.of(context);
    final isIos = Platform.isIOS;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.translate('alarmHelp.title')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isIos
                  ? t.translate('alarmHelp.intro.ios')
                  : t.translate('alarmHelp.intro'),
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 24),
            if (Platform.isAndroid) _buildBatteryCard(t),
            if (Platform.isAndroid) const SizedBox(height: 24),

            if (isIos) ...[
              _InfoPoint(
                number: '1',
                title: t.translate('alarmHelp.focus'),
                description: t.translate('alarmHelp.focus.desc'),
              ),
              const SizedBox(height: 20),
              _InfoPoint(
                number: '2',
                title: t.translate('alarmHelp.notifications'),
                description: t.translate('alarmHelp.notifications.ios.desc'),
              ),
              const SizedBox(height: 20),
              _InfoPoint(
                number: '3',
                title: t.translate('alarmHelp.backgroundRefresh'),
                description: t.translate('alarmHelp.backgroundRefresh.desc'),
              ),
              const SizedBox(height: 20),
              _InfoPoint(
                number: '4',
                title: t.translate('alarmHelp.volume'),
                description: t.translate('alarmHelp.volume.ios.desc'),
              ),
            ] else ...[
              _InfoPoint(
                number: '1',
                title: t.translate('alarmHelp.notifications'),
                description: t.translate('alarmHelp.notifications.desc'),
              ),
              const SizedBox(height: 20),
              _InfoPoint(
                number: '2',
                title: t.translate('alarmHelp.battery'),
                description: t.translate('alarmHelp.battery.desc'),
              ),
              const SizedBox(height: 20),
              _InfoPoint(
                number: '3',
                title: t.translate('alarmHelp.background'),
                description: t.translate('alarmHelp.background.desc'),
              ),
              const SizedBox(height: 20),
              _InfoPoint(
                number: '4',
                title: t.translate('alarmHelp.volume'),
                description: t.translate('alarmHelp.volume.desc'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBatteryCard(TranslationService t) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String statusLabel;
    String statusDesc;
    Color statusColor;
    IconData statusIcon;

    if (!_batteryChecked) {
      statusLabel = t.translate('alarmHelp.battery.checking');
      statusDesc = '';
      statusColor = AppColors.textSecondaryLight;
      statusIcon = Icons.hourglass_empty_rounded;
    } else if (_batteryIgnored) {
      statusLabel = t.translate('alarmHelp.battery.unrestricted');
      statusDesc = t.translate('alarmHelp.battery.unrestricted.desc');
      statusColor = AppColors.success;
      statusIcon = Icons.check_circle_rounded;
    } else {
      statusLabel = t.translate('alarmHelp.battery.optimized');
      statusDesc = t.translate('alarmHelp.battery.optimized.desc');
      statusColor = AppColors.warning;
      statusIcon = Icons.warning_amber_rounded;
    }

    return Card(
      elevation: 0,
      color: isDark ? AppColors.surfaceContainerHighDark : AppColors.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            if (statusDesc.isNotEmpty) ...[
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Text(
                  statusDesc,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: isDark
                        ? AppColors.onSurfaceVariantDark
                        : AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
            if (Platform.isAndroid && _batteryChecked && !_batteryIgnored) ...[
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ActionChip(
                      avatar: Icon(Icons.battery_charging_full, size: 18),
                      label: Text(t.translate('alarmHelp.battery.openSettings')),
                      onPressed: () =>
                          BackgroundSettingsService
                              .requestIgnoreBatteryOptimization(),
                    ),
                    ActionChip(
                      avatar: Icon(Icons.settings_backup_restore, size: 18),
                      label: Text(t.translate('alarmHelp.battery.openOem')),
                      onPressed: () =>
                          BackgroundSettingsService
                              .openOemBackgroundSettings(),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoPoint extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const _InfoPoint({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withAlpha(170),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
