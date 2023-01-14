import 'dart:convert';

String bukaLoketModelToJson(BukaLoketModel data) => json.encode(data.toJson());

class BukaLoketModel {
  BukaLoketModel({
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

ResponseBukaLoketModel responseBukaLoketModelFromJson(dynamic str) =>
    ResponseBukaLoketModel.fromJson(str);

class ResponseBukaLoketModel {
  ResponseBukaLoketModel({
    this.success,
    this.total,
    this.message,
  });

  bool? success;
  int? total;
  String? message;

  factory ResponseBukaLoketModel.fromJson(Map<String, dynamic> json) =>
      ResponseBukaLoketModel(
        success: json["success"],
        total: json["total"],
        message: json["message"],
      );
}
