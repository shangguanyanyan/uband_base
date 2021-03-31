import 'dart:convert';

import 'package:ubandbase/export.dart';

class ErrorInterceptor extends InterceptorsWrapper {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data["code"] != null) {
      if (response.data["code"] == 401) {
        return handler.reject(DioError(
            response: response,
            error: response.data,
            requestOptions: response.requestOptions));
      }
      if (response.data["code"] != 200) {
        var msg = "";
        if (response.data is Map) {
          if (response.data["msg"] != null) {
            msg = response.data["msg"];
          } else {
            msg = json.encode(response.data ?? "");
          }
        } else {
          msg = json.encode(response.data ?? "");
        }
        return handler.reject(DioError(
            requestOptions: response.requestOptions,
            response: response,
            error: msg));
      }
    }
    return handler.next(response);
  }
}
