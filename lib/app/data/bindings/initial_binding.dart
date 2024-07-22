import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/initial_controller.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InitialController>(() => InitialController());
  }
}
