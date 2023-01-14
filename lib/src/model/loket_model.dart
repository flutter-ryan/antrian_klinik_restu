LoketModel loketModelFromJson(dynamic str) => LoketModel.fromJson(str);

class LoketModel {
  LoketModel({
    this.success,
    this.data,
    this.message,
  });

  bool? success;
  List<Loket>? data;
  String? message;

  factory LoketModel.fromJson(Map<String, dynamic> json) => LoketModel(
        success: json["success"],
        data: json["data"].length == 0
            ? null
            : List<Loket>.from(json["data"].map((x) => Loket.fromJson(x))),
        message: json["message"],
      );
}

class Loket {
  Loket({
    this.id,
    this.deskripsi,
    this.status,
  });

  String? id;
  String? deskripsi;
  String? status;

  factory Loket.fromJson(Map<String, dynamic> json) => Loket(
        id: json["ID"],
        deskripsi: json["DESKRIPSI"],
        status: json["STATUS"],
      );
}
