import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../utils/time_utils.dart';
import '../services/translation_service.dart';

class SessionCard extends StatelessWidget {
  final String id;
  final DateTime startTime;
  final int durationSeconds;
  final bool completed;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const SessionCard({
    super.key,
    required this.id,
    required this.startTime,
    required this.durationSeconds,
    this.completed = true,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeCategory = TimeUtils.getTimeOfDayCategory(startTime);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getTimeColor(timeCategory).withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getTimeIcon(timeCategory),
                  color: _getTimeColor(timeCategory),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      TimeUtils.formatDate(startTime),
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${TimeUtils.formatTimeOfDay(startTime)} · ${TimeUtils.formatDurationReadable(durationSeconds)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(150),
                      ),
                    ),
                  ],
                ),
              ),
              if (!completed)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    TranslationService.of(context).translate('history.stopped'),
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              if (onDelete != null)
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: theme.colorScheme.onSurface.withAlpha(100),
                  ),
                  onPressed: onDelete,
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTimeIcon(String category) {
    switch (category) {
      case 'Morning':
        return Icons.wb_sunny;
      case 'Afternoon':
        return Icons.wb_cloudy;
      case 'Evening':
        return Icons.nights_stay;
      case 'Night':
        return Icons.bedtime;
      default:
        return Icons.schedule;
    }
  }

  Color _getTimeColor(String category) {
    switch (category) {
      case 'Morning':
        return const Color(0xFFFFB347);
      case 'Afternoon':
        return const Color(0xFF5B8DEF);
      case 'Evening':
        return const Color(0xFF9B59B6);
      case 'Night':
        return const Color(0xFF2C3E50);
      default:
        return AppColors.primary;
    }
  }
}
