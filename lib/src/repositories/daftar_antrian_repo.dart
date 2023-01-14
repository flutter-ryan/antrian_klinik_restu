import 'package:antrian_online_restu/src/model/daftar_antrian_model.dart';
import 'package:antrian_online_restu/src/repositories/api_base_helper.dart';

class DaftarAntrianRepo {
  Future<ResponseDaftarAntrianModel> daftarAntrian(
      DaftarAntrianModel daftarAntrianModel) async {
    final response = await helper.post(
      '/createAntrian',
      daftarAntrianModelToJson(daftarAntrianModel),
    );

    return responseDaftarAntrianModelFromJson(response);
  }
}
