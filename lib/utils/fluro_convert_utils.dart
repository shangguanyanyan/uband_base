import 'dart:convert';

/// fluro 参数编码解码工具类
/// 对应库pub链接：https://pub.flutter-io.cn/packages/fluro
class FluroConvertUtils {
  /// fluro 传递中文参数前，先转换，fluro 不支持中文传递
  static String fluroCnParamsEncode(String originalCn) {
    return jsonEncode(Utf8Encoder().convert(originalCn));
  }

  /// fluro 传递后取出参数，解析
  static String fluroCnParamsDecode(String encodeCn) {
    var list = List<int>();

    ///字符串解码
    jsonDecode(encodeCn).forEach(list.add);
    String value = Utf8Decoder().convert(list);
    return value;
  }

  static String fluroUrlParamsEncode(String originalUrl){
    return Uri.encodeComponent(originalUrl);
  }

  static String fluroUrlParamsDecode(String encodeUrl){
    return Uri.decodeComponent(encodeUrl);
  }
  /// string 转为 int
  static int string2int(String str) {
    return int.parse(str);
  }

  /// string 转为 double
  static double string2double(String str) {
    return double.parse(str);
  }

  /// string 转为 bool
  static bool string2bool(String str) {
    if (str == 'true') {
      return true;
    } else {
      return false;
    }
  }

  /// object 转为 string json
  static String object2string<T>(T t) {
    return fluroCnParamsEncode(jsonEncode(t));
  }

  /// string json 转为 map
  static Map<String, dynamic> string2map(String str) {
    return json.decode(fluroCnParamsDecode(str));
  }

  /// 路由参数拼接
  static String joinRouteParam(String routeName, Map<String, dynamic> param) {
    if (!routeName.contains('?')) {
      routeName = routeName + '?';
    }
    param.forEach((key, param) {
      routeName = routeName + key + "=" + "$param" + "&";
    });
    routeName = routeName.substring(0,routeName.length-1);
    return routeName;
  }
}
