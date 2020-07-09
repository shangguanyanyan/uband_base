import 'dart:ui';

import 'package:flutter/material.dart';

import 'color_util.dart';
import 'adapt_util.dart';

class TextDescriptor {
  String _text;
  TextDescriptor(this._text, {
    double fontSize,
    Color color,
  }) : this._fontSize = fontSize ?? 14,
       this._color = color;

  // TextStyle _style;
  Color _color;
  Color _backgroundColor;
  double _fontSize = 14;
  FontWeight _fontWeight = FontWeight.normal;
  FontStyle _fontStyle = FontStyle.normal;
  double _letterSpacing;
  double _wordSpacing;
  TextBaseline _textBaseline;
  double _height;
  Locale _locale;
  Paint _foreground;
  Paint _background;
  List<Shadow> _shadows;
  List<FontFeature> _fontFeatures;
  TextDecoration _decoration;
  Color _decorationColor;
  TextDecorationStyle _decorationStyle;
  double _decorationThickness;
  String _fontFamily = 'PingFang SC';
  List<String> _fontFamilyFallback = ['sans-serif'];

  TextAlign _textAlign = TextAlign.start;
  TextDirection _textDirection = TextDirection.ltr;
  bool _softWrap;
  TextOverflow _overflow;
  double _textScaleFactor;
  int _maxLines;

  TextDescriptor family([String fontFamily]) {
    _fontFamily = fontFamily;
    return this;
  }

  TextDescriptor bold([FontWeight weight]) {
    assert(weight != FontWeight.normal);
    _fontWeight = weight ?? FontWeight.bold;
    return this;
  }

  TextDescriptor textAlign([TextAlign textAlign]){
    _textAlign = textAlign ?? TextAlign.start;
    return this;
  }

  /// 斜体
  TextDescriptor italic() {
    _fontStyle = FontStyle.italic;
    return this;
  }

  /// 从右到左
  TextDescriptor rtl() {
    _textDirection = TextDirection.rtl;
    return this;
  }

  TextDescriptor del([double width]) {
    _decoration = TextDecoration.lineThrough;
    _decorationThickness = width;
    return this;
  }

  TextDescriptor underline(double width, {
    TextDecorationStyle style = TextDecorationStyle.dashed,
    Color color,
  }) {
    _decoration = TextDecoration.underline;
    _decorationStyle = style;
    _decorationColor = color ?? Colors.black;
    _decorationThickness = width ?? 0.5;
    return this;
  }

  TextDescriptor colorHex(String hex, {double alpha}) {
    _color = ColorUtil.hex(hex, alpha: alpha);
    return this;
  }

  TextDescriptor bg(Paint background) {
    _background = background;
    return this;
  }

  TextDescriptor bgColor(Color backgroundColor) {
    _backgroundColor = backgroundColor;
    return this;
  }

  TextDescriptor bgColorHex(String backgroundColor, {double alpha}) {
    _backgroundColor = ColorUtil.hex(backgroundColor, alpha: alpha);
    return this;
  }

  /// 设置行高（单位：px）
  TextDescriptor lineHeight(double lineHeight) {
    _height = Adapt.px(lineHeight) / _fontSize;
    return this;
  }

  TextDescriptor fg(Paint foreground) {
    _foreground = foreground;
    return this;
  }

  TextDescriptor wrap() {
    _softWrap = true;
    return this;
  }

  TextDescriptor overflow({
    TextOverflow behavior = TextOverflow.ellipsis,
    int maxLines,
  }) {
    _overflow = behavior;
    _maxLines = maxLines;
    return this;
  }

  Text build() {
    return Text(
      _text,
      style: TextStyle(
        inherit: true,
        color: _color,
        backgroundColor: _backgroundColor,
        fontSize: _fontSize,
        fontWeight: _fontWeight,
        fontStyle: _fontStyle,
        letterSpacing: _letterSpacing,
        wordSpacing: _wordSpacing,
        textBaseline: _textBaseline,
        height: _height,
        locale: _locale,
        foreground: _foreground,
        background: _background,
        shadows: _shadows,
        fontFeatures: _fontFeatures,
        decoration: _decoration,
        decorationColor: _decorationColor,
        decorationStyle: _decorationStyle,
        decorationThickness: _decorationThickness,
        debugLabel: null,
        fontFamily: _fontFamily,
        fontFamilyFallback: _fontFamilyFallback,
        package: null,
      ),
      strutStyle: null,
      textAlign: _textAlign,
      textDirection: _textDirection,
      locale: null,
      softWrap: _softWrap,
      overflow: _overflow,
      textScaleFactor: _textScaleFactor,
      maxLines: _maxLines,
      semanticsLabel: null,
      textWidthBasis: null,
    );
  }
}


class Quick {

  Quick._();

  static SizedBox buildGap(double height, {Color color = Colors.transparent}) {
    return SizedBox(
      height: height,
      child: Container(
        color: color,
      ),
    );
  }

  static SizedBox buildGapW(double width, {Color color = Colors.transparent}) {
    return SizedBox(
      width: width,
      child: Container(
        color: color,
      ),
    );
  }

  /// 链式调用生成 [Text]
  /// 
  /// [size] 字体大小， 单位 `px`
  /// 
  /// [color] 字体颜色
  static TextDescriptor buildText(String text, {
    double fontSize,
    Color color,
  }) {
    if (fontSize != null) {
      fontSize = Adapt.fontPx(fontSize);
    }
    return TextDescriptor(text, fontSize: fontSize, color: color);
  }

  static Padding padding(Widget widget, {
    double all,
    double top,
    double right,
    double bottom,
    double left,
    double horizontal,
    double vertical,
  }) {
    EdgeInsets padding = EdgeInsets.zero;
    if (all != null) {
      assert(
        top == null && right == null && bottom == null && left == null && horizontal == null && vertical == null,
        'Single value padding shouldn\'t have either top、right、bottom、left、horizontal or vertical',
      );
      padding = EdgeInsets.all(Adapt.px(all));
    }
    if (top != null || right != null || bottom != null || left != null) {
      assert(
        all == null && horizontal == null && vertical == null,
        'Not a single value padding shouldn\'t have all、horizontal or vertical',
      );
      left = left != null ? Adapt.px(left) : 0.0;
      top = top != null ? Adapt.px(top) : 0.0;
      right = right != null ? Adapt.px(right) : 0.0;
      bottom = bottom != null ? Adapt.px(bottom) : 0.0;
      padding = EdgeInsets.fromLTRB(left, top, right, bottom);
    }
    if (horizontal != null || vertical != null) {
      assert(
        all == null && top == null && right == null && bottom == null && left == null,
        'Horizontal or vertical padding shouldn\'t have either top、right、bottom、left or all',
      );
      vertical = vertical != null ? Adapt.px(vertical) : 0.0;
      horizontal = horizontal != null ? Adapt.px(horizontal) : 0.0;
      padding = EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal);
    }
    return Padding(
      padding: padding,
      child: widget,
    );
  }
}