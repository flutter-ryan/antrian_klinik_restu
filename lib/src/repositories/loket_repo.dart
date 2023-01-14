import 'package:antrian_online_restu/src/model/loket_model.dart';
import 'package:antrian_online_restu/src/repositories/api_base_helper.dart';

class LoketRepo {
  Future<LoketModel> getLoket() async {
    final response = await helper.get('/getLoket');

    return loketModelFromJson(response);
  }
}
