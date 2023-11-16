import 'package:my_attorney/core/constants/app_endpoints.dart';
import 'package:my_attorney/core/services/api_handler/api_client_config.dart';
import 'package:my_attorney/core/services/api_handler/api_handler_models.dart';

import 'package:my_attorney/features/auth/models/login_model.dart';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class AuthRepo {
  AuthRepo({
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.username,
    this.phoneNumber,
    this.otp,
    this.forgotPasswordEmail,
    this.forgotPasswordOtp,
    this.newPassword,
  });

  final BackendService _apiService = BackendService(Dio());
  bool isLoggedIn = false;
  String? email;
  String? password;
  String? username;

  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? otp;

  String? forgotPasswordEmail;
  String? forgotPasswordOtp;
  String? newPassword;

  //copyWith
  AuthRepo copyWith({
    String? email,
    String? password,
    String? username,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? otp,
    String? forgotPasswordEmail,
    String? forgotPasswordOtp,
    String? newPassword,
  }) {
    return AuthRepo(
      email: email ?? this.email,
      password: password ?? this.password,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otp: otp ?? this.otp,
      forgotPasswordEmail: forgotPasswordEmail ?? this.forgotPasswordEmail,
      forgotPasswordOtp: forgotPasswordOtp ?? this.forgotPasswordOtp,
      newPassword: newPassword ?? this.newPassword,
    );
  }

  @override
  int get hashCode => UniqueKey().hashCode;

  Future<ResponseModel> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  }) async {
    Response response = await _apiService.runCall(
      _apiService.dio.post(
        '${AppEndpoints.baseUrl}/api/auth/account/create',
        data: {
          "email": email,
          "password": password,
          'username': username,
        },
      ),
    );

    final int statusCode = response.statusCode ?? 000;

    if (statusCode >= 200 && statusCode <= 300) {
      return ResponseModel(
        valid: true,
        statusCode: statusCode,
        message: response.statusMessage,
        data: response.data,
      );
    }

    return ResponseModel(
      error: ErrorModel.fromJson(response.data),
      statusCode: statusCode,
      message: response.data['message'],
    );
  }

  Future<ResponseModel<LoginModel>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    Response response = await _apiService.runCall(
      _apiService.dio.post(
        '${AppEndpoints.baseUrl}/api/auth/login',
        data: {"email": email, "password": password},
      ),
    );

    final int statusCode = response.statusCode ?? 000;

    if (statusCode >= 200 && statusCode <= 300) {
      return ResponseModel<LoginModel>(
        valid: true,
        statusCode: statusCode,
        message: response.statusMessage,
        data: LoginModel.fromJson(response.data),
      );
    }

    return ResponseModel(
      error: ErrorModel.fromJson(response.data),
      statusCode: statusCode,
      message: response.data['message'],
    );
  }

  Future<ResponseModel<LoginModel>> verifyAccount({
    required String email,
    required String otp,
  }) async {
    Response response = await _apiService.runCall(
      _apiService.dio.post(
        '${AppEndpoints.baseUrl}/api/auth/account/verify',
        data: {
          "email": email,
          "otp": otp,
        },
      ),
    );

    final int statusCode = response.statusCode ?? 000;

    if (statusCode >= 200 && statusCode <= 300) {
      return ResponseModel<LoginModel>(
        valid: true,
        statusCode: statusCode,
        message: response.statusMessage,
        data: LoginModel.fromJson(response.data),
      );
    }

    return ResponseModel(
      error: ErrorModel.fromJson(response.data),
      statusCode: statusCode,
      message: response.data['message'],
    );
  }

  Future<ResponseModel<LoginModel>> resendOtp({
    required String email,
  }) async {
    Response response = await _apiService.runCall(
      _apiService.dio.post(
        '${AppEndpoints.baseUrl}/api/auth/account/verification/request',
        data: {
          "email": email,
        },
      ),
    );

    final int statusCode = response.statusCode ?? 000;

    if (statusCode >= 200 && statusCode <= 300) {
      return ResponseModel<LoginModel>(
        valid: true,
        statusCode: statusCode,
        message: response.statusMessage,
        data: LoginModel.fromJson(response.data),
      );
    }

    return ResponseModel(
      error: ErrorModel.fromJson(response.data),
      statusCode: statusCode,
      message: response.data['message'],
    );
  }

  Future<ResponseModel<LoginModel>> forgotPassword({
    required String email,
  }) async {
    Response response = await _apiService.runCall(
      _apiService.dio.post(
        '${AppEndpoints.baseUrl}/api/auth/password/forgot',
        data: {
          "email": email,
        },
      ),
    );

    final int statusCode = response.statusCode ?? 000;

    if (statusCode >= 200 && statusCode <= 300) {
      return ResponseModel<LoginModel>(
        valid: true,
        statusCode: statusCode,
        message: response.statusMessage,
        data: LoginModel.fromJson(response.data),
      );
    }

    return ResponseModel(
      error: ErrorModel.fromJson(response.data),
      statusCode: statusCode,
      message: response.data['message'],
    );
  }

  Future<ResponseModel<LoginModel>> resetPassword({
    required String email,
    required String password,
    required String otp,
  }) async {
    Response response = await _apiService.runCall(
      _apiService.dio.post(
        '${AppEndpoints.baseUrl}/api/auth/password/reset',
        data: {
          "email": email,
          "password": password,
          "otp": otp,
        },
      ),
    );

    final int statusCode = response.statusCode ?? 000;

    if (statusCode >= 200 && statusCode <= 300) {
      return ResponseModel<LoginModel>(
        valid: true,
        statusCode: statusCode,
        message: response.statusMessage,
        data: LoginModel.fromJson(response.data),
      );
    }

    return ResponseModel(
      error: ErrorModel.fromJson(response.data),
      statusCode: statusCode,
      message: response.data['message'],
    );
  }
}
