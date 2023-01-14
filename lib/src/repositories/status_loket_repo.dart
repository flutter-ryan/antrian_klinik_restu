import 'package:antrian_online_restu/src/model/status_loket_model.dart';
import 'package:antrian_online_restu/src/repositories/api_base_helper.dart';

class StatusLoketRepo {
  Future<ResponseStatusLoketModel> getStatusLoket(
      StatusLoketModel statusLoketModel) async {
    final response = await helper.post(
        '/getStatusLoket', statusLoketModelToJson(statusLoketModel));

    return responseStatusLoketModelFromJson(response);
  }
}
