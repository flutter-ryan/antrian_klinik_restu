import 'dart:async';

import 'package:antrian_online_restu/src/bloc/validation/daftar_validation.dart';
import 'package:antrian_online_restu/src/model/daftar_antrian_model.dart';
import 'package:antrian_online_restu/src/repositories/daftar_antrian_repo.dart';
import 'package:antrian_online_restu/src/repositories/response/api_response.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DaftarAntrianBloc extends Object with DaftarValidation {
  DaftarAntrianRepo _repo = DaftarAntrianRepo();
  StreamController<ApiResponse<ResponseDaftarAntrianModel>>? _streamDaftar;

  final BehaviorSubject<String> _idRuanganCon = BehaviorSubject<String>();
  final BehaviorSubject<String> _idCarabayarCon = BehaviorSubject<String>();
  final BehaviorSubject<String> _tanggalCon = BehaviorSubject<String>();

  StreamSink<String> get idRuanganSink => _idRuanganCon.sink;
  StreamSink<String> get idCarabayarSink => _idCarabayarCon.sink;
  StreamSink<String> get tanggalSink => _tanggalCon.sink;
  StreamSink<ApiResponse<ResponseDaftarAntrianModel>> get daftarSink =>
      _streamDaftar!.sink;
  Stream<String> get idRuanganStream =>
      _idRuanganCon.stream.transform(idRuanganValidate);
  Stream<String> get idCarabayarStream =>
      _idCarabayarCon.stream.transform(idCarabayarValidate);
  Stream<String> get tanggalStream =>
      _tanggalCon.stream.transform(tanggalValidate);
  Stream<ApiResponse<ResponseDaftarAntrianModel>> get daftarStream =>
      _streamDaftar!.stream;

  Stream<bool> get submitStream => Rx.combineLatest3(
        idRuanganStream,
        idCarabayarStream,
        tanggalStream,
        (idRuanganStream, idCarabayarStream, tanggalStream) => true,
      );

  daftarAntrian() async {
    _streamDaftar = StreamController();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? _idPasien = _prefs.getString('id');
    final idRuangan = _idRuanganCon.value;
    final idCarabayar = _idCarabayarCon.value;
    final tanggal = _tanggalCon.value;
    final idPasien = _idPasien;

    DaftarAntrianModel daftarAntrianModel = DaftarAntrianModel(
        pasien: idPasien!,
        carabayar: idCarabayar,
        ruangan: idRuangan,
        tanggal: tanggal);
    submit(daftarAntrianModel);
  }

  submit(DaftarAntrianModel daftarAntrianModel) async {
    daftarSink.add(ApiResponse.loading("Memuat..."));
    try {
      final res = await _repo.daftarAntrian(daftarAntrianModel);
      daftarSink.add(ApiResponse.completed(res));
    } catch (e) {
      daftarSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamDaftar?.close();
    _idCarabayarCon.close();
    _idRuanganCon.close();
    _tanggalCon.close();
  }
}
