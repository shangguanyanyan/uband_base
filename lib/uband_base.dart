import 'dart:async';

import 'package:flutter/services.dart';

class UbandBase {
  static const MethodChannel _channel =
      const MethodChannel('uband_base');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
