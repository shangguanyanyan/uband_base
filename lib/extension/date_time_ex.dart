import 'package:intl/intl.dart';

const String formatDateWithLine = 'yyyy-MM-dd';
const String formatDateWithDote = 'yyyy.MM.dd';
const String formatDateTimeWithDote = 'yyyy.MM.dd HH:mm:ss';
const String formatDateTimeWithLine = 'yyyy-MM-dd HH:mm:ss';
const String formatDateWithTime = 'MM-dd mm:ss';
const String formatWithHour = "HH:mm";

extension DateTimeEX on DateTime {
  String yMd() {
    return DateFormat.yMd().format(this);
  }

  String md() {
    return DateFormat.Md().format(this);
  }

  String format([String format = 'yyyy-MM-dd HH:mm:ss']) {
    return DateFormat(format).format(this);
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool get isToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return DateTime(year, month, day) == today;
  }

  bool get isYesterday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day - 1);
    return DateTime(year, month, day) == today;
  }

  bool get isTomorrow {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day + 1);
    return DateTime(year, month, day) == today;
  }

  /// 使用此方法前，必须在 main 方法中调用 initializeDateFormatting([$local]) 方法
  String getDateFormat(String format, {String local = "zh_CN"}) {
    return DateFormat(format, local).format(this..toLocal());
  }
}
