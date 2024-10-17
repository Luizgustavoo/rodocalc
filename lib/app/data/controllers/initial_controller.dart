import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rodocalc/app/routes/app_routes.dart';

class InitialController extends GetxController {
  final box = GetStorage('rodocalc');
  dynamic auth;

  RxString codigo = ''.obs;

  @override
  void onInit() {
    auth = box.read('auth');
    super.onInit();
  }

  String verifyAuth() {
    // print('-------------valor de codigo-----------');
    // print(codigo.value);
    // print('---------------------------------------');
    if (auth != null) {
      return Routes.home;
    }
    return Routes.login;
  }
}
