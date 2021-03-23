import 'package:flutter/material.dart';
import 'package:ubandbase/widget/flutter_custom_dialog/flutter_custom_dialog.dart';

/// 封装了基本的弹框效果
class BaseDialog {
  BaseDialog._();

  /// 弹框从底部弹出效果
  static YYDialog showBottom(BuildContext context, Widget widget,
      {bool autoShow = true, bool autoDismiss = false}) {
    YYDialog dialog = YYDialog().build();
    dialog.context = context;
    dialog.gravity = Gravity.bottom;
    dialog.gravityAnimationEnable = true;
    dialog.backgroundColor = Colors.transparent;
    dialog.dismissCallBack = () {
    };
    dialog.widget(widget);
    if (autoShow) {
      dialog.show();
    }
    if (autoDismiss) {
      Future.delayed(Duration(seconds: 1), () {
        dialog.dismiss();
      });
    }
    return dialog;
  }

  /// 弹框从中间弹出效果
  static YYDialog showCenter(BuildContext context, Widget widget,
      {bool autoShow = true, bool autoDismiss = false,barrierDismissible = false}) {
    YYDialog dialog = YYDialog().build();
    dialog.context = context;
    dialog.gravityAnimationEnable = true;
    dialog.barrierDismissible = barrierDismissible;
    dialog.backgroundColor = Colors.transparent;
    dialog.widget(widget);
    if (autoShow) {
      dialog.show();
    }
    if (autoDismiss) {
      Future.delayed(Duration(seconds: 1), () {
        dialog.dismiss();
      });
    }
    return dialog;
  }
}