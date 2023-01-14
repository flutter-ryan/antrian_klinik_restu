import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc {
  final PublishSubject<bool>? _isSessionValid = PublishSubject<bool>();

  Stream<bool> get isSessionValid => _isSessionValid!.stream;

  void openSession(String id, String nama, String level, String pos) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString("id", id);
    _prefs.setString("nama", nama);
    _prefs.setString("level", level);
    _prefs.setString("pos", pos);

    _isSessionValid!.sink.add(true);
  }

  void restoreSession() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? id = _prefs.getString("id");
    String? nama = _prefs.getString("nama");
    if (id != null && nama != null) {
      _isSessionValid!.sink.add(true);
    } else {
      _isSessionValid!.sink.add(false);
    }
  }

  void closedSession() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    for (String key in _prefs.getKeys()) {
      if (key == 'id' || key == 'nama' || key == 'level' || key == 'pos') {
        _prefs.remove(key);
      }
    }
    _isSessionValid!.sink.add(false);
  }

  dispose() {
    _isSessionValid?.close();
  }
}

final AuthBloc authBloc = AuthBloc();
