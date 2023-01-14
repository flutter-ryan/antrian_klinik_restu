import 'package:antrian_online_restu/src/model/cara_bayar_model.dart';
import 'package:antrian_online_restu/src/repositories/api_base_helper.dart';

class CaraBayarRepo {
  Future<CaraBayarModel> getCaraBayar() async {
    final response = await helper.get('/getCaraBayar');
    return caraBayarModelFromJson(response);
  }
}
