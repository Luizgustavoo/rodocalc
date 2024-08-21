import 'package:get_storage/get_storage.dart';
import 'package:rodocalc/app/data/models/auth_model.dart';
import 'package:rodocalc/app/data/models/vehicle_model.dart';

class ServiceStorage {
  static final _box = GetStorage('rodocalc');

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
      _box.remove('rodocalc');
      _box.erase();
    }
  }

  static int getUserId() {
    if (existUser()) {
      return _box.read('auth')['user']['id'];
    }
    return 0;
  }

  static String getCodeIndicator() {
    if (_box.read('indicador') != null) {
      return _box.read('indicador');
    } else {
      return "";
    }
  }

  static Auth getAuth() {
    if (existUser()) {
      Map<String, dynamic> authJson = _box.read('auth');
      Auth auth = Auth.fromJson(authJson);
      return auth;
    }
    return Auth();
  }

  static String getUserName() {
    if (existUser()) {
      Map<String, dynamic> authJson = _box.read('auth');
      Auth auth = Auth.fromJson(authJson);
      String nomePessoa = auth.user!.people!.nome!;

      List<String> nomeParts = nomePessoa.split(' ');
      String primeiroNome = nomeParts.first;
      String ultimoNome = nomeParts.length > 1 ? nomeParts.last : '';

      return "$primeiroNome $ultimoNome";
    }
    return "";
  }

  static Auth getDataUser() {
    if (existUser()) {
      Map<String, dynamic> authJson = _box.read('auth');
      Auth auth = Auth.fromJson(authJson);
      return auth;
    } else {
      return Auth();
    }
  }

  static String getUserPhoto() {
    if (existUser()) {
      Map<String, dynamic> authJson = _box.read('auth');
      Auth auth = Auth.fromJson(authJson);
      return auth.user!.people!.foto!;
    } else {
      return "";
    }
  }

  static bool existsSelectedVehicle() {
    if (_box.read('vehicle') != null) {
      return true;
    }
    return false;
  }

  static Vehicle getVehicleStorage() {
    Vehicle vehicle = Vehicle();
    if (existsSelectedVehicle()) {
      Map<String, dynamic> vehicleJson = _box.read('vehicle');
      vehicle = Vehicle.fromJson(vehicleJson);
    }
    return vehicle;
  }

  static String titleSelectedVehicle() {
    String title = "NENHUM VEÍCULO SELECIONADO!";
    Vehicle v = getVehicleStorage();
    if (!v.isEmpty()) {
      title = "${v.marca!} - ${v.modelo!}";
    }
    return title;
  }

  static String photoSelectedVehicle() {
    String photo = "";
    Vehicle v = getVehicleStorage();
    if (!v.isEmpty()) {
      photo = v.foto!;
    }
    return photo;
  }

  static int idSelectedVehicle() {
    int id = 0;
    Vehicle v = getVehicleStorage();
    if (!v.isEmpty()) {
      id = v.id!;
    }
    return id;
  }

  static double balanceSelectedVehicle() {
    dynamic saldo = 0.0;
    Vehicle v = getVehicleStorage();
    if (!v.isEmpty() && v.saldo != null) {
      saldo = v.saldo!;
    }
    return saldo;
  }
}
