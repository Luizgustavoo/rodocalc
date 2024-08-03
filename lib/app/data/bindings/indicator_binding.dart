import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/indicator_controller.dart';

class IndicatorBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IndicationController>(() => IndicationController());
  }
}
