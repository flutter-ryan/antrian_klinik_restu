import 'dart:async';

import 'package:antrian_online_restu/src/model/status_loket_model.dart';
import 'package:antrian_online_restu/src/repositories/response/api_response.dart';
import 'package:antrian_online_restu/src/repositories/status_loket_repo.dart';
import 'package:rxdart/subjects.dart';

class StatusLoketBloc {
  StatusLoketRepo _repo = StatusLoketRepo();
  StreamController<ApiResponse<ResponseStatusLoketModel>>? _streamStatusLoket;

  final BehaviorSubject<String> _posCon = BehaviorSubject<String>();
  final BehaviorSubject<String> _loketCon = BehaviorSubject<String>();

  StreamSink<String> get posSink => _posCon.sink;
  StreamSink<String> get loketSink => _loketCon.sink;
  StreamSink<ApiResponse<ResponseStatusLoketModel>> get statusLoketSink =>
      _streamStatusLoket!.sink;
  Stream<ApiResponse<ResponseStatusLoketModel>> get statusLoketStream =>
      _streamStatusLoket!.stream;

  getStatusLoket() {
    _streamStatusLoket = StreamController();
    final pos = _posCon.value;
    final loket = _loketCon.value;

    StatusLoketModel statusLoketModel =
        StatusLoketModel(pos: pos, loket: loket);

    submit(statusLoketModel);
  }

  submit(StatusLoketModel statusLoketModel) async {
    statusLoketSink.add(ApiResponse.loading("Memuat..."));
    try {
      final res = await _repo.getStatusLoket(statusLoketModel);
      if (_streamStatusLoket!.isClosed) return;
      statusLoketSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamStatusLoket!.isClosed) return;
      statusLoketSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamStatusLoket?.close();
    _posCon.close();
    _loketCon.close();
  }
}
