import 'package:flutter/material.dart';
import 'package:ubandbase/constant/base_colour.dart';
import 'package:ubandbase/utils/adapt_util.dart';
import 'package:ubandbase/utils/quick_util.dart';

/// 带有固定背景的按钮
class ContainedButton extends StatelessWidget {
  final String text;
  final String background;
  final VoidCallback onPress;

  ContainedButton(
      {required this.text, required this.background, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return FlatButtonWrapper(
        onPressed: onPress,
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: Adapt.px(100),
          decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(background))),
          child: Quick.buildText("$text", fontSize: 36)
              .colorHex(BaseColour.white)
              .build(),
        ));
  }
}

/// 封装imageIcon
class ImageIconButtonWrapper extends StatelessWidget with BottomDecorator {
  final String resource;
  final VoidCallback onPress;
  final double iconSize;
  final Color? color;

  ImageIconButtonWrapper(this.resource,
      {required this.onPress, Key? key, this.iconSize = 24, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: iconSize,
      padding: EdgeInsets.zero,
      onPressed: () {
        vibrate();
        onPress();
      },
      icon: ImageIcon(AssetImage(resource), color: color),
    );
  }
}

/// 封装flatButton
class FlatButtonWrapper extends StatelessWidget with BottomDecorator {
  final Key? key;
  final Widget child;
  final VoidCallback onPressed;
  final VoidCallback? onLongPressed;

  FlatButtonWrapper(
      {this.key,
      required this.child,
      required this.onPressed,
      this.onLongPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          vibrate();
          onPressed?.call();
        },
        onLongPress: () {
          vibrate();
          onLongPressed?.call();
        },
        child: child);
  }
}

mixin BottomDecorator on StatelessWidget {
  void vibrate() {}
}
