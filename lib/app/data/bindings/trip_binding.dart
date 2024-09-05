import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/trip_controller.dart';

class TripBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TripController>(() => TripController());
  }
}
