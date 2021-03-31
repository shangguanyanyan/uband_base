import 'package:flutter/material.dart';

class NetworkWrapperWidget extends StatefulWidget {
  final Widget child;
  NetworkWrapperWidget(this.child);
  @override
  _NetworkWrapperWidgetState createState() => _NetworkWrapperWidgetState();
}

class _NetworkWrapperWidgetState extends State<NetworkWrapperWidget> {
  // 1、loading 页面
  // 2、对网络错误的try catch
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(),
        widget.child
      ],
    );
  }
}
