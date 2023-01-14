import 'package:antrian_online_restu/src/model/poli_model.dart';
import 'package:antrian_online_restu/src/repositories/api_base_helper.dart';

class PoliRepo {
  Future<PoliModel> getPoli() async {
    final response = await helper.get('/getRuangan');
    return poliModelFromJson(response);
  }
}
