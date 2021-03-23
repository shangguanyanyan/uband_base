import 'package:flutter/material.dart';

class ColorUtil {

  ColorUtil._();

  static RegExp expectPattern = RegExp('#[0-9A-Fa-f]{3,8}\$');

  /// 将 16 进制的颜色值转为 [Color]
  /// 
  /// 支持 `#fff`、`#ffffff`、`#ffffffff` 的格式，以及单独带透明度 [alpha]
  static Color hex(String hex, {double? alpha}) {
    if (!expectPattern.hasMatch(hex)) {
      throw ErrorDescription('color value($hex) must be a valid hex string.');
    }
    if (hex.startsWith('#')) {
      hex = hex.substring(1);
    }
    hex = hex.toUpperCase();
    int lens = hex.length;
    if (lens == 6) {
      if (alpha != null) {
        assert(alpha <= 1 && alpha >= 0);
        return _coverAplhaHexToColor('$hex${(alpha * 0xff).floor().toRadixString(16)}');
      }
      return _covertHexToColor(hex);
    } else if (lens == 3) {
      assert(alpha == null);
      return _covertShorthandHexToColor(hex);
    } else if (lens == 8) {
      assert(alpha == null);
      return _coverAplhaHexToColor(hex);
    }
    throw ErrorDescription('color value($hex) must be a valid hex string.');
  }
}

Color _coverAplhaHexToColor(String hex) {
  String aplha = hex.substring(hex.length - 2);
  hex = hex.substring(0, hex.length - 2);
  return Color(int.parse('$aplha$hex', radix: 16));
}

Color _covertShorthandHexToColor(String hex) {
  hex = hex.split('').map((e) => e * 2).join('');
  return _covertHexToColor(hex);
}

Color _covertHexToColor(String hex) {
  return _coverAplhaHexToColor('${hex}ff');
}