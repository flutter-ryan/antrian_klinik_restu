PoliModel poliModelFromJson(dynamic str) => PoliModel.fromJson(str);

class PoliModel {
  PoliModel({
    this.success,
    this.data,
    this.total,
    this.message,
  });

  bool? success;
  List<Poliklinik>? data;
  int? total;
  String? message;

  factory PoliModel.fromJson(Map<String, dynamic> json) => PoliModel(
        success: json["success"],
        data: List<Poliklinik>.from(
            json["data"].map((x) => Poliklinik.fromJson(x))),
        total: json["total"],
        message: json["message"],
      );
}

class Poliklinik {
  Poliklinik({
    this.id,
    this.deskripsi,
    this.posAntrian,
    this.status,
  });

  String? id;
  String? deskripsi;
  String? posAntrian;
  String? status;

  factory Poliklinik.fromJson(Map<String, dynamic> json) => Poliklinik(
        id: json["ID"],
        deskripsi: json["DESKRIPSI"],
        posAntrian: json["POS_ANTRIAN"],
        status: json["STATUS"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "DESKRIPSI": deskripsi,
        "POS_ANTRIAN": posAntrian,
        "STATUS": status,
      };
}
