import 'package:antrian_online_restu/src/model/antrian_petugas_model.dart';
import 'package:antrian_online_restu/src/repositories/api_base_helper.dart';

class AntrianPetugasRepo {
  Future<ResponseAntrianPetugasModel> getAntrianPetugas(
      AntrianPetugasModel antrianPetugasModel) async {
    final response = await helper.post(
      '/getAntrianPetugas',
      antrianPetugasModelToJson(antrianPetugasModel),
    );

    return responseAntrianPetugasModelFromJson(response);
  }
}
