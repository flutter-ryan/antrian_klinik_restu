AntrianBerjalanModel antrianBerjalanModelFromJson(dynamic str) =>
    AntrianBerjalanModel.fromJson(str);

class AntrianBerjalanModel {
  AntrianBerjalanModel({
    this.success,
    this.data,
    this.total,
    this.message,
  });

  bool? success;
  List<Datum>? data;
  int? total;
  String? message;

  factory AntrianBerjalanModel.fromJson(Map<String, dynamic> json) =>
      AntrianBerjalanModel(
        success: json["success"],
        data: json["data"] == ""
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        total: json["total"],
        message: json["message"],
      );
}

class Datum {
  Datum({
    this.nomor,
    this.loket,
    this.deskripsi,
    this.status,
    this.statusLoket,
    this.statusBg,
    this.bg,
    this.jmlAntrian,
  });

  String? nomor;
  String? loket;
  String? deskripsi;
  String? status;
  String? statusLoket;
  String? statusBg;
  String? bg;
  String? jmlAntrian;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        nomor: json["NOMOR"],
        loket: json["LOKET"],
        deskripsi: json["DESKRIPSI"],
        status: json["STATUS"],
        statusLoket: json["STATUS_LOKET"],
        statusBg: json["STATUS_BG"],
        bg: json["BG"],
        jmlAntrian: json["JML_ANTRIAN"],
      );
}
