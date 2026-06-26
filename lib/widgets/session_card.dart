import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../utils/time_utils.dart';
import '../services/translation_service.dart';

class SessionCard extends StatefulWidget {
  final String id;
  final DateTime startTime;
  final int durationSeconds;
  final bool completed;
  final String? notes;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const SessionCard({
    super.key,
    required this.id,
    required this.startTime,
    required this.durationSeconds,
    this.completed = true,
    this.notes,
    this.onTap,
    this.onDelete,
    this.onEdit,
  });

  @override
  State<SessionCard> createState() => _SessionCardState();
}

class _SessionCardState extends State<SessionCard> {
  bool _notesExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeCategory = TimeUtils.getTimeOfDayCategory(widget.startTime);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: widget.onTap,
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
                      TimeUtils.formatDate(widget.startTime),
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Text(
                          '${TimeUtils.formatTimeOfDay(widget.startTime)} · ${TimeUtils.formatDurationReadable(widget.durationSeconds)}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withAlpha(150),
                          ),
                        ),
                        if (!widget.completed)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withAlpha(30),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              TranslationService.of(context).translate('history.stopped'),
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.warning,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (widget.notes != null && widget.notes!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.notes_rounded,
                            size: 14,
                            color: theme.colorScheme.onSurface.withAlpha(100),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.notes!,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface.withAlpha(180),
                                    fontStyle: FontStyle.italic,
                                  ),
                                  maxLines: _notesExpanded ? null : 2,
                                  overflow: _notesExpanded
                                      ? null
                                      : TextOverflow.ellipsis,
                                ),
                                if (widget.notes!.length > 120 ||
                                    widget.notes!.contains('\n'))
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _notesExpanded = !_notesExpanded;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Text(
                                        _notesExpanded
                                            ? TranslationService.of(context)
                                                .translate('history.showLess')
                                            : TranslationService.of(context)
                                                .translate('history.showMore'),
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 11,
                                            ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.onEdit != null)
                    IconButton(
                      icon: Icon(
                        Icons.edit_outlined,
                        size: 20,
                        color: theme.colorScheme.onSurface.withAlpha(100),
                      ),
                      onPressed: widget.onEdit,
                    ),
                  if (widget.onDelete != null)
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: theme.colorScheme.onSurface.withAlpha(100),
                      ),
                      onPressed: widget.onDelete,
                    ),
                ],
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
