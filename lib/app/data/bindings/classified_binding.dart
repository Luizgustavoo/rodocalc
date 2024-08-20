import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/classified_controller.dart';

class ClassifiedBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClassifiedController>(() => ClassifiedController());
  }
}
