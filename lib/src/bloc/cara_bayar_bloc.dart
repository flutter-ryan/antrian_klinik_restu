import 'dart:async';

import 'package:antrian_online_restu/src/model/cara_bayar_model.dart';
import 'package:antrian_online_restu/src/repositories/cara_bayar_repo.dart';
import 'package:antrian_online_restu/src/repositories/response/api_response.dart';

class CaraBayarBloc {
  CaraBayarRepo _repo = CaraBayarRepo();
  StreamController<ApiResponse<CaraBayarModel>>? _streamCaraBayar;

  StreamSink<ApiResponse<CaraBayarModel>> get caraBayarSink =>
      _streamCaraBayar!.sink;
  Stream<ApiResponse<CaraBayarModel>> get caraBayarStream =>
      _streamCaraBayar!.stream;

  getCaraBayar() async {
    _streamCaraBayar = StreamController();
    caraBayarSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getCaraBayar();
      if (_streamCaraBayar!.isClosed) return;
      caraBayarSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamCaraBayar!.isClosed) return;
      caraBayarSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamCaraBayar?.close();
  }
}
