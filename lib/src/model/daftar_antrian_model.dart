import 'dart:convert';

String daftarAntrianModelToJson(DaftarAntrianModel data) =>
    json.encode(data.toJson());

class DaftarAntrianModel {
  DaftarAntrianModel({
    this.pasien,
    this.tanggal,
    this.ruangan,
    this.carabayar,
  });

  String? pasien;
  String? tanggal;
  String? ruangan;
  String? carabayar;

  Map<String, dynamic> toJson() => {
        "pasien": pasien,
        "tanggal": tanggal,
        "ruangan": ruangan,
        "carabayar": carabayar,
      };
}

ResponseDaftarAntrianModel responseDaftarAntrianModelFromJson(dynamic str) =>
    ResponseDaftarAntrianModel.fromJson(str);

class ResponseDaftarAntrianModel {
  ResponseDaftarAntrianModel({
    this.success,
    this.data,
    this.total,
    this.message,
  });

  bool? success;
  Data? data;
  int? total;
  String? message;

  factory ResponseDaftarAntrianModel.fromJson(Map<String, dynamic> json) =>
      ResponseDaftarAntrianModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
        total: json["total"],
        message: json["message"],
      );
}

class Data {
  Data({
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
    this.status,
  });

  String? id;
  String? no;
  String? posAntrian;
  String? noAntrian;
  String? nama;
  String? tempatLahir;
  String? tanggalLahir;
  String? ruangan;
  String? carabayar;
  String? tanggalkunjungan;
  String? tanggal;
  String? status;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["ID"],
        no: json["NO"],
        posAntrian: json["POS_ANTRIAN"],
        noAntrian: json["NO_ANTRIAN"],
        nama: json["NAMA"],
        tempatLahir: json["TEMPAT_LAHIR"],
        tanggalLahir: json["TANGGAL_LAHIR"],
        ruangan: json["RUANGAN"],
        carabayar: json["CARABAYAR"],
        tanggalkunjungan: json["TANGGALKUNJUNGAN"],
        tanggal: json["TANGGAL"],
        status: json["STATUS"],
      );
}
