import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/models/specific_type_expense_model.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class SpecificTypeExpenseApiClient {
  final http.Client httpClient = http.Client();

  gettAll() async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      Uri companyUrl;
      String url =
          '$baseUrl/v1/specifictypeexpense/my/${ServiceStorage.getUserId().toString()}';
      companyUrl = Uri.parse(url);
      var response = await httpClient.get(
        companyUrl,
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

  insert(SpecificTypeExpense specificTypeExpense) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var vehicleUrl = Uri.parse('$baseUrl/v1/specifictypeexpense/create');

      var request = http.MultipartRequest('POST', vehicleUrl);

      request.fields.addAll({
        "descricao": specificTypeExpense.descricao.toString(),
        "status": specificTypeExpense.status.toString(),
        "user_id": specificTypeExpense.userId.toString(),
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

  update(SpecificTypeExpense specificTypeExpense) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var vehicleUrl = Uri.parse(
          '$baseUrl/v1/specifictypeexpense/update/${specificTypeExpense.id}');

      var request = http.MultipartRequest('POST', vehicleUrl);

      request.fields.addAll({
        "descricao": specificTypeExpense.descricao.toString(),
        "status": specificTypeExpense.status.toString(),
        "user_id": specificTypeExpense.userId.toString(),
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

  delete(SpecificTypeExpense specificTypeExpense) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var vehicleUrl = Uri.parse(
          '$baseUrl/v1/specifictypeexpense/delete/${specificTypeExpense.id}');

      var request = http.MultipartRequest('POST', vehicleUrl);

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
