Map apiResponse({
  String? message,
  int? errorCode,
  String? errorfield,
  data,
}) {
  return {
    'message': message ?? 'Something went wrong, Please try again later',
    'errorCode': errorCode ?? '000',
    'errorField': errorfield ?? 'null',
    'data': data
  };
}
