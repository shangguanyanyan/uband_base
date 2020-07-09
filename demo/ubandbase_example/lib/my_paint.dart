import 'dart:math';

import 'package:flutter/material.dart';

class MyPaint extends CustomPainter {
  Paint painter = Paint()
    ..isAntiAlias = true
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2);
    canvas.drawArc(rect, 0, pi * 0.5, false, painter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
