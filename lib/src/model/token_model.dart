import 'dart:convert';

String tokenModelToJson(TokenModel data) => json.encode(data);

class TokenModel {
  String username;
  String password;

  TokenModel({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
      };
}

ResponseTokenModel responseTokenModelFromJson(dynamic str) =>
    ResponseTokenModel.fromJson(str);

class ResponseTokenModel {
  bool success;
  String? token;
  String? message;

  ResponseTokenModel({
    this.success = false,
    this.token,
    this.message,
  });

  factory ResponseTokenModel.fromJson(Map<String, dynamic> json) =>
      ResponseTokenModel(
        success: json["success"],
        token: json["token"],
        message: json["message"],
      );
}
