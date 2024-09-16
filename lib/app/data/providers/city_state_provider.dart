import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class CityStateApiClient {
  final http.Client httpClient = http.Client();

  getCities() async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      Uri freightUrl;
      String url = '$baseUrl/v1/municipio';
      freightUrl = Uri.parse(url);
      var response = await httpClient.get(
        freightUrl,
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      Exception(e);
    }
    return null;
  }
}
