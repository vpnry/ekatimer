import 'dart:math' as math;

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

  /// Where to cut the star so that [fraction] of its *ink* is colored.
  ///
  /// Filling by box width is what the eye actually gets wrong: a star tapers
  /// to thin points, so its left tenth of width holds far less than a tenth
  /// of its area. Cutting at 0.1 showed a sliver that read as empty, and
  /// cutting at 0.9 left only the right point bare so it read as full.
  /// Measuring the star's real area instead pushes both cuts well inside the
  /// body, where a tenth is visible, and — because a star is symmetric about
  /// its vertical axis — still puts 0.5 exactly on the center line.
  static double inkCutoff(double fraction) {
    final value = fraction.clamp(0.0, 1.0).toDouble();
    if (value <= 0) return 0;
    if (value >= 1) return 1;

    final cdf = _StarGeometry.inkByColumn;
    for (var column = 1; column < cdf.length; column++) {
      if (cdf[column] < value) continue;
      final previous = cdf[column - 1];
      final span = cdf[column] - previous;
      final within = span <= 0 ? 0.0 : (value - previous) / span;
      return (column - 1 + within) / (cdf.length - 1);
    }
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _StarPainter(
          fillFraction: fillFraction.clamp(0.0, 1.0).toDouble(),
          filledColor: filledColor,
          emptyColor: emptyColor,
        ),
      ),
    );
  }
}

/// Paints one star, partially filled from the left.
///
/// Both the filled and the empty parts come from a single [Path], so they
/// line up exactly. The previous version stacked `Icons.star_rounded` over
/// `Icons.star_border_rounded`; those are two separately drawn glyphs whose
/// outlines do not coincide, which left a half-filled star looking like less
/// than half.
class _StarPainter extends CustomPainter {
  final double fillFraction;
  final Color filledColor;
  final Color emptyColor;

  const _StarPainter({
    required this.fillFraction,
    required this.filledColor,
    required this.emptyColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final star = _StarGeometry.pathFor(size);

    canvas.drawPath(star, Paint()..color = emptyColor);

    if (fillFraction <= 0) return;

    final cutoff = FractionalStarIcon.inkCutoff(fillFraction);
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width * cutoff, size.height));
    canvas.drawPath(star, Paint()..color = filledColor);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_StarPainter oldDelegate) =>
      oldDelegate.fillFraction != fillFraction ||
      oldDelegate.filledColor != filledColor ||
      oldDelegate.emptyColor != emptyColor;
}

/// The five-pointed star shape, plus how its area is spread across its width.
class _StarGeometry {
  _StarGeometry._();

  static const int _points = 5;

  /// Ratio of the inner (notch) radius to the outer (tip) radius. This is the
  /// proportion that gives the familiar five-pointed star rather than a
  /// spiky asterisk or a near-pentagon.
  static const double _innerRadiusRatio = 0.382;

  static Path pathFor(Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = math.min(size.width, size.height) / 2;
    final innerRadius = outerRadius * _innerRadiusRatio;
    final path = Path();
    for (var corner = 0; corner < _points * 2; corner++) {
      final radius = corner.isEven ? outerRadius : innerRadius;
      // Start at the top point and walk around; every second corner is a
      // notch, which is what turns the polygon into a star.
      final angle = -math.pi / 2 + corner * math.pi / _points;
      final point = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      corner == 0
          ? path.moveTo(point.dx, point.dy)
          : path.lineTo(point.dx, point.dy);
    }
    return path..close();
  }

  /// Grid the star is sampled on. Fine enough to place a cut within a
  /// percent of the star's width, and small enough that the one-off scan
  /// costs a few milliseconds.
  static const int _sampleColumns = 160;
  static const int _sampleRows = 160;

  static List<double>? _inkByColumn;

  /// Running share of the star's area, from none at index 0 to all of it at
  /// the last index. `inkByColumn[i]` is the share lying left of column `i`,
  /// which sits at `i / (length - 1)` across the star's width — so reading
  /// the list backwards turns a fill fraction into a place to cut.
  ///
  /// Measured by sampling the path rather than derived by formula, so that
  /// reshaping [pathFor] cannot leave the two silently disagreeing. The scan
  /// runs once, on first use, and the result is reused for every star.
  static List<double> get inkByColumn => _inkByColumn ??= _measureInk();

  static List<double> _measureInk() {
    final path = pathFor(
      Size(_sampleColumns.toDouble(), _sampleRows.toDouble()),
    );
    final perColumn = List<double>.filled(_sampleColumns, 0);
    var total = 0.0;
    for (var column = 0; column < _sampleColumns; column++) {
      var covered = 0;
      for (var row = 0; row < _sampleRows; row++) {
        if (path.contains(Offset(column + 0.5, row + 0.5))) covered++;
      }
      perColumn[column] = covered.toDouble();
      total += covered;
    }

    final cumulative = List<double>.filled(_sampleColumns + 1, 0);
    if (total <= 0) return cumulative;
    var running = 0.0;
    for (var column = 0; column < _sampleColumns; column++) {
      running += perColumn[column];
      cumulative[column + 1] = running / total;
    }
    return cumulative;
  }
}
