import 'package:antrian_online_restu/src/model/register_model.dart';
import 'package:antrian_online_restu/src/repositories/api_base_helper.dart';

class RegisterRepo {
  Future<ResponseRegisterModel> register(RegisterModel registerModel) async {
    final response = await helper.post(
      '/daftarAkun',
      registerModelToJson(registerModel),
    );
    print(response);
    return responseRegisterModelFromJson(response);
  }
}
