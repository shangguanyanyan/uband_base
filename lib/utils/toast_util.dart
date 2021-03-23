import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ubandbase/constant/base_colour.dart';
import 'package:ubandbase/utils/adapt_util.dart';
import 'package:ubandbase/utils/quick_util.dart';

class ToastUtil {
  static FToast? _fToast;

  static init(BuildContext context) {
    if (_fToast == null) _fToast = FToast();
    _fToast!.init(context);
  }

  static Widget _imgLeadToast(Widget leading, String message) {
    return Container(
      height: Adapt.px(50),
      padding:
          EdgeInsets.symmetric(vertical: Adapt.px(5), horizontal: Adapt.px(30)),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Adapt.px(8))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          leading,
          SizedBox(width: Adapt.px(20)),
          Quick.buildText("$message", fontSize: 22)
              .colorHex(BaseColour.black)
              .build()
        ],
      ),
    );
  }

  static promptWarning(String message) {
    Widget img = Icon(
      Icons.error_outline,
      size: Adapt.px(30),
      color: Colors.lightBlueAccent,
    );
    var _screenSize = window.physicalSize / window.devicePixelRatio;
    showToast(
        Container(
            height: Adapt.px(100),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
            ),
            child: _imgLeadToast(img, "$message")),
        left: _screenSize.width / 2 - Adapt.px(200),duration: 1);
  }

  static Widget _savingToast() {
    return _imgLeadToast(
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.lightBlueAccent),
        ),
        "保存中...");
  }

  static Widget _loadingToast() {
    return _imgLeadToast(
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.lightBlueAccent),
        ),
        "加载中...");
  }


  static showGeneralToast(String message) {
    Fluttertoast.showToast(
        msg: "$message",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: Adapt.px(22));
  }

  static showToast(Widget child,{double? left,int duration = 2}) {
    _fToast!.showToast(
        child: child,
        toastDuration: Duration(seconds: duration),
        positionedToastBuilder: (context, child) {
          var _screenSize = window.physicalSize / window.devicePixelRatio;
          return Positioned(
              top: _screenSize.height / 2 - Adapt.px(25),
              left: left == null ? _screenSize.width / 2 - Adapt.px(87) : left,
              child: child);
        });
  }

  static loading() => showToast(_loadingToast());

  static saving() => showToast(_savingToast());

}
