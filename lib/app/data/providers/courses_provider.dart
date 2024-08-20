import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/models/courses_model.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class CoursesApiClient {
  final http.Client httpClient = http.Client();

  getAll() async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      Uri coursesUrl;
      String url = '$baseUrl/v1/cursos';
      coursesUrl = Uri.parse(url);
      var response = await httpClient.get(
        coursesUrl,
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else if (response.statusCode == 401 &&
          json.decode(response.body)['message'] == "Token has expired") {
        var resposta = {
          'success': false,
          'data': null,
          'message': ['Token expirado']
        };
        var box = GetStorage('projeto');
        box.erase();
        Get.offAllNamed('/login');
        return json.decode(resposta as String);
      }
    } catch (e) {
      Exception(e);
    }
    return null;
  }

  insert(Courses cursos) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var coursesUrl = Uri.parse('$baseUrl/v1/cursos');

      var request = http.MultipartRequest('POST', coursesUrl);

      request.fields.addAll({
        "descricao": cursos.descricao.toString(),
        "duracao": cursos.duracao.toString(),
        "valor": cursos.valor.toString(),
        "status": cursos.status.toString(),
      });

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': token,
      });

      var response = await request.send();

      var responseStream = await response.stream.bytesToString();
      var httpResponse = http.Response(responseStream, response.statusCode);

      return json.decode(httpResponse.body);
    } catch (err) {
      Exception(err);
    }
    return null;
  }

  update(Courses cursos) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var coursesUrl = Uri.parse('$baseUrl/v1/cursos/update/${cursos.id}');

      var request = http.MultipartRequest('POST', coursesUrl);

      request.fields.addAll({
        "descricao": cursos.descricao.toString(),
        "duracao": cursos.duracao.toString(),
        "valor": cursos.valor.toString(),
        "status": cursos.status.toString(),
      });

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': token,
      });

      var response = await request.send();

      var responseStream = await response.stream.bytesToString();
      var httpResponse = http.Response(responseStream, response.statusCode);

      return json.decode(httpResponse.body);
    } catch (err) {
      Exception(err);
    }
    return null;
  }

  delete(Courses cursos) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var coursesUrl =
          Uri.parse('$baseUrl/v1/expensecategory/delete/${cursos.id}');

      var request = http.MultipartRequest('POST', coursesUrl);

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': token,
      });

      var response = await request.send();

      var responseStream = await response.stream.bytesToString();
      var httpResponse = http.Response(responseStream, response.statusCode);

      return json.decode(httpResponse.body);
    } catch (err) {
      Exception(err);
    }
    return null;
  }
}
