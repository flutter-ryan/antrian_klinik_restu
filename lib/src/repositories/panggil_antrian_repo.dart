import 'package:antrian_online_restu/src/model/panggil_antrian_model.dart';
import 'package:antrian_online_restu/src/repositories/api_base_helper.dart';

class PanggilAntrianRepo {
  Future<ResponsePanggilAntrianModel> panggilAntrian(
      PanggilAntrianModel panggilAntrianModel) async {
    final response = await helper.post(
      '/setPanggilAntrian',
      panggilAntrianModelToJson(panggilAntrianModel),
    );

    return responsePanggilAntrianModelFromJson(response);
  }
}
