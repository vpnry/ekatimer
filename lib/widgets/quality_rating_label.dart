import 'package:flutter/material.dart';

import '../utils/sitting_quality.dart';

/// Displays a decimal quality score and five fractionally filled stars.
class QualityRatingLabel extends StatelessWidget {
  final double rating;
  final TextStyle? style;
  final double iconSize;
  final Color? iconColor;
  final double gap;
  final double starSpacing;
  final bool compact;
  final String? semanticLabel;

  const QualityRatingLabel({
    super.key,
    required this.rating,
    this.style,
    this.iconSize = 16,
    this.iconColor,
    this.gap = 2,
    this.starSpacing = 1,
    this.compact = false,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = DefaultTextStyle.of(context).style.merge(style);
    final resolvedColor =
        iconColor ??
        effectiveStyle.color ??
        IconTheme.of(context).color ??
        Colors.amber;
    final value = SittingQuality.formatRating(rating);
    final stars = QualityStarRating(
      rating: rating,
      size: iconSize,
      filledColor: resolvedColor,
      emptyColor: resolvedColor.withValues(alpha: 0.32),
      spacing: starSpacing,
    );

    final Widget content;
    if (compact) {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: style),
          SizedBox(height: gap),
          stars,
        ],
      );
    } else {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(value, style: style),
          SizedBox(width: gap),
          stars,
        ],
      );
    }

    return Semantics(
      label: semanticLabel ?? '$value / 5',
      excludeSemantics: true,
      child: content,
    );
  }
}

class QualityStarRating extends StatelessWidget {
  final double rating;
  final double size;
  final Color filledColor;
  final Color emptyColor;
  final double spacing;

  const QualityStarRating({
    super.key,
    required this.rating,
    required this.size,
    required this.filledColor,
    required this.emptyColor,
    this.spacing = 1,
  });

  @override
  Widget build(BuildContext context) {
    final fills = SittingQuality.starFillFractions(rating);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < fills.length; index++) ...[
            if (index > 0) SizedBox(width: spacing),
            FractionalStarIcon(
              key: ValueKey('quality-star-slot-$index'),
              fillFraction: fills[index],
              size: size,
              filledColor: filledColor,
              emptyColor: emptyColor,
            ),
          ],
        ],
      ),
    );
  }
}

class FractionalStarIcon extends StatelessWidget {
  final double fillFraction;
  final double size;
  final Color filledColor;
  final Color emptyColor;

  const FractionalStarIcon({
    super.key,
    required this.fillFraction,
    required this.size,
    required this.filledColor,
    required this.emptyColor,
  });

  @override
  Widget build(BuildContext context) {
    final fraction = fillFraction.clamp(0.0, 1.0).toDouble();
    return SizedBox.square(
      dimension: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Icon(Icons.star_border_rounded, size: size, color: emptyColor),
          if (fraction > 0)
            ClipRect(
              clipper: _FractionalStarClipper(fraction),
              child: Icon(Icons.star_rounded, size: size, color: filledColor),
            ),
        ],
      ),
    );
  }
}

class _FractionalStarClipper extends CustomClipper<Rect> {
  final double fraction;

  const _FractionalStarClipper(this.fraction);

  @override
  Rect getClip(Size size) =>
      Rect.fromLTWH(0, 0, size.width * fraction.clamp(0.0, 1.0), size.height);

  @override
  bool shouldReclip(_FractionalStarClipper oldClipper) =>
      oldClipper.fraction != fraction;
}
