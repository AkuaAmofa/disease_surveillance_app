import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';

/// A placeholder widget for chart areas. Renders a gradient background
/// with a simple polyline to simulate a chart.
class ChartPlaceholder extends StatelessWidget {
  final double height;
  final String? label;
  final Color lineColor;

  const ChartPlaceholder({
    super.key,
    this.height = 180,
    this.label,
    this.lineColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primaryXLight, AppColors.surface],
        ),
        borderRadius: AppRadius.borderSm,
      ),
      child: Stack(
        children: [
          if (label != null)
            Positioned(
              top: AppSpacing.s3,
              left: AppSpacing.s3,
              child: Text(
                label!.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.66,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          Positioned.fill(
            child: CustomPaint(painter: _SimpleLinePainter(lineColor)),
          ),
        ],
      ),
    );
  }
}

class _SimpleLinePainter extends CustomPainter {
  final Color color;
  _SimpleLinePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;

    final points = [
      Offset(0, size.height * 0.75),
      Offset(size.width * 0.07, size.height * 0.71),
      Offset(size.width * 0.14, size.height * 0.58),
      Offset(size.width * 0.21, size.height * 0.50),
      Offset(size.width * 0.29, size.height * 0.54),
      Offset(size.width * 0.36, size.height * 0.42),
      Offset(size.width * 0.43, size.height * 0.46),
      Offset(size.width * 0.50, size.height * 0.33),
      Offset(size.width * 0.57, size.height * 0.38),
      Offset(size.width * 0.64, size.height * 0.29),
      Offset(size.width * 0.71, size.height * 0.42),
      Offset(size.width * 0.79, size.height * 0.33),
      Offset(size.width * 0.86, size.height * 0.25),
      Offset(size.width * 0.93, size.height * 0.29),
      Offset(size.width, size.height * 0.21),
    ];

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      linePath.lineTo(p.dx, p.dy);
    }

    final fillPath = Path()..addPath(linePath, Offset.zero);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(linePath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
