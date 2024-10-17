import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/models/classifieds_model.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class ClassifiedsApiClient {
  final http.Client httpClient = http.Client();

  getAll() async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";
      final idUser = ServiceStorage.getUserId();

      Uri classifiedsUrl;
      String url = '$baseUrl/v1/classificados/$idUser';
      classifiedsUrl = Uri.parse(url);
      var response = await httpClient.get(
        classifiedsUrl,
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

  getQuantityLicences() async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      Uri vehicleUrl;
      String url =
          '$baseUrl/v1/planousuario/postspermitidosclassificados/${ServiceStorage.getUserId().toString()}';
      vehicleUrl = Uri.parse(url);
      var response = await httpClient.get(
        vehicleUrl,
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      Exception(e);
    }
    return null;
  }

  insert(Classifieds classificados) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var vehicleUrl = Uri.parse('$baseUrl/v1/classificados');

      var request = http.MultipartRequest('POST', vehicleUrl);

      if (classificados.fotosclassificados != null &&
          classificados.fotosclassificados!.isNotEmpty) {
        for (var foto in classificados.fotosclassificados!) {
          request.files
              .add(await http.MultipartFile.fromPath('fotos[]', foto.arquivo!));
        }
      }

      request.fields.addAll({
        "descricao": classificados.descricao.toString(),
        "valor": classificados.valor.toString(),
        "status": classificados.status.toString(),
        "user_id": classificados.userId.toString()
      });

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': token,
      });

      var response = await request.send();

      var responseStream = await response.stream.bytesToString();
      var httpResponse = http.Response(responseStream, response.statusCode);

      if (httpResponse.statusCode == 201 ||
          httpResponse.statusCode == 422 ||
          httpResponse.statusCode == 404) {
        return json.decode(httpResponse.body);
      } else {
        return null;
      }
    } catch (err) {
      Exception(err);
    }
    return null;
  }

  update(Classifieds classificados, List<String> photosRemove) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var transacoesUrl =
          Uri.parse('$baseUrl/v1/classificados/update/${classificados.id}');

      var request = http.MultipartRequest('POST', transacoesUrl);

      if (classificados.fotosclassificados != null &&
          classificados.fotosclassificados!.isNotEmpty) {
        for (var foto in classificados.fotosclassificados!) {
          request.files
              .add(await http.MultipartFile.fromPath('fotos[]', foto.arquivo!));
        }
      }

      request.fields.addAll({
        "descricao": classificados.descricao.toString(),
        "valor": classificados.valor.toString(),
        "status": classificados.status.toString(),
        "user_id": classificados.userId.toString(),
        "fotos_para_excluir": photosRemove.join(','),
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

  delete(Classifieds classificados) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var expenseUrl =
          Uri.parse('$baseUrl/v1/classificados/delete/${classificados.id}');

      var request = http.MultipartRequest('POST', expenseUrl);

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
