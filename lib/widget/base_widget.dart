import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ubandbase/constant/constant.dart';
import 'package:ubandbase/utils/utils.dart';

class Base{
  /// appbar 返回键
  static Widget buildLeading(VoidCallback callback) {
    return GestureDetector(
      onTap: () => callback(),
      child: Container(
        height: kToolbarHeight,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(),
        child: Container(
            padding: EdgeInsets.symmetric(
                vertical: Adapt.px(10), horizontal: Adapt.px(15)),
            child: Image.asset(Bilder.courseLeading)),
      ),
    );
  }

}