import 'dart:async';

mixin DaftarValidation {
  final idRuanganValidate = StreamTransformer<String, String>.fromHandlers(
      handleData: (idRuangan, sink) {
    (idRuangan.isNotEmpty)
        ? sink.add(idRuangan)
        : sink.addError('Field is required');
  });
  final idCarabayarValidate = StreamTransformer<String, String>.fromHandlers(
      handleData: (idCarabayar, sink) {
    (idCarabayar.isNotEmpty)
        ? sink.add(idCarabayar)
        : sink.addError('Field is required');
  });
  final tanggalValidate = StreamTransformer<String, String>.fromHandlers(
      handleData: (tanggal, sink) {
    (tanggal.isNotEmpty)
        ? sink.add(tanggal)
        : sink.addError('Field is required');
  });
}
