import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/plan_controller.dart';

class PlanBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlanController>(() => PlanController());
  }
}
