import 'package:antrian_online_restu/src/model/buka_loket_model.dart';
import 'package:antrian_online_restu/src/repositories/api_base_helper.dart';

class TutupLoketRepo {
  Future<ResponseBukaLoketModel> tutupLoket(
      BukaLoketModel bukaLoketModel) async {
    final response = await helper.post(
      '/setTutupLoket',
      bukaLoketModelToJson(bukaLoketModel),
    );

    return responseBukaLoketModelFromJson(response);
  }
}
