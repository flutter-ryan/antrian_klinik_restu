import 'package:antrian_online_restu/src/model/token_model.dart';
import 'package:antrian_online_restu/src/repositories/api_base_helper.dart';

class TokenRepo {
  Future<ResponseTokenModel> getToken(TokenModel tokenModel) async {
    final response = await helper.postToken(
      '/getToken',
      tokenModelToJson(tokenModel),
    );

    return responseTokenModelFromJson(response);
  }
}
