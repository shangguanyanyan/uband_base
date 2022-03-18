import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

class CommonUtil {
  static p.Context _context = p.Context();

  static RegExp _specialCharsetRe = RegExp("[\n`~!@#\$%^&*()+=|{}':;',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。， 、？]");

  static RegExp _specialCharsetReNotIncludeSpace = RegExp("[`~!@#\$%^&*()+=|{}':;',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。， 、？]");

  CommonUtil._();

  static String getTempDir() {
    return Directory.systemTemp.path;
  }

  static bool isFullScreen(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return orientation == Orientation.landscape;
  }

  static getDateFormat(String endDate, String format) {
    return DateFormat(format, "zh_CN").format(DateTime.parse(endDate).toLocal());
  }

  static String trimSpecialCharset(String str, [bool notIncludeReturn = true]) {
    if (notIncludeReturn) {
      return str.replaceAll(_specialCharsetReNotIncludeSpace, '');
    }
    return str.replaceAll(_specialCharsetRe, '');
  }
}
