class ResponseModel<T> {
  late int? statusCode;
  late ErrorModel? error;
  late bool valid = false;
  late String? message = '';
  late String token;
  late T? data;

  ResponseModel({valid, message, statusCode, this.data, error, token}) {
    this.valid = valid ?? false;
    this.message = message ?? '';
    this.statusCode = statusCode ?? 000;
    this.token = token ?? '';
    this.error = error ?? ErrorModel();
  }
}

class ErrorModel {
  String? errorCode;
  String? message;
  dynamic errorField;
  String? token;

  ErrorModel({this.errorCode, this.message, this.errorField, this.token});

  @override
  String toString() {
    return '{errorCode: $errorCode, message: $message}';
  }

  factory ErrorModel.fromJson(dynamic data) {
    if (data is String) {
      return ErrorModel(
          errorCode: '', message: data, errorField: '', token: '');
    }
    return ErrorModel(
        errorCode: data['errorCode'] ?? '',
        message: data['message'] ?? '',
        errorField: data['errorField'] ?? '',
        token: data['token'] ?? '');
  }
}
