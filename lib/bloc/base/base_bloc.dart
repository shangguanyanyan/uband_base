import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'base_event.dart';

part 'base_state.dart';

abstract class BaseBloc<E extends BaseEvent, S extends BaseState>
    extends Bloc<E, S> {
  BaseBloc(initialState) : super(initialState);

  Stream<BaseState> function(BaseEvent event,
      Future<Success> Function({BaseEvent event}) action) async* {
    try {
      yield Loading();
      yield await action(event: event);
    } on DioError catch (e) {
      if (e.error is Map) {
        yield Failure(code: e.error["code"], message: e.error["msg"]);
      } else if (e.error is SocketException) {
        yield Failure(code: 404, message: "网络异常");
      } else {
        yield Failure(code: 404, message: "${e.error}");
      }
    }
  }
}
