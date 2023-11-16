import 'dart:convert';
import 'dart:developer';
import 'package:api_config_riverpod/api_handler/app_endpoints.dart';
import 'package:api_config_riverpod/local_data/local_data.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'bad_certificate_fixer.dart';
import 'default_time_response_interceptor.dart';
import 'error_handler.dart';
import 'talker.dart';
import 'form_data_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

class BackendService {
  final Dio _dio;
  final String? otherBaseUrl;
  final bool jsonEncodeAllData;
  final bool shouldLog;

  BackendService(
    this._dio, {
    this.otherBaseUrl,
    this.shouldLog = false,
    this.jsonEncodeAllData = true,
  }) {
    initializeDio();
  }

  void initializeDio() {
    //
    _dio.options = BaseOptions(
      baseUrl: otherBaseUrl ?? AppEndpoints.baseUrl,
      connectTimeout: const Duration(milliseconds: 50000),
      receiveTimeout: const Duration(milliseconds: 50000),
    );

    _dio.options.baseUrl = otherBaseUrl ?? AppEndpoints.baseUrl;
    _dio.interceptors.addAll([
      // DefaultAPIInterceptor(dio: _dio),
      RetryInterceptor(
        dio: dio,
        logPrint: talker.log, // specify log function (optional)
        retries: 3,
        retryDelays: [
          const Duration(seconds: 2),
          const Duration(seconds: 4),
          const Duration(seconds: 6),
        ],
      ),
    ]);
    fixBadCertificate(dio: dio);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: authRequestInterceptors,
      ),
    );
    if (kDebugMode) {
      _dio.interceptors.add(TimeResponseInterceptor());

      _dio.interceptors.add(FormDataInterceptor());
      _dio.interceptors.add(
        TalkerDioLogger(
          talker: talker,
          settings: const TalkerDioLoggerSettings(
            printRequestHeaders: true,
            printResponseHeaders: false,
            printResponseData: true,
            printResponseMessage: true,
          ),
        ),
      );
    }
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: jsonRequestInterceptor,
      ),
    );
  }

  void jsonRequestInterceptor(
    RequestOptions options,
    RequestInterceptorHandler requestInterceptorHandler,
  ) {
    if (jsonEncodeAllData && options.data != null && options.data is Map) {
      options.data = jsonEncode(options.data);
      options.headers.addAll({'Content-Type': 'application/json'});
    }

    return requestInterceptorHandler.next(options);
  }

  void authRequestInterceptors(
    RequestOptions options,
    RequestInterceptorHandler requestInterceptorHandler,
  ) {
    String? token = LocalData.instance.token;
    if (token != null) {
      options.headers.addAll({'Authorization': 'Bearer $token'});
    }
    return requestInterceptorHandler.next(options);
  }

  Dio get dio => _dio;

  // Returns the same instance of dio throughout the application
  BackendService clone() => BackendService(_dio);

  dynamic runCall(Future<Response> data) async {
    try {
      return await data;
    } on DioException catch (e) {
      return handleError(e);
    } catch (e) {
      log('Something happened $e');
      rethrow;
    }
  }
}
