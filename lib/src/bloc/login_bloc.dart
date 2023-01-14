import 'dart:async';

import 'package:antrian_online_restu/src/bloc/validation/login_validation.dart';
import 'package:antrian_online_restu/src/model/login_model.dart';
import 'package:antrian_online_restu/src/repositories/login_repo.dart';
import 'package:antrian_online_restu/src/repositories/response/api_response.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends Object with LoginValidation {
  LoginRepo _repo = LoginRepo();
  StreamController<ApiResponse<ResponseLoginModel>>? _loginStream;

  final BehaviorSubject<String> _emailCon = BehaviorSubject();
  final BehaviorSubject<String> _passwordCon = BehaviorSubject();

  StreamSink<String> get emailSink => _emailCon.sink;
  StreamSink<String> get passwordSink => _passwordCon.sink;
  StreamSink<ApiResponse<ResponseLoginModel>> get loginSink =>
      _loginStream!.sink;
  Stream<String> get emailStream => _emailCon.stream.transform(emailValidate);
  Stream<String> get passwordStream =>
      _passwordCon.stream.transform(passwordValidate);
  Stream<ApiResponse<ResponseLoginModel>> get loginStream =>
      _loginStream!.stream;

  Stream<bool> get submitStream => Rx.combineLatest2(
      emailStream, passwordStream, (emailStream, passwordStream) => true);

  login() {
    _loginStream = StreamController();
    final email = _emailCon.value;
    final password = _passwordCon.value;

    LoginModel loginModel = LoginModel(email: email, password: password);

    loginNow(loginModel);
  }

  loginNow(LoginModel loginModel) async {
    loginSink.add(ApiResponse.loading("Menunggu..."));
    try {
      final res = await _repo.login(loginModel);
      loginSink.add(ApiResponse.completed(res));
    } catch (e) {
      loginSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _emailCon.close();
    _passwordCon.close();
    _loginStream?.close();
  }
}
