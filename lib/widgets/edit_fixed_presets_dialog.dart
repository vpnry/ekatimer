import 'package:flutter/material.dart';
import '../services/translation_service.dart';

class EditFixedPresetsDialog extends StatefulWidget {
  final List<int> currentOptions;

  const EditFixedPresetsDialog({super.key, required this.currentOptions});

  @override
  State<EditFixedPresetsDialog> createState() => _EditFixedPresetsDialogState();
}

class _EditFixedPresetsDialogState extends State<EditFixedPresetsDialog> {
  late List<TextEditingController> _controllers;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controllers = widget.currentOptions
        .map((v) => TextEditingController(text: v.toString()))
        .toList();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onSave() {
    final newValues = <int>[];
    for (final c in _controllers) {
      final text = c.text.trim();
      if (text.isEmpty) {
        setState(() {
          _errorMessage = 'editPresets.fillAll';
        });
        return;
      }
      final parsed = int.tryParse(text);
      if (parsed == null || parsed < 1 || parsed > 100800) {
        setState(() {
          _errorMessage = 'editPresets.invalidRange';
        });
        return;
      }
      newValues.add(parsed);
    }

    Navigator.of(context).pop(newValues);
  }

  @override
  Widget build(BuildContext context) {
    final t = TranslationService.of(context);
    return AlertDialog(
      title: Text(t.translate('editPresets.title')),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(t.translate('editPresets.desc')),
            const SizedBox(height: 16),
            for (int i = 0; i < 4; i++) ...[
              Row(
                children: [
                  SizedBox(
                    width: 30,
                    child: Text(
                      String.fromCharCode(65 + i),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _controllers[i],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: t.translate('editPresets.minutesFor',
                            args: {'hour': String.fromCharCode(65 + i)}),
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
              if (i < 3) const SizedBox(height: 12),
            ],
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                TranslationService.of(context).translate(_errorMessage!),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(t.translate('common.cancel')),
        ),
        ElevatedButton(onPressed: _onSave, child: Text(t.translate('common.save'))),
      ],
    );
  }
}
