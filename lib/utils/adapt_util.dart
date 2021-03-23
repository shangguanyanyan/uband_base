import 'dart:ui';

import 'package:flutter/material.dart';


/// 屏幕适配方案
class Adapt {
  
  Adapt._();

  /// 设计稿宽度
  static int _designWidth = 750;

  static int _designHeight = 1334;

  static bool _ignoreTextScale = true;

  static MediaQueryData _mediaQueryData = MediaQueryData.fromWindow(window);
  static double? _ratio;

  static double? _ratioHeight;

  /// 初始化方法
  /// 
  /// [designWidth] 设计稿宽度
  static init({int? designWidth,int? designHeight,bool? ignoreTextScale}){
    designWidth ??= _designWidth;
    designHeight ??= _designHeight;
    _ratio = _mediaQueryData.size.width / designWidth;
    _ratioHeight = _mediaQueryData.size.height / designHeight;
    _ignoreTextScale ??= ignoreTextScale!;
  }

  static initWithContext(BuildContext context, {int? designWidth,int? designHeight, bool? ignoreTextScale}) {
    designWidth ??= _designWidth;
    designHeight ??= _designHeight;
    _mediaQueryData = MediaQuery.of(context);
    _ratio = _mediaQueryData.size.width / designWidth;
    _ratioHeight = _mediaQueryData.size.height / designHeight;
    _ignoreTextScale ??= ignoreTextScale!;
  }

  static bool get _hasInit => _ratio != null && _ratioHeight != null;

  /// 1 `px` 转逻辑像素 `pt` 的值
  static double get onePx => 1 / _mediaQueryData.devicePixelRatio;

  /// 屏幕宽度
  static double get screenW => _mediaQueryData.size.width;

  /// 屏幕高度
  static double get screenH => _mediaQueryData.size.height;

  /// 顶部状态栏高度
  static double get padTopH => _mediaQueryData.padding.top;

  /// 底部区域高度
  static double get padBotH =>  _mediaQueryData.padding.bottom;

  /// `px` 转逻辑 `pt`
  /// 
  /// [value] 设计稿 `px` 值
  static double px(double value){
    if (!_hasInit) {
      init();
    }
    return value * _ratio!;
  }

  static double pxHeight(double value){
    if (!_hasInit) {
      init();
    }
    return value * _ratioHeight!;
  }

  /// 字体 `px` 转逻辑 `pt`
  /// 
  /// [value] 设计稿 `px` 值
  static double fontPx(double value) {
    if (!_hasInit) {
      init();
    }
    var scale = _ignoreTextScale ? 1 : _mediaQueryData.textScaleFactor;
    return value * _ratio! * scale;
  }

  /// 计算给定宽度占屏幕的比例
  /// 
  /// [value] 给定宽度
  static double px2RatioW(double value) {
    return px(value) / screenW;
  }

  /// 计算给定高度占屏幕高度的比例
  /// 
  /// [value] 给定高度
  static double px2RatioH(double value) {
    return px(value) / screenH;
  }
} 