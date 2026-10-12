import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class PriceTrendChartPainter extends CustomPainter {
  final List<double> dataPoints;
  final double fairPrice;
  final bool isDark;

  PriceTrendChartPainter({
    required this.dataPoints,
    required this.fairPrice,
    this.isDark = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.isEmpty) return;

    final minVal = (dataPoints.reduce((a, b) => a < b ? a : b) < fairPrice
            ? dataPoints.reduce((a, b) => a < b ? a : b)
            : fairPrice) -
        5.0;
    final maxVal = (dataPoints.reduce((a, b) => a > b ? a : b) > fairPrice
            ? dataPoints.reduce((a, b) => a > b ? a : b)
            : fairPrice) +
        8.0;
    final range = maxVal - minVal;

    final double width = size.width;
    final double height = size.height;

    // Draw Fair Price Dashed Reference Line
    final fairY = height - 20 - ((fairPrice - minVal) / range) * (height - 40);
    final dashPaint = Paint()
      ..color = AppColors.fairGreen
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    double startX = 10;
    while (startX < width - 10) {
      canvas.drawLine(
        Offset(startX, fairY),
        Offset(startX + 4, fairY),
        dashPaint,
      );
      startX += 8;
    }

    // Points calculation
    final points = <Offset>[];
    for (int i = 0; i < dataPoints.length; i++) {
      final x = (i / (dataPoints.length - 1)) * (width - 30) + 15;
      final y = height - 20 - ((dataPoints[i] - minVal) / range) * (height - 40);
      points.add(Offset(x, y));
    }

    // Gradient fill path
    final fillPath = Path()
      ..moveTo(15, height - 15);
    for (final pt in points) {
      fillPath.lineTo(pt.dx, pt.dy);
    }
    fillPath.lineTo(width - 15, height - 15);
    fillPath.close();

    final gradPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          (isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen).withValues(alpha: 0.35),
          (isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, width, height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, gradPaint);

    // Trend line path
    final linePaint = Paint()
      ..color = isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(linePath, linePaint);

    // Dots & Spike Highlight
    final maxDataVal = dataPoints.reduce((a, b) => a > b ? a : b);
    for (int i = 0; i < points.length; i++) {
      final isSpike = dataPoints[i] == maxDataVal;
      final dotPaint = Paint()
        ..color = isSpike
            ? AppColors.overpricedRed
            : (isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(points[i], isSpike ? 5.5 : 3.5, dotPaint);

      final ringPaint = Paint()
        ..color = Colors.white
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(points[i], isSpike ? 5.5 : 3.5, ringPaint);
    }
  }

  @override
  bool shouldRepaint(covariant PriceTrendChartPainter oldDelegate) {
    return oldDelegate.dataPoints != dataPoints ||
        oldDelegate.fairPrice != fairPrice ||
        oldDelegate.isDark != isDark;
  }
}
