import 'dart:async';

import 'package:antrian_online_restu/src/model/poli_model.dart';
import 'package:antrian_online_restu/src/repositories/poli_repo.dart';
import 'package:antrian_online_restu/src/repositories/response/api_response.dart';

class PoliBloc {
  PoliRepo _repo = PoliRepo();
  StreamController<ApiResponse<PoliModel>>? _streamPoli;

  StreamSink<ApiResponse<PoliModel>> get poliSink => _streamPoli!.sink;
  Stream<ApiResponse<PoliModel>> get poliStream => _streamPoli!.stream;

  getPoli() async {
    _streamPoli = StreamController();
    poliSink.add(ApiResponse.loading('Please wait...'));
    try {
      final res = await _repo.getPoli();
      if (_streamPoli!.isClosed) return;
      poliSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamPoli!.isClosed) return;
      poliSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamPoli?.close();
  }
}
