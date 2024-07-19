import 'package:get_storage/get_storage.dart';

class ServiceStorage {
  static final _box = GetStorage('projeto');

  static bool existUser() {
    if (_box.read('auth') != null) {
      return true;
    }
    return false;
  }

  static String getToken() {
    if (existUser()) {
      return _box.read('auth')['access_token'];
    }
    return "";
  }

  static void clearBox() {
    if (existUser()) {
      _box.remove('auth');
      _box.remove('projeto');
      _box.erase();
    }
  }

  static int getUserId() {
    if (existUser()) {
      return _box.read('auth')['user']['id'];
    }
    return 0;
  }

  static String getUserName() {
    if (existUser()) {
      return _box.read('auth')['user']['nome'];
    }
    return "";
  }
}
