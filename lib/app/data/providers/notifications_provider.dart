import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/models/charge_type_model.dart';
import 'package:rodocalc/app/data/models/expense_category_model.dart';
import 'package:rodocalc/app/data/models/transactions_model.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class NotificationsApiClient {
  final http.Client httpClient = http.Client();

  gettAll() async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      String userId = ServiceStorage.getUserId().toString();

      Uri notificationUrl;
      String url = '$baseUrl/v1/notificacao/my/$userId';
      notificationUrl = Uri.parse(url);
      var response = await httpClient.get(
        notificationUrl,
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );

      return json.decode(response.body);
    } catch (e) {
      Exception(e);
    }
    return null;
  }

  markRead(int id) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";
      final notificationUrl = Uri.parse('$baseUrl/v1/notificacao/markread');

      var requestBody = {
        'id': id.toString(),
      };

      final response = await http.post(
        notificationUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': token,
        },
        body: requestBody,
      );

      return json.decode(response.body);
    } catch (err) {
      return null;
    }
  }
}
