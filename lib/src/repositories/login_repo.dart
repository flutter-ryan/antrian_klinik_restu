import 'package:antrian_online_restu/src/model/login_model.dart';
import 'package:antrian_online_restu/src/repositories/api_base_helper.dart';

class LoginRepo {
  Future<ResponseLoginModel> login(LoginModel loginModel) async {
    final response = await helper.post(
      '/auth',
      loginModelToJson(loginModel),
    );
    return responseLoginModelFromJson(response);
  }
}
