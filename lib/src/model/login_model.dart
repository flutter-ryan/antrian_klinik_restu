import 'dart:convert';

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    required this.email,
    required this.password,
  });

  String email;
  String password;

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}

ResponseLoginModel responseLoginModelFromJson(dynamic str) =>
    ResponseLoginModel.fromJson(str);

class ResponseLoginModel {
  ResponseLoginModel({
    this.success,
    this.data,
    this.message,
  });

  bool? success;
  Data? data;
  String? message;

  factory ResponseLoginModel.fromJson(Map<String, dynamic> json) =>
      ResponseLoginModel(
        success: json["success"],
        data: json["data"] == '' ? null : Data.fromJson(json["data"]),
        message: json["message"],
      );
}

class Data {
  Data({
    this.id,
    this.nama,
    this.tempatLahir,
    this.tanggalLahir,
    this.agama,
    this.namaAgama,
    this.jk,
    this.alamat,
    this.telepon,
    this.email,
    this.users,
    this.level,
    this.levelAkses,
    this.nmRuanganAkses,
    this.status,
    this.ruanganAkses,
    this.posAntrian,
    this.nmPos,
  });

  String? id;
  String? nama;
  String? tempatLahir;
  DateTime? tanggalLahir;
  String? agama;
  String? namaAgama;
  String? jk;
  String? alamat;
  String? telepon;
  String? email;
  dynamic users;
  String? level;
  String? levelAkses;
  String? nmRuanganAkses;
  String? status;
  String? ruanganAkses;
  String? posAntrian;
  String? nmPos;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["ID"],
        nama: json["NAMA"],
        tempatLahir: json["TEMPAT_LAHIR"],
        tanggalLahir: DateTime.parse(json["TANGGAL_LAHIR"]),
        agama: json["AGAMA"],
        namaAgama: json["NAMA_AGAMA"],
        jk: json["JK"],
        alamat: json["ALAMAT"],
        telepon: json["TELEPON"],
        email: json["EMAIL"],
        users: json["USERS"],
        level: json["LEVEL"],
        levelAkses: json["LEVEL_AKSES"],
        nmRuanganAkses: json["NM_RUANGAN_AKSES"],
        status: json["STATUS"],
        ruanganAkses: json["RUANGAN_AKSES"],
        posAntrian: json["POS_ANTRIAN"],
        nmPos: json["NM_POS"],
      );
}
