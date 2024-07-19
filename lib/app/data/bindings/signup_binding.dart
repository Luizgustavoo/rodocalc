import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/signup_controller.dart';

class SignUpBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpController>(() => SignUpController());
  }
}
