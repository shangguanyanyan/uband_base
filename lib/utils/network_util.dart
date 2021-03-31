import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
import 'package:cookie_jar/cookie_jar.dart';

class NetworkUtil {
  /// Dio 实例
  static late Dio _instance;

  static late bool _debug;

  static late String _baseUrl;

  static String _userAgent = "";

  static int? _timeout;

  static bool? _followRedirects;

  static ResponseType? _responseType;

  static bool? _receiveDataWhenStatusError;

  static late CookieJar _cookieJar;

  static String? _authStringName;

  // 保存 cookie 的操作是异步的，
  // 保证在 setCookie 后能拿到正确的 认证信息
  static String? _authString;

  NetworkUtil._();

  static Dio get instance => _instance;

  /// 初始化调用
  static init({
    required String baseUrl,
    CookieJar? cookieJar,
    int? timeout,
    String? userAgent,
    bool? followRedirects,
    bool? receiveDataWhenStatusError,
    ResponseType? responseType,
    String? authStringName,
    bool? debug,
  }) {
    _baseUrl = baseUrl;
    _timeout = timeout ?? 5000;
    _userAgent = userAgent ?? _userAgent;
    _followRedirects = followRedirects ?? false;
    _responseType = responseType ?? ResponseType.json;
    _receiveDataWhenStatusError = receiveDataWhenStatusError ?? false;
    _debug = debug ?? false;
    _cookieJar = cookieJar ?? PersistCookieJar();
    _authStringName = authStringName ?? 'X-Auth-Token';
    _instance = Dio(BaseOptions(
      connectTimeout: _timeout,
      receiveTimeout: null,
      sendTimeout: null,
      baseUrl: _baseUrl,
      queryParameters: null,
      extra: null,
      headers: {'User-Agent': _userAgent},
      validateStatus: null,
      receiveDataWhenStatusError: _receiveDataWhenStatusError,
      followRedirects: _followRedirects,
      responseType: _responseType,
    ));

    /// 添加默认的拦截器
    _instance.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options, handler) {
      if (options.extra['withAuth'] as bool) {
        _addAuthString(options);
      }
      return handler.next(options);
    }));
    if (_debug) {
      /// 调试模式下打印网络调试信息
      _instance.interceptors.add(LogInterceptor());

      /// 调试模式下忽略证书校验
      (_instance.httpClientAdapter as DefaultHttpClientAdapter)
          .onHttpClientCreate = (client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) {
          return true;
        };
      };
    }
  }

  /// 添加认证信息
  static _addAuthString(RequestOptions options) {
    String? authString = _authString;
    if (authString == null) {
      List<Cookie> cookieList = _cookieJar.loadForRequest(Uri.parse(_baseUrl));
      for (Cookie cookie in cookieList) {
        if (cookie.name == _authStringName) {
          authString = cookie.value;
          break;
        }
      }
    }
    options.headers[_authStringName!] = authString ?? "";
    return options;
  }

  static void addInterceptor(Interceptor interceptor) {
    instance.interceptors.add(interceptor);
  }

  /// get请求
  static Future<Response<T>> get<T>(String url, {
    bool withAuth = true,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
  }) async {
    return instance.get<T>(
      url,
      queryParameters: params,
      options: Options(
        extra: {'withAuth': withAuth},
        headers: headers,
      ),
    );
  }

  /// post 请求
  static Future<Response<T>> post<T>(String url, {
    bool withAuth = true,
    Map<String, dynamic>? params,
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    return instance.post<T>(
      url,
      queryParameters: params,
      data: data,
      options: Options(
        extra: {'withAuth': withAuth},
        headers: headers,
      ),
    );
  }

  /// post 请求
  static Future<Response<T>> put<T>(String url, {
    bool withAuth = true,
    Map<String, dynamic>? params,
    dynamic data,
    Map<String, dynamic>? headers,
  }) {
    return instance.put<T>(
      url,
      queryParameters: params,
      data: data,
      options: Options(
        extra: {'withAuth': withAuth},
        headers: headers,
      ),
    );
  }

  /// post 请求
  static Future<Response<T>> delete<T>(String url, {
    bool withAuth = true,
    Map<String, dynamic>? params,
    dynamic data,
    Map<String, dynamic>? headers,
  }) {
    return instance.delete<T>(
      url,
      queryParameters: params,
      data: data,
      options: Options(
        extra: {'withAuth': withAuth},
        headers: headers,
      ),
    );
  }

  /// post 请求
  static Future<Response> download(String url,
      String to, {
        bool withAuth = true,
        Map<String, dynamic>? params,
        dynamic data,
      }) {
    return instance.download(
      url,
      to,
      queryParameters: params,
      data: data,
      options: Options(extra: {'withAuth': withAuth}),
    );
  }

  /// 上传文件，待实现
  static Future<Response?> upload<T>() async {
    return null;
  }

  /// 保存认证信息
  static saveAuthString(String token) {
    Uri uri = Uri.parse(_baseUrl);
    _authString = token;
    _cookieJar.saveFromResponse(uri,
        _cookieJar.loadForRequest(uri)
          ..add(Cookie(_authStringName!, token)));
  }

  static bool hasToken() {
    List<Cookie> cookieList = _cookieJar.loadForRequest(Uri.parse(_baseUrl));
    bool result = false;
    if (_authString != null) {
      result = true;
    }
    result = cookieList.any((e) {
      return e.name == _authStringName && e.value != "";
    });
    return result;
  }

  static cleanAuthString() {
    Uri uri = Uri.parse(_baseUrl);
    _authString = null;
    _cookieJar.saveFromResponse(
        uri, _cookieJar.loadForRequest(uri)
      ..add(Cookie(_authStringName!, "")));
  }
}
