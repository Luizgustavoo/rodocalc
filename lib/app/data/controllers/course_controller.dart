import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/models/courses_model.dart';
import 'package:rodocalc/app/data/repositories/courses_repository.dart';

class CourseController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<Courses> listCourses = RxList<Courses>([]);
  RxList<Courses> filteredCourses = RxList<Courses>([]);
  final repository = Get.put(CoursesRepository());

  final searchCourseController = TextEditingController();

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };
  dynamic mensagem;

  @override
  void onClose() {
    super.onClose();
    filteredCourses.assignAll(listCourses);
  }

  Future<void> getAll() async {
    isLoading.value = true;
    try {
      searchCourseController.clear();
      listCourses.value = await repository.getAll();
      filteredCourses.assignAll(listCourses);
    } catch (e) {
      listCourses.clear();
      filteredCourses.clear();
      Exception(e);
    }
    isLoading.value = false;
  }

  void filterCourses(String query) {
    if (query.isEmpty) {
      // Se a busca estiver vazia, mostra todos os fretes
      filteredCourses.assignAll(listCourses);
    } else {
      // Filtra os fretes com base no campo "origem", "destino" ou qualquer outro
      filteredCourses.assignAll(
        listCourses
            .where((course) =>
                course.titulo!.toLowerCase().contains(query.toLowerCase()) ||
                course.descricao!.toLowerCase().contains(query.toLowerCase()))
            .toList(),
      );
    }
  }
}
