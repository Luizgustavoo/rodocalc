import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/vehicle_controller.dart';
import 'package:rodocalc/app/data/repositories/vehicle_repository.dart';

class VehiclesBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VehiclesController>(() => VehiclesController());
    Get.lazyPut<VehicleRepository>(() => VehicleRepository());
  }
}
