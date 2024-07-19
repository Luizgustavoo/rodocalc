import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/freight_controller.dart';

class FreightBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FreightController>(() => FreightController());
  }
}
