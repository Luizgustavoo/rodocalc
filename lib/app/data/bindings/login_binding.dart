import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/login_controller.dart';
import 'package:rodocalc/app/data/repositories/auth_repository.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<AuthRepository>(() => AuthRepository());
  }
}
