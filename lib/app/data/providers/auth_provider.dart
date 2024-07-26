import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/models/people_model.dart';
import 'package:rodocalc/app/data/models/user_model.dart';
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
      await httpClient.post(
        loginUrl,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer ${ServiceStorage.getToken()}",
        },
      );
      ServiceStorage.clearBox();
      Get.offAllNamed('/login');
    } catch (e) {
      Exception(e);
    }
    return null;
  }

  insertUser(People people, User user) async {
    try {
      //final token = "Bearer ${ServiceStorage.getToken()}";

      var companyUrl = Uri.parse('$baseUrl/register');

      var request = http.MultipartRequest('POST', companyUrl);

      if (people.foto!.isNotEmpty) {
        request.files
            .add(await http.MultipartFile.fromPath('foto', people.foto!));
      }

      request.fields.addAll({
        "nome": people.nome.toString(),
        "ddd": people.ddd.toString(),
        "telefone": people.telefone.toString(),
        "cpf": people.cpf.toString(),
        "apelido": people.apelido.toString(),
        "cidade": people.cidade.toString(),
        "uf": people.uf.toString(),
        "status": people.status.toString(),
        "cupom_para_indicar": people.cupomParaIndicar.toString(),
        "email": user.email.toString(),
        "password": user.password.toString(),
        "usertype_id": "2"
      });

      request.headers.addAll({
        'Accept': 'application/json',
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
