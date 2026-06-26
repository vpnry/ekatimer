import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../services/vibration_service.dart';
import '../services/translation_service.dart';

class VibrationPicker extends StatelessWidget {
  final String currentVibration;
  final String label;
  final ValueChanged<String> onChanged;

  const VibrationPicker({
    super.key,
    required this.currentVibration,
    required this.label,
    required this.onChanged,
  });

  String _vibrationLabel(BuildContext context, String vib) {
    final t = TranslationService.of(context);
    switch (vib) {
      case 'none':
        return t.translate('common.none');
      case 'short':
        return t.translate('common.short');
      case 'medium':
        return t.translate('common.medium');
      case 'long':
        return t.translate('common.long');
      case 'double':
        return t.translate('common.double');
      default:
        return vib;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.onSurface.withAlpha(20),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currentVibration,
              isExpanded: true,
              itemHeight: null,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              items: AppConstants.vibrationOptions.map((vib) {
                return DropdownMenuItem(
                  value: vib,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.vibration,
                          size: 18,
                          color: vib == 'none'
                              ? theme.colorScheme.onSurface.withAlpha(80)
                              : theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _vibrationLabel(context, vib),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  onChanged(value);
                  VibrationService().vibrate(value);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
