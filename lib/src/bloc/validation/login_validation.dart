import 'dart:async';

mixin LoginValidation {
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
}
