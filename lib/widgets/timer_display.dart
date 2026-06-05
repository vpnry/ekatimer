import 'dart:math';
import 'package:flutter/material.dart';
import '../services/translation_service.dart';

class TimerDisplay extends StatelessWidget {
  final String timeText;
  final String? subtitleLabel;
  final String? subtitleValue;
  final bool isPaused;
  final double progress;

  const TimerDisplay({
    super.key,
    required this.timeText,
    this.subtitleLabel,
    this.subtitleValue,
    this.isPaused = false,
    this.progress = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 280,
          height: 280,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withAlpha(15)
                      : Colors.black.withAlpha(10),
                ),
              ),
              if (progress < 1.0)
                SizedBox(
                  width: 280,
                  height: 280,
                  child: CustomPaint(
                    painter: _ArcPainter(
                      progress: progress,
                      color: Theme.of(context).colorScheme.primary,
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withAlpha(20)
                          : Colors.black.withAlpha(15),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedOpacity(
                      opacity: isPaused ? 0.4 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          timeText,
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.w200,
                            color: Theme.of(context).colorScheme.onSurface,
                            letterSpacing: 4,
                          ),
                        ),
                      ),
                    ),
                    if (subtitleLabel != null &&
                        subtitleValue != null &&
                        subtitleValue!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        '$subtitleLabel: $subtitleValue',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(150),
                        ),
                      ),
                    ],
                    if (isPaused) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withAlpha(30),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          TranslationService.of(
                            context,
                          ).translate('meditation.paused'),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  _ArcPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const startAngle = -pi / 2;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    // change sweep angle to negative to make it go clockwise, possitive angle goes counter-clockwise by default in Flutter

    final sweepAngle = -2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ArcPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
