import 'package:intl/intl.dart';

class DateUtil {
  /// 使用此方法前，必须在 main 方法中调用 initializeDateFormatting([$local]) 方法
  static getDateFormat(String endDate, String format,
      {String local = "zh_CN"}) {
    return DateFormat(format, local)
        .format(DateTime.parse(endDate).toLocal());
  }
}
