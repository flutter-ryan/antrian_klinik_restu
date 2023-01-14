import 'package:antrian_online_restu/src/model/antrian_berjalan_model.dart';
import 'package:antrian_online_restu/src/repositories/api_base_helper.dart';

class AntrianBerjalanRepo {
  Future<AntrianBerjalanModel> getAntrianBerjalan() async {
    final response = await helper.get('/getAntrianBerjalan');
    return antrianBerjalanModelFromJson(response);
  }
}
