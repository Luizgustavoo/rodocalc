import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/vehicle_controller.dart';

class VehiclesBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VehiclesController>(() => VehiclesController());
  }
}
