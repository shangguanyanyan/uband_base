part of 'base_bloc.dart';

abstract class BaseState extends Equatable {
  const BaseState();
}

abstract class Success extends BaseState {}

class Loading extends BaseState {
  @override
  List<Object> get props => [];
}

class Failure extends BaseState {
  final int code;
  final String message;

  Failure({this.code = 0, this.message = ""});

  @override
  List<Object> get props => [code, message];
}
