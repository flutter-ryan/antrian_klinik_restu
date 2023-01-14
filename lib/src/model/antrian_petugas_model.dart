import 'dart:convert';

String antrianPetugasModelToJson(AntrianPetugasModel data) =>
    json.encode(data.toJson());

class AntrianPetugasModel {
  AntrianPetugasModel({
    this.pos,
  });

  String? pos;

  Map<String, dynamic> toJson() => {
        "pos": pos,
      };
}

ResponseAntrianPetugasModel responseAntrianPetugasModelFromJson(dynamic str) =>
    ResponseAntrianPetugasModel.fromJson(str);

class ResponseAntrianPetugasModel {
  ResponseAntrianPetugasModel({
    this.success,
    this.data,
    this.total,
    this.message,
  });

  bool? success;
  List<AntrianPetugas>? data;
  int? total;
  String? message;

  factory ResponseAntrianPetugasModel.fromJson(Map<String, dynamic> json) =>
      ResponseAntrianPetugasModel(
        success: json["success"],
        data: json["data"] == ''
            ? null
            : List<AntrianPetugas>.from(
                json["data"].map((x) => AntrianPetugas.fromJson(x))),
        total: json["total"],
        message: json["message"],
      );
}

class AntrianPetugas {
  AntrianPetugas({
    this.tgl,
    this.id,
    this.no,
    this.posAntrian,
    this.noAntrian,
    this.nama,
    this.tempatLahir,
    this.tanggalLahir,
    this.ruangan,
    this.carabayar,
    this.tanggalkunjungan,
    this.tanggal,
    this.statusAntrian,
    this.status,
  });

  DateTime? tgl;
  String? id;
  String? no;
  String? posAntrian;
  String? noAntrian;
  String? nama;
  Stream? tempatLahir;
  String? tanggalLahir;
  String? ruangan;
  String? carabayar;
  DateTime? tanggalkunjungan;
  String? tanggal;
  String? statusAntrian;
  String? status;

  factory AntrianPetugas.fromJson(Map<String, dynamic> json) => AntrianPetugas(
        tgl: DateTime.parse(json["tgl"]),
        id: json["ID"],
        no: json["NO"],
        posAntrian: json["POS_ANTRIAN"],
        noAntrian: json["NO_ANTRIAN"],
        nama: json["NAMA"],
        tempatLahir: json["TEMPAT_LAHIR"],
        tanggalLahir: json["TANGGAL_LAHIR"],
        ruangan: json["RUANGAN"],
        carabayar: json["CARABAYAR"],
        tanggalkunjungan: DateTime.parse(json["TANGGALKUNJUNGAN"]),
        tanggal: json["TANGGAL"],
        statusAntrian: json["STATUS_ANTRIAN"],
        status: json["STATUS"],
      );
}
