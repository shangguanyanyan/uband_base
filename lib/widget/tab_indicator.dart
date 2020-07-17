import 'dart:math';

import 'package:flutter/material.dart';

enum ShapeType { rectangle, oval, curve }

class TabIndicator extends Decoration {
  const TabIndicator(
      {this.borderSide = const BorderSide(width: 2.0, color: Colors.white),
        this.insets = EdgeInsets.zero,
        this.shapeType = ShapeType.rectangle,
        this.radius,
        this.wantWidth = 24})
      : assert(borderSide != null),
        assert(insets != null);

  /// 指示器高度，颜色
  final BorderSide borderSide;

  final EdgeInsetsGeometry insets;

  final ShapeType shapeType;

  /// 圆形指示器的半径
  final double radius;

  /// 指示器的宽度
  final double wantWidth;

  @override
  Decoration lerpFrom(Decoration a, double t) {
    if (a is UnderlineTabIndicator) {
      return UnderlineTabIndicator(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t),
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration lerpTo(Decoration b, double t) {
    if (b is TabIndicator) {
      return TabIndicator(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t),
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  _HomeworkTabPainter createBoxPainter([VoidCallback onChanged]) {
    return _HomeworkTabPainter(this, onChanged);
  }
}

class _HomeworkTabPainter extends BoxPainter {
  _HomeworkTabPainter(this.decoration, VoidCallback onChanged)
      : assert(decoration != null),
        super(onChanged);

  final TabIndicator decoration;

  BorderSide get borderSide => decoration.borderSide;

  EdgeInsetsGeometry get insets => decoration.insets;

  double get wantWidth => decoration.wantWidth;

  double get radius => decoration.radius;

  ShapeType get shapeType => decoration.shapeType;

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    assert(rect != null);
    assert(textDirection != null);
    return insets.resolve(textDirection).deflateRect(rect);
  }

  /// 长条形
  Rect _indicatorRectForRectangle(Rect rect, TextDirection textDirection) {
    Rect indicator = _indicatorRectFor(rect, textDirection);
    //取中间坐标
    double cw = (indicator.left + indicator.right) / 2;
    return Rect.fromLTWH(cw - wantWidth / 2,
        indicator.bottom - borderSide.width, wantWidth, borderSide.width);
  }

  /// 圆形
  Rect _indicatorRectForCircle(Rect rect, TextDirection textDirection) {
    final Rect indicator = _indicatorRectFor(rect, textDirection);
    //取中间坐标
    double cw = (indicator.left + indicator.right) / 2;
    return Rect.fromLTWH(cw - wantWidth / 2,
        indicator.bottom - 2 * radius, wantWidth, 0);
  }

  /// 弧线
  Rect _indicatorRectForCurve(Rect rect,TextDirection textDirection){
    final Rect indicator = _indicatorRectFor(rect, textDirection);
    double cw = (indicator.left + indicator.right) / 2;
    double top = indicator.height / 10;
    double bottom = indicator.height - top;
    return Rect.fromLTWH(cw - wantWidth / 2,
        top, wantWidth, bottom);
  }


  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size;
    final TextDirection textDirection = configuration.textDirection;

    switch (shapeType) {
      case ShapeType.rectangle:
        final Rect indicator =
        _indicatorRectForRectangle(rect, textDirection).deflate(borderSide.width / 2.0);
        paintRectangle(indicator, canvas);
        break;
      case ShapeType.oval:
        final Rect indicator =
        _indicatorRectForCircle(rect, textDirection).deflate(
            borderSide.width / 2.0);
        paintDote(indicator, canvas);
        break;
      case ShapeType.curve:
        final Rect indicator =
        _indicatorRectForCurve(rect, textDirection).deflate(
            borderSide.width / 2.0);
        paintCurve(indicator, canvas, configuration.size);
        break;
    }
  }

  void paintRectangle(Rect indicator, Canvas canvas) {
    final Paint paint = borderSide.toPaint()
      ..strokeCap = StrokeCap.square;
    canvas.drawLine(indicator.bottomLeft, indicator.bottomRight, paint);
  }

  void paintDote(Rect indicator, Canvas canvas) {
    final Paint paint = borderSide.toPaint()
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.fill;
    canvas.drawCircle(indicator.topCenter, decoration.radius, paint);
  }

  void paintCurve(Rect indicator, Canvas canvas, Size size) {
    final Paint paint = borderSide.toPaint()
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawArc(indicator, pi * 0.25, pi*0.5 , false, paint);
  }
}
