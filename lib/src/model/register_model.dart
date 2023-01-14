import 'dart:convert';

String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel {
  RegisterModel({
    this.nama,
    this.tempatlahir,
    this.tanggallahir,
    this.agama,
    this.jk,
    this.alamat,
    this.telepon,
    this.email,
    this.password1,
    this.password2,
  });

  String? nama;
  String? tempatlahir;
  String? tanggallahir;
  String? agama;
  String? jk;
  String? alamat;
  String? telepon;
  String? email;
  String? password1;
  String? password2;

  Map<String, dynamic> toJson() => {
        "nama": nama,
        "tempatlahir": tempatlahir,
        "tanggallahir": tanggallahir,
        "agama": agama,
        "jk": jk,
        "alamat": alamat,
        "telepon": telepon,
        "email": email,
        "password1": password1,
        "password2": password2,
      };
}

ResponseRegisterModel responseRegisterModelFromJson(dynamic str) =>
    ResponseRegisterModel.fromJson(str);

class ResponseRegisterModel {
  ResponseRegisterModel({
    this.success,
    this.total,
    this.message,
  });

  bool? success;
  int? total;
  String? message;

  factory ResponseRegisterModel.fromJson(Map<String, dynamic> json) =>
      ResponseRegisterModel(
        success: json["success"],
        total: json["total"],
        message: json["message"],
      );
}
