import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/course_controller.dart';

class CourseBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CourseController>(() => CourseController());
  }
}
