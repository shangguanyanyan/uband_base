import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ubandbase/constant/constant.dart';
import 'package:ubandbase/utils/utils.dart';

class Base {
  /// appbar 返回键
  static Widget buildLeading(VoidCallback callback,
      {Widget widget, String icon, Color color}) {
    if (widget == null) {
      widget = IconButton(
        onPressed: () => callback?.call(),
        color: color ?? Colors.black,
        icon: ImageIcon(
          AssetImage(
            icon ?? Bilder.courseLeading,
          ),
          size: Adapt.px(20),
        ),
      );
    } else {
      widget = GestureDetector(
        onTap: () => callback(),
        child: widget,
      );
    }
    return widget;
  }

  /// 圆角卡片
  static Widget buildCard(
      {@required Widget child,
      double radius,
      Color color = Colors.white,
      AlignmentGeometry alignment = AlignmentDirectional.center,
      EdgeInsetsGeometry margin = EdgeInsets.zero,
      EdgeInsetsGeometry padding = EdgeInsets.zero}) {
    return Container(
      alignment: alignment,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(radius ?? 0)),
      child: child,
    );
  }

  /// appbar 按钮
  static Widget buildActionButton(String action,
      {AlignmentDirectional alignment,
      String describe,
      double size = 24,
      Widget positioned,
      VoidCallback callback}) {
    return Stack(
      alignment: alignment ?? AlignmentDirectional.topStart,
      children: <Widget>[
        IconButton(
          iconSize: kToolbarHeight,
          onPressed: callback ?? () {},
          icon: ImageIcon(
            AssetImage(action),
            size: size,
            color: ColorUtil.hex(BaseColour.black),
          ),
        ),
        Positioned(
          top: kToolbarHeight / 5,
          right: kToolbarHeight / 5,
          child: positioned ?? SizedBox.shrink(),
        )
      ],
    );
  }
}
