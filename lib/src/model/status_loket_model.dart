import 'dart:convert';

String statusLoketModelToJson(StatusLoketModel data) =>
    json.encode(data.toJson());

class StatusLoketModel {
  StatusLoketModel({
    required this.pos,
    required this.loket,
  });

  String pos;
  String loket;

  Map<String, dynamic> toJson() => {
        "POS": pos,
        "LOKET": loket,
      };
}

ResponseStatusLoketModel responseStatusLoketModelFromJson(dynamic str) =>
    ResponseStatusLoketModel.fromJson(str);

class ResponseStatusLoketModel {
  ResponseStatusLoketModel({
    this.success,
    this.message,
  });

  bool? success;
  String? message;

  factory ResponseStatusLoketModel.fromJson(Map<String, dynamic> json) =>
      ResponseStatusLoketModel(
        success: json["success"],
        message: json["message"],
      );
}
