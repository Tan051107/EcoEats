import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';

class TakePictureFrame extends CustomPainter{
    @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = normalGreen
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final double padding = size.shortestSide * 0.05;   // 5% padding
    final double cornerLength = size.shortestSide * 0.1; // 10% of shortest side

    final rect = Rect.fromLTWH(
      padding,
      padding,
      size.width - padding * 2,
      size.height - padding * 2,
    );

    // Draw 4 corners
    // Top-left
    canvas.drawLine(rect.topLeft, rect.topLeft + Offset(cornerLength, 0), paint);
    canvas.drawLine(rect.topLeft, rect.topLeft + Offset(0, cornerLength), paint);

    // Top-right
    canvas.drawLine(rect.topRight, rect.topRight - Offset(cornerLength, 0), paint);
    canvas.drawLine(rect.topRight, rect.topRight + Offset(0, cornerLength), paint);

    // Bottom-left
    canvas.drawLine(rect.bottomLeft, rect.bottomLeft + Offset(cornerLength, 0), paint);
    canvas.drawLine(rect.bottomLeft, rect.bottomLeft - Offset(0, cornerLength), paint);

    // Bottom-right
    canvas.drawLine(rect.bottomRight, rect.bottomRight - Offset(cornerLength, 0), paint);
    canvas.drawLine(rect.bottomRight, rect.bottomRight - Offset(0, cornerLength), paint);
  }
  

  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}