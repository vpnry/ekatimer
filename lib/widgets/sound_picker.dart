import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../utils/constants.dart';
import '../services/audio_service.dart';
import '../services/translation_service.dart';

class SoundPicker extends StatefulWidget {
  final String currentSound;
  final String label;
  final ValueChanged<String> onChanged;

  const SoundPicker({
    super.key,
    required this.currentSound,
    required this.label,
    required this.onChanged,
  });

  @override
  State<SoundPicker> createState() => _SoundPickerState();
}

  String _soundLabel(BuildContext context, String sound) {
    final t = TranslationService.of(context);
    switch (sound) {
      case 'Bell':
        return t.translate('sound.bell');
      case 'Bowl':
        return t.translate('sound.bowl');
      case 'BowlStrong':
        return t.translate('sound.bowlStrong');
      case 'GardenBird':
        return t.translate('sound.gardenBird');
      case 'Gong':
        return t.translate('sound.gong');
      case 'Watch':
        return t.translate('sound.watch');
      default:
        return sound;
    }
  }

class _SoundPickerState extends State<SoundPicker>
    with SingleTickerProviderStateMixin {
  bool _isPreviewing = false;
  String? _lastPreviewedSound;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    final audioService = AudioService();
    audioService.init().then((_) {
      if (!mounted) return;
      if (audioService.isPlaying && audioService.currentSound == widget.currentSound) {
        setState(() => _isPreviewing = true);
        _pulseController.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onSoundChanged(String? value) {
    if (value == null) return;
    _lastPreviewedSound = value;
    final audioService = AudioService();
    widget.onChanged(value);

    if (value != 'none') {
      _pulseController.stop();
      setState(() => _isPreviewing = true);
      _pulseController.repeat(reverse: true);

      audioService.playSound(value);

      Future.delayed(const Duration(seconds: 3), () {
        if (!mounted || _lastPreviewedSound != value) return;
        setState(() => _isPreviewing = false);
        _pulseController.stop();
        _pulseController.reset();
      });
    } else {
      _lastPreviewedSound = null;
      audioService.stop();
      setState(() => _isPreviewing = false);
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isPreviewing
                      ? AppColors.primary
                      : theme.colorScheme.onSurface.withAlpha(20),
                  width: _isPreviewing ? 2 : 1,
                ),
                boxShadow: _isPreviewing
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(60),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              child: child,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: _isPreviewing
                  ? AppColors.primary.withAlpha(15)
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: widget.currentSound,
                isExpanded: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                items: [
                  DropdownMenuItem(
                    value: 'none',
                    child: Text(TranslationService.of(context).translate('common.none')),
                  ),
                  ...AppConstants.builtInSounds.map((sound) {
                    return DropdownMenuItem(
                      value: sound,
                      child: Row(
                        children: [
                          AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, _) {
                              return Transform.scale(
                                scale: (_isPreviewing &&
                                        widget.currentSound == sound)
                                    ? _pulseAnimation.value
                                    : 1.0,
                                child: Icon(
                                  (_isPreviewing &&
                                          widget.currentSound == sound)
                                      ? Icons.volume_up_rounded
                                      : Icons.music_note,
                                  size: 18,
                                  color: (_isPreviewing &&
                                          widget.currentSound == sound)
                                      ? AppColors.primary
                                      : theme.colorScheme.primary,
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _soundLabel(context, sound),
                          ),
                          const Spacer(),
                          if (_isPreviewing &&
                              widget.currentSound == sound)
                            Text(
                              TranslationService.of(context).translate('common.playing'),
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                ],
                onChanged: _onSoundChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
