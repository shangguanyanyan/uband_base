import 'package:flutter/foundation.dart';

/// 节流函数
/// 控制目标函数在一定时间内只调用一次
class Throttle {

  Duration duration;

  DateTime recentTrigger;

  Throttle._();

  Throttle.throttle(Duration duration) {
    this.duration = duration;
    recentTrigger = DateTime.now();
  }

  void apply(VoidCallback callback) {
    DateTime now = DateTime.now();
    if (recentTrigger.add(duration).compareTo(now) <= 0) {
      callback?.call();
      recentTrigger = now;
    }
  }
}