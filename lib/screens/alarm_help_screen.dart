import 'package:flutter/material.dart';
import '../services/translation_service.dart';
import '../theme/colors.dart';

class AlarmHelpScreen extends StatelessWidget {
  const AlarmHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = TranslationService.of(context);
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
              t.translate('alarmHelp.intro'),
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 24),
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
