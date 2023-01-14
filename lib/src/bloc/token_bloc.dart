import 'dart:async';

import 'package:antrian_online_restu/src/model/token_model.dart';
import 'package:antrian_online_restu/src/repositories/response/api_response.dart';
import 'package:antrian_online_restu/src/repositories/token_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenBloc {
  TokenRepo _repo = TokenRepo();
  StreamController<ApiResponse<ResponseTokenModel>>? _streamToken;

  StreamSink<ApiResponse<ResponseTokenModel>> get tokenSink =>
      _streamToken!.sink;
  Stream<ApiResponse<ResponseTokenModel>> get tokenStream =>
      _streamToken!.stream;

  getToken() {
    _streamToken = StreamController();
    final username = '8888';
    final password = 'bismillah';

    TokenModel tokenModel = TokenModel(username: username, password: password);
    fetchToken(tokenModel);
  }

  fetchToken(TokenModel tokenModel) async {
    tokenSink.add(ApiResponse.loading('Memuat Token...'));
    try {
      final res = await _repo.getToken(tokenModel);
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs.setString('token', '${res.token}');
      if (_streamToken!.isClosed) return;
      tokenSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamToken!.isClosed) return;
      tokenSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamToken?.close();
  }
}
