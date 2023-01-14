import 'package:antrian_online_restu/src/model/buka_loket_model.dart';
import 'package:antrian_online_restu/src/repositories/api_base_helper.dart';

class BukaLoketRepo {
  Future<ResponseBukaLoketModel> bukaLoket(
      BukaLoketModel bukaLoketModel) async {
    final response = await helper.post(
        '/setBukaLoket', bukaLoketModelToJson(bukaLoketModel));
    return responseBukaLoketModelFromJson(response);
  }
}
