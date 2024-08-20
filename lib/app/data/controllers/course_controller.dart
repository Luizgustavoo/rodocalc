import 'package:get/get.dart';
import 'package:rodocalc/app/data/models/courses_model.dart';
import 'package:rodocalc/app/data/repositories/courses_repository.dart';

class CourseController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<Courses> listCourses = RxList<Courses>([]);
  final repository = Get.put(CoursesRepository());

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };
  dynamic mensagem;

  Future<void> getAll() async {
    isLoading.value = true;
    try {
      listCourses.value = await repository.getAll();
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }
}
