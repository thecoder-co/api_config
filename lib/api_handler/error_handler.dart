import 'dart:io';

import 'api_response.dart';
import 'package:dio/dio.dart';

Response handleError(DioException e) {
  Response response;
  response = switch (e.type) {
    DioExceptionType.cancel => response = Response(
        data: apiResponse(
          message: 'Request cancelled!',
        ),
        requestOptions: RequestOptions(path: ''),
      ),
    DioExceptionType.connectionTimeout ||
    DioExceptionType.connectionError =>
      response = Response(
        data: apiResponse(
          message: 'Network connection timed out!',
        ),
        requestOptions: RequestOptions(path: ''),
      ),
    DioExceptionType.receiveTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.badCertificate =>
      response = Response(
        data: apiResponse(
          message: 'Something went wrong. Please try again later!',
        ),
        requestOptions: RequestOptions(path: ''),
      ),
    DioExceptionType.unknown => e.error is SocketException
        ? response = Response(
            data: apiResponse(
              message: 'Please check your network connection!',
            ),
            requestOptions: RequestOptions(path: ''),
          )
        : response = Response(
            data: apiResponse(
              message: 'Network connection issue',
            ),
            requestOptions: RequestOptions(path: ''),
          ),
    DioExceptionType.badResponse => e.response?.data.runtimeType == String
        ? response = Response(
            data: apiResponse(
              message: e.response?.data ??
                  'Something went wrong. Please try again later',
              data: {
                'error': true,
                'message': 'Something went wrong. Please try again later',
                'details': e.response?.data,
              },
            ),
            statusCode: e.response?.statusCode ?? 000,
            statusMessage: e.response?.statusMessage ?? 'NULL',
            requestOptions: RequestOptions(path: ''),
          )
        : response = Response(
            data: apiResponse(
              message: e.response?.data?['message'] ??
                  'Something went wrong. Please try again later',
              data: e.response?.data,
            ),
            statusCode: e.response?.statusCode ?? 000,
            statusMessage: e.response?.statusMessage ?? 'NULL',
            requestOptions: RequestOptions(path: ''),
          ),
  };
  return response;
}
