import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/home_controller.dart';
import 'package:rodocalc/app/data/controllers/vehicle_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<VehiclesController>(() => VehiclesController());
  }
}
