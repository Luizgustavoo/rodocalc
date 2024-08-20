import 'package:rodocalc/app/data/models/courses_model.dart';
import 'package:rodocalc/app/data/providers/courses_provider.dart';

class CoursesRepository {
  final CoursesApiClient apiClient = CoursesApiClient();

  getAll() async {
    List<Courses> list = <Courses>[];

    var response = await apiClient.getAll();

    if (response != null) {
      response['data'].forEach((e) {
        list.add(Courses.fromJson(e));
      });
    }

    return list;
  }

  insert(Courses cursos) async {
    try {
      var response = await apiClient.insert(cursos);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  update(Courses cursos) async {
    try {
      var response = await apiClient.update(cursos);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  delete(Courses cursos) async {
    try {
      var response = await apiClient.delete(cursos);
      return response;
    } catch (e) {
      Exception(e);
    }
  }
}
