import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../utils/time_utils.dart';
import '../services/translation_service.dart';

class StatsSummary extends StatelessWidget {
  final int todayDurationSeconds;
  final int currentStreak;
  final int totalSessions;
  final int totalDurationSeconds;

  const StatsSummary({
    super.key,
    required this.todayDurationSeconds,
    required this.currentStreak,
    required this.totalSessions,
    required this.totalDurationSeconds,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          _buildStatCard(
            context,
            icon: Icons.today,
            label: TranslationService.of(context).translate('stats.today'),
            value: TimeUtils.formatDurationReadable(todayDurationSeconds),
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),
          _buildStatCard(
            context,
            icon: Icons.local_fire_department,
            label: TranslationService.of(context).translate('common.streak'),
            value: '$currentStreak ${currentStreak == 1 ? 'day' : 'days'}',
            color: AppColors.accent,
          ),
          const SizedBox(width: 8),
          _buildStatCard(
            context,
            icon: Icons.self_improvement,
            label: TranslationService.of(context).translate('complete.sessions'),
            value: '$totalSessions',
            color: AppColors.success,
          ),
          const SizedBox(width: 8),
          _buildStatCard(
            context,
            icon: Icons.access_time,
            label: TranslationService.of(context).translate('common.total'),
            value: TimeUtils.formatDurationReadable(totalDurationSeconds),
            color: AppColors.primaryLight,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withAlpha(15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: theme.colorScheme.onSurface.withAlpha(130),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
