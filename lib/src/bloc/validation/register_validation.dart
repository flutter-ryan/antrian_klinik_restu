import 'dart:async';

mixin RegisterValidation {
  final namaValidate =
      StreamTransformer<String, String>.fromHandlers(handleData: (nama, sink) {
    (nama.isNotEmpty) ? sink.add(nama) : sink.addError('Field is required');
  });
  final tempatLahirValidate = StreamTransformer<String, String>.fromHandlers(
      handleData: (tempatLahir, sink) {
    (tempatLahir.isNotEmpty)
        ? sink.add(tempatLahir)
        : sink.addError('Field is required');
  });
  final tanggalLahirValidate = StreamTransformer<String, String>.fromHandlers(
      handleData: (tanggalLahir, sink) {
    (tanggalLahir.isNotEmpty)
        ? sink.add(tanggalLahir)
        : sink.addError('Field is required');
  });
  final agamaValidate =
      StreamTransformer<String, String>.fromHandlers(handleData: (agama, sink) {
    (agama.isNotEmpty) ? sink.add(agama) : sink.addError('Field is required');
  });
  final genderValidate = StreamTransformer<String, String>.fromHandlers(
      handleData: (gender, sink) {
    (gender.isNotEmpty) ? sink.add(gender) : sink.addError('Field is required');
  });
  final alamatValidate = StreamTransformer<String, String>.fromHandlers(
      handleData: (alamat, sink) {
    (alamat.isNotEmpty) ? sink.add(alamat) : sink.addError('Field is required');
  });
  final kontakValidate = StreamTransformer<String, String>.fromHandlers(
      handleData: (kontak, sink) {
    (kontak.isNotEmpty) ? sink.add(kontak) : sink.addError('Field is required');
  });
  final emailValidate =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.isEmpty) {
      sink.addError('Field is required');
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      sink.addError('Invalid email format');
    } else {
      sink.add(email);
    }
  });
  final passwordValidate = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    (password.isNotEmpty)
        ? sink.add(password)
        : sink.addError('Field is required');
  });
  final ulangiPassValidate = StreamTransformer<String, String>.fromHandlers(
      handleData: (ulangiPass, sink) {
    if (ulangiPass.isEmpty) {
      sink.addError('Field is required');
    } else {
      sink.add(ulangiPass);
    }
  });
}
