import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/viagens_controller.dart';

class ViagensBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViagensController>(() => ViagensController());
  }
}
