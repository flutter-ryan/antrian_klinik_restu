import 'dart:async';

import 'package:antrian_online_restu/src/model/antrian_petugas_model.dart';
import 'package:antrian_online_restu/src/repositories/antrian_petugas_repo.dart';
import 'package:antrian_online_restu/src/repositories/response/api_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AntrianPetugasBloc {
  AntrianPetugasRepo _repo = AntrianPetugasRepo();
  StreamController<ApiResponse<ResponseAntrianPetugasModel>>?
      _streamAntrianPetugas;

  StreamSink<ApiResponse<ResponseAntrianPetugasModel>> get antrianPetugasSink =>
      _streamAntrianPetugas!.sink;
  Stream<ApiResponse<ResponseAntrianPetugasModel>> get antrianPetugasStream =>
      _streamAntrianPetugas!.stream;

  getAntrianPetugas() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? pos = _prefs.getString('pos');
    AntrianPetugasModel antrianPetugasModel = AntrianPetugasModel(pos: pos!);
    submit(antrianPetugasModel);
  }

  submit(AntrianPetugasModel antrianPetugasModel) async {
    antrianPetugasSink.add(ApiResponse.loading("Memuat"));
    try {
      final res = await _repo.getAntrianPetugas(antrianPetugasModel);
      if (_streamAntrianPetugas!.isClosed) return;
      antrianPetugasSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamAntrianPetugas!.isClosed) return;
      antrianPetugasSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamAntrianPetugas?.close();
  }
}
