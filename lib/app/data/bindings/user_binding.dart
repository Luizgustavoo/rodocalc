import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/user_controller.dart';

class UserBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserController>(() => UserController());
  }
}
