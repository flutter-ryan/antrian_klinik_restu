CaraBayarModel caraBayarModelFromJson(dynamic str) =>
    CaraBayarModel.fromJson(str);

class CaraBayarModel {
  CaraBayarModel({
    this.success,
    this.data,
    this.total,
    this.message,
  });

  bool? success;
  List<CaraBayar>? data;
  int? total;
  String? message;

  factory CaraBayarModel.fromJson(Map<String, dynamic> json) => CaraBayarModel(
        success: json["success"],
        data: List<CaraBayar>.from(
            json["data"].map((x) => CaraBayar.fromJson(x))),
        total: json["total"],
        message: json["message"],
      );
}

class CaraBayar {
  CaraBayar({
    this.id,
    this.deskripsi,
  });

  String? id;
  String? deskripsi;

  factory CaraBayar.fromJson(Map<String, dynamic> json) => CaraBayar(
        id: json["ID"],
        deskripsi: json["DESKRIPSI"],
      );
}
