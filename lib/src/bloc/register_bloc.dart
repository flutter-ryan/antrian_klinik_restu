import 'dart:async';

import 'package:antrian_online_restu/src/bloc/validation/register_validation.dart';
import 'package:antrian_online_restu/src/model/register_model.dart';
import 'package:antrian_online_restu/src/repositories/register_repo.dart';
import 'package:antrian_online_restu/src/repositories/response/api_response.dart';
import 'package:rxdart/rxdart.dart';

class RegisterBloc extends Object with RegisterValidation {
  RegisterRepo _repo = RegisterRepo();
  StreamController<ApiResponse<ResponseRegisterModel>>? _streamRegister;

  final BehaviorSubject<String> _namaCon = BehaviorSubject<String>();
  final BehaviorSubject<String> _tempatLahirCon = BehaviorSubject<String>();
  final BehaviorSubject<String> _tanggalLahirCon = BehaviorSubject<String>();
  final BehaviorSubject<String> _agamaCon = BehaviorSubject<String>();
  final BehaviorSubject<String> _genderCon = BehaviorSubject<String>();
  final BehaviorSubject<String> _alamatCon = BehaviorSubject<String>();
  final BehaviorSubject<String> _kontakCon = BehaviorSubject<String>();
  final BehaviorSubject<String> _emailCon = BehaviorSubject<String>();
  final BehaviorSubject<String> _passwordCon = BehaviorSubject<String>();
  final BehaviorSubject<String> _ulangiPassCon = BehaviorSubject<String>();

  StreamSink<String> get namaSink => _namaCon.sink;
  StreamSink<String> get tempatLahirSink => _tempatLahirCon.sink;
  StreamSink<String> get tanggalLahirSink => _tanggalLahirCon.sink;
  StreamSink<String> get agamaSink => _agamaCon.sink;
  StreamSink<String> get genderSink => _genderCon.sink;
  StreamSink<String> get alamatSink => _alamatCon.sink;
  StreamSink<String> get kontakSink => _kontakCon.sink;
  StreamSink<String> get emailSink => _emailCon.sink;
  StreamSink<String> get passwordSink => _passwordCon.sink;
  StreamSink<String> get ulangiPassSink => _ulangiPassCon.sink;
  StreamSink<ApiResponse<ResponseRegisterModel>> get registerSink =>
      _streamRegister!.sink;
  Stream<String> get namaStream => _namaCon.stream.transform(namaValidate);
  Stream<String> get tempatLahirStream =>
      _tempatLahirCon.stream.transform(tempatLahirValidate);
  Stream<String> get tanggalLahirStream =>
      _tanggalLahirCon.stream.transform(tanggalLahirValidate);
  Stream<String> get agamaStream => _agamaCon.stream.transform(agamaValidate);
  Stream<String> get genderStream =>
      _genderCon.stream.transform(genderValidate);
  Stream<String> get alamatStream => _alamatCon.stream.transform(agamaValidate);
  Stream<String> get kontakStream =>
      _kontakCon.stream.transform(kontakValidate);
  Stream<String> get emailStream => _emailCon.stream.transform(emailValidate);
  Stream<String> get passwordStream =>
      _passwordCon.stream.transform(passwordValidate);
  Stream<String> get ulangiPassStream => _ulangiPassCon.stream
          .transform(ulangiPassValidate)
          .doOnData((String ulangiPass) {
        if (0 != _passwordCon.value.compareTo(ulangiPass)) {
          _ulangiPassCon.addError("Password tidak sama");
        }
      });
  Stream<ApiResponse<ResponseRegisterModel>> get registreStream =>
      _streamRegister!.stream;
  Stream<bool> get submitStream => Rx.combineLatest([
        namaStream,
        tempatLahirStream,
        tanggalLahirStream,
        agamaStream,
        genderStream,
        alamatStream,
        kontakStream,
        emailStream,
        passwordStream,
        ulangiPassStream
      ], (_) => true);

  register() {
    _streamRegister = StreamController();
    final nama = _namaCon.value;
    final tempatLahir = _tempatLahirCon.value;
    final tanggalLahir = _tanggalLahirCon.value;
    final agama = _agamaCon.value;
    final jk = _genderCon.value;
    final alamat = _alamatCon.value;
    final telepon = _kontakCon.value;
    final email = _emailCon.value;
    final password = _passwordCon.value;
    final ulangiPass = _ulangiPassCon.value;

    RegisterModel registerModel = RegisterModel(
      nama: nama,
      tempatlahir: tempatLahir,
      tanggallahir: tanggalLahir,
      agama: agama,
      jk: jk,
      alamat: alamat,
      telepon: telepon,
      email: email,
      password1: password,
      password2: ulangiPass,
    );

    registerNow(registerModel);
  }

  registerNow(RegisterModel registerModel) async {
    registerSink.add(ApiResponse.loading("Memuat..."));
    try {
      final res = await _repo.register(registerModel);
      if (_streamRegister!.isClosed) return;
      registerSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamRegister!.isClosed) return;
      registerSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _namaCon.close();
    _tempatLahirCon.close();
    _tanggalLahirCon.close();
    _agamaCon.close();
    _genderCon.close();
    _alamatCon.close();
    _kontakCon.close();
    _emailCon.close();
    _passwordCon.close();
    _ulangiPassCon.close();
    _streamRegister?.close();
  }
}
