import 'dart:async';

import 'package:antrian_online_restu/src/model/loket_model.dart';
import 'package:antrian_online_restu/src/repositories/loket_repo.dart';
import 'package:antrian_online_restu/src/repositories/response/api_response.dart';

class LoketBloc {
  LoketRepo _repo = LoketRepo();
  StreamController<ApiResponse<LoketModel>>? _streamLoket;

  StreamSink<ApiResponse<LoketModel>> get loketSink => _streamLoket!.sink;
  Stream<ApiResponse<LoketModel>> get loketStream => _streamLoket!.stream;

  getLoket() async {
    _streamLoket = StreamController();
    loketSink.add(ApiResponse.loading("Memuat..."));
    try {
      final res = await _repo.getLoket();
      if (_streamLoket!.isClosed) return;
      loketSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamLoket!.isClosed) return;
      loketSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamLoket?.close();
  }
}
