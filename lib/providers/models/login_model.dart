// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  bool? error;
  String? message;
  Data? data;

  LoginModel({
    this.error,
    this.message,
    this.data,
  });

  LoginModel copyWith({
    bool? error,
    String? message,
    Data? data,
  }) =>
      LoginModel(
        error: error ?? this.error,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        error: json["error"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  int? id;
  String? email;
  String? accountType;
  String? authToken;

  Data({
    this.id,
    this.email,
    this.accountType,
    this.authToken,
  });

  Data copyWith({
    int? id,
    String? email,
    String? accountType,
    String? authToken,
  }) =>
      Data(
        id: id ?? this.id,
        email: email ?? this.email,
        accountType: accountType ?? this.accountType,
        authToken: authToken ?? this.authToken,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        email: json["email"],
        accountType: json["account_type"],
        authToken: json["auth_token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "account_type": accountType,
        "auth_token": authToken,
      };
}
