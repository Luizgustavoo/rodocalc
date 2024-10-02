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

  static int getUserTypeId() {
    if (existUser()) {
      return _box.read('auth')['user']['usertype_id'];
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

  static List<String?> rotasPermitidas(){
    List<String?> list = [];
    if (existUser()) {
      Map<String, dynamic> authJson = _box.read('auth');
      Auth auth = Auth.fromJson(authJson);
      list = auth.rotas!.map((rota) => rota.rota).toList();
    }
      return list;
  }

  static bool isRotaPermitida(String rotaNome) {
    List<String?> rotas = rotasPermitidas();
    return rotas.contains(rotaNome);
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

      // Verifica se user, people, e foto não são nulos
      if (auth.user?.people?.foto != null) {
        return auth.user!.people!.foto!;
      }
    }
    return ""; // Retorna uma string vazia se alguma verificação falhar
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

  static String motoristaSelectedVehicle() {
    String motorista = "Sem motorista";
    Vehicle v = getVehicleStorage();
    if (!v.isEmpty()) {
      motorista = v.motorista!;
    }
    return motorista;
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
