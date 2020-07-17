import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomSizeChangedLayoutNotification extends LayoutChangedNotification{
  Size size;

  CustomSizeChangedLayoutNotification(this.size);
}

class CustomSizeChangedLayoutNotifier extends SingleChildRenderObjectWidget {
  const CustomSizeChangedLayoutNotifier({
    Key key,
    Widget child,
  }) : super(key: key, child: child);

  @override
  _CustomRenderSizeChangedWithCallback createRenderObject(BuildContext context) {
    return _CustomRenderSizeChangedWithCallback(
        onLayoutChangedCallback: (Size size) {
          CustomSizeChangedLayoutNotification(size).dispatch(context);
        }
    );
  }
}

typedef VoidCallbackWithParam = Function(Size size);

class _CustomRenderSizeChangedWithCallback extends RenderProxyBox {
  _CustomRenderSizeChangedWithCallback({
    RenderBox child,
    @required this.onLayoutChangedCallback,
  }) : assert(onLayoutChangedCallback != null),
        super(child);

  final VoidCallbackWithParam onLayoutChangedCallback;

  Size _oldSize;

  @override
  void performLayout() {
    super.performLayout();
    //在第一次layout结束后就会进行通知
    if (size != _oldSize)
      onLayoutChangedCallback(size);
    _oldSize = size;
  }
}
