import 'dart:async';

import 'package:antrian_online_restu/src/model/antrian_berjalan_model.dart';
import 'package:antrian_online_restu/src/repositories/antrian_berjalan_repo.dart';
import 'package:antrian_online_restu/src/repositories/response/api_response.dart';

class AntrianBerjalanBloc {
  AntrianBerjalanRepo _repo = AntrianBerjalanRepo();
  StreamController<ApiResponse<AntrianBerjalanModel>>? _streamAntrianBerjalan;

  StreamSink<ApiResponse<AntrianBerjalanModel>> get antrianBerjalanSink =>
      _streamAntrianBerjalan!.sink;
  Stream<ApiResponse<AntrianBerjalanModel>> get antrianBerjalanStream =>
      _streamAntrianBerjalan!.stream;

  AntrianBerjalanBloc() {
    _streamAntrianBerjalan =
        StreamController<ApiResponse<AntrianBerjalanModel>>();
  }

  getAntrianBerjalan() async {
    _streamAntrianBerjalan = StreamController();
    antrianBerjalanSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getAntrianBerjalan();
      if (_streamAntrianBerjalan!.isClosed) return;
      antrianBerjalanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamAntrianBerjalan!.isClosed) return;
      antrianBerjalanSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamAntrianBerjalan?.close();
  }
}
