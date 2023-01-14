import 'dart:async';

import 'package:antrian_online_restu/src/model/buka_loket_model.dart';
import 'package:antrian_online_restu/src/repositories/response/api_response.dart';
import 'package:antrian_online_restu/src/repositories/tutup_loket_repo.dart';
import 'package:rxdart/subjects.dart';

class TutupLoketBloc {
  TutupLoketRepo _repo = TutupLoketRepo();
  StreamController<ApiResponse<ResponseBukaLoketModel>>? _streamTutupLoket;

  final BehaviorSubject<String> _posCon = BehaviorSubject<String>();
  final BehaviorSubject<String> _loketCon = BehaviorSubject<String>();

  StreamSink<String> get posSink => _posCon.sink;
  StreamSink<String> get loketSink => _loketCon.sink;
  StreamSink<ApiResponse<ResponseBukaLoketModel>> get tutupLoketSink =>
      _streamTutupLoket!.sink;
  Stream<ApiResponse<ResponseBukaLoketModel>> get tutupLoketStream =>
      _streamTutupLoket!.stream;

  tutupLoket() {
    _streamTutupLoket = StreamController();
    final pos = _posCon.value;
    final loket = _loketCon.value;
    BukaLoketModel bukaLoketModel = BukaLoketModel(pos: pos, loket: loket);
    submit(bukaLoketModel);
  }

  submit(BukaLoketModel bukaLoketModel) async {
    tutupLoketSink.add(ApiResponse.loading("Memuat..."));
    try {
      final res = await _repo.tutupLoket(bukaLoketModel);
      if (_streamTutupLoket!.isClosed) return;
      tutupLoketSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTutupLoket!.isClosed) return;
      tutupLoketSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamTutupLoket?.close();
    _posCon.close();
    _loketCon.close();
  }
}
