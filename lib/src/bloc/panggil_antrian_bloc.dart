import 'dart:async';

import 'package:antrian_online_restu/src/model/panggil_antrian_model.dart';
import 'package:antrian_online_restu/src/repositories/panggil_antrian_repo.dart';
import 'package:antrian_online_restu/src/repositories/response/api_response.dart';
import 'package:rxdart/subjects.dart';

class PanggilAntrianBloc {
  PanggilAntrianRepo _repo = PanggilAntrianRepo();
  StreamController<ApiResponse<ResponsePanggilAntrianModel>>?
      _streamPanggilAntrian;

  final BehaviorSubject<String> _nomorCon = BehaviorSubject<String>();
  final BehaviorSubject<String> _posCon = BehaviorSubject<String>();
  final BehaviorSubject<String> _loketCon = BehaviorSubject<String>();

  StreamSink<String> get nomorSink => _nomorCon.sink;
  StreamSink<String> get posSink => _posCon.sink;
  StreamSink<String> get loketSink => _loketCon.sink;
  StreamSink<ApiResponse<ResponsePanggilAntrianModel>> get panggilAntrianSink =>
      _streamPanggilAntrian!.sink;
  Stream<ApiResponse<ResponsePanggilAntrianModel>> get panggilAntrianStream =>
      _streamPanggilAntrian!.stream;

  panggilAntrian() {
    _streamPanggilAntrian = StreamController();
    final nomor = _nomorCon.value;
    final pos = _posCon.value;
    final loket = _loketCon.value;

    PanggilAntrianModel panggilAntrianModel =
        PanggilAntrianModel(pos: pos, loket: loket, nomor: nomor);

    submit(panggilAntrianModel);
  }

  submit(PanggilAntrianModel panggilAntrianModel) async {
    panggilAntrianSink.add(ApiResponse.loading("Memuat..."));
    try {
      final res = await _repo.panggilAntrian(panggilAntrianModel);
      if (_streamPanggilAntrian!.isClosed) return;
      panggilAntrianSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamPanggilAntrian!.isClosed) return;
      panggilAntrianSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamPanggilAntrian?.close();
    _nomorCon.close();
    _posCon.close();
    _loketCon.close();
  }
}
