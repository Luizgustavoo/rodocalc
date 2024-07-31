import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class FinancialApiClient {
  final http.Client httpClient = http.Client();

  getAll() async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";
      final vehicleId = ServiceStorage.idSelectedVehicle();

      Uri receiptUrl;
      String url = '$baseUrl/v1/fluxocaixa/$vehicleId';
      receiptUrl = Uri.parse(url);
      var response = await httpClient.get(
        receiptUrl,
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
}
