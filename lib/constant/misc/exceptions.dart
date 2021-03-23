/// 业务异常
class BizException {
  BizException(this.code, this.message);

  final String code;
  final String message;

  String toString() {
    return 'HttpException{code: $code, message: $message}';
  }
}
