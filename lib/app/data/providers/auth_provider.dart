import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class AuthApiClient {
  final http.Client httpClient = http.Client();

  Future<Map<String, dynamic>?> getLogin(String email, String password) async {
    var loginUrl = Uri.parse('$baseUrl/login');
    try {
      var response = await httpClient.post(loginUrl, headers: {
        "Accept": "application/json",
      }, body: {
        'email': email,
        'password': password
      });
      print(json.decode(response.body));
      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        Exception('Erro de autenticação: Usuário ou senha inválidos');
      } else {
        Exception('Erro - get:${response.body}');
      }
    } catch (e) {
      Exception(e);
    }
    return null;
  }

  Future<Map<String, dynamic>?> getLogout() async {
    var loginUrl = Uri.parse('$baseUrl/v1/logout');
    try {
      var response = await httpClient.post(
        loginUrl,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer ${ServiceStorage.getToken()}",
        },
      );
      print(json.decode(response.body));

      ServiceStorage.clearBox();
      Get.offAllNamed('/login');
    } catch (e) {
      print(e);
    }
    return null;
  }
}
