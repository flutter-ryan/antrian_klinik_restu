import 'dart:convert';

String panggilAntrianModelToJson(PanggilAntrianModel data) =>
    json.encode(data.toJson());

class PanggilAntrianModel {
  PanggilAntrianModel({
    required this.nomor,
    required this.pos,
    required this.loket,
  });

  String nomor;
  String pos;
  String loket;

  Map<String, dynamic> toJson() => {
        "NOMOR": nomor,
        "POS": pos,
        "LOKET": loket,
      };
}

ResponsePanggilAntrianModel responsePanggilAntrianModelFromJson(dynamic str) =>
    ResponsePanggilAntrianModel.fromJson(str);

class ResponsePanggilAntrianModel {
  ResponsePanggilAntrianModel({
    this.success,
    this.data,
    this.total,
    this.message,
  });

  bool? success;
  Data? data;
  int? total;
  String? message;

  factory ResponsePanggilAntrianModel.fromJson(Map<String, dynamic> json) =>
      ResponsePanggilAntrianModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
        total: json["total"],
        message: json["message"],
      );
}

class Data {
  Data({
    this.noAntrian,
    this.no,
    this.posAntrian,
  });

  String? noAntrian;
  String? no;
  String? posAntrian;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        noAntrian: json["NO_ANTRIAN"],
        no: json["NO"],
        posAntrian: json["POS_ANTRIAN"],
      );
}
