import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/models/expense_category_model.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class ExpenseCategoryApiClient {
  final http.Client httpClient = http.Client();

  gettAll() async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      Uri companyUrl;
      String url =
          '$baseUrl/v1/expensecategory/my/${ServiceStorage.getUserId().toString()}';
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

  insert(ExpenseCategory expenseCategory) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var vehicleUrl = Uri.parse('$baseUrl/v1/expensecategory/create');

      var request = http.MultipartRequest('POST', vehicleUrl);

      request.fields.addAll({
        "descricao": expenseCategory.descricao.toString(),
        "status": expenseCategory.status.toString(),
        "user_id": expenseCategory.userId.toString(),
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

  update(ExpenseCategory expenseCategory) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var vehicleUrl =
          Uri.parse('$baseUrl/v1/expensecategory/update/${expenseCategory.id}');

      var request = http.MultipartRequest('POST', vehicleUrl);

      request.fields.addAll({
        "descricao": expenseCategory.descricao.toString(),
        "status": expenseCategory.status.toString(),
        "user_id": expenseCategory.userId.toString(),
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

  delete(ExpenseCategory expenseCategory) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var vehicleUrl =
          Uri.parse('$baseUrl/v1/expensecategory/delete/${expenseCategory.id}');

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
