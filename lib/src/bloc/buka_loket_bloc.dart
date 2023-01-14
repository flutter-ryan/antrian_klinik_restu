import 'dart:async';

import 'package:antrian_online_restu/src/model/buka_loket_model.dart';
import 'package:antrian_online_restu/src/repositories/buka_loket_repo.dart';
import 'package:antrian_online_restu/src/repositories/response/api_response.dart';
import 'package:rxdart/subjects.dart';

class BukaLoketBloc {
  BukaLoketRepo _repo = BukaLoketRepo();
  StreamController<ApiResponse<ResponseBukaLoketModel>>? _streamBukaLoket;

  final BehaviorSubject<String> _posCon = BehaviorSubject<String>();
  final BehaviorSubject<String> _loketCon = BehaviorSubject<String>();

  StreamSink<String> get posSink => _posCon.sink;
  StreamSink<String> get loketSink => _loketCon.sink;
  StreamSink<ApiResponse<ResponseBukaLoketModel>> get bukaLoketSink =>
      _streamBukaLoket!.sink;
  Stream<ApiResponse<ResponseBukaLoketModel>> get bukaLoketStream =>
      _streamBukaLoket!.stream;

  bukaLoket() {
    _streamBukaLoket = StreamController();
    final pos = _posCon.value;
    final loket = _loketCon.value;

    BukaLoketModel bukaLoketModel = BukaLoketModel(pos: pos, loket: loket);

    submit(bukaLoketModel);
  }

  submit(BukaLoketModel bukaLoketModel) async {
    bukaLoketSink.add(ApiResponse.loading("Memuat..."));
    try {
      final res = await _repo.bukaLoket(bukaLoketModel);
      if (_streamBukaLoket!.isClosed) return;
      bukaLoketSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamBukaLoket!.isClosed) return;
      bukaLoketSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamBukaLoket?.close();
    _loketCon.close();
    _posCon.close();
  }
}
