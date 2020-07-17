import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ubandbase/constant/constant.dart';
import 'package:ubandbase/utils/utils.dart';

class Base {
  /// appbar 返回键
  static Widget buildLeading(VoidCallback callback, {Widget widget}) {
    if (widget == null) {
      widget = Container(
        height: kToolbarHeight,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(),
        child: Container(
            padding: EdgeInsets.symmetric(
                vertical: Adapt.px(10), horizontal: Adapt.px(15)),
            child: Image.asset(Bilder.courseLeading)),
      );
    }
    return GestureDetector(
      onTap: () => callback(),
      child: widget,
    );
  }

  /// 圆角卡片
  static Widget buildCard({@required Widget child,
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
        Widget positioned,
        VoidCallback callback}) {
    return Stack(
      alignment: alignment ?? AlignmentDirectional.topStart,
      children: <Widget>[
        IconButton(
          onPressed: callback ?? () {},
          icon: ImageIcon(
            AssetImage(action),
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
