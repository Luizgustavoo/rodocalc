import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/controllers/home_controller.dart';
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

  Future<Map<String, dynamic>?> getUserTypes() async {
    var loginUrl = Uri.parse('$baseUrl/usertypes');
    try {
      var response = await httpClient.get(loginUrl, headers: {
        "Accept": "application/json",
      });

      return json.decode(response.body);
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
        "cupom_recebido": user.cupomRecebido.toString(),
        "email": user.email.toString(),
        "password": user.password.toString(),
        "endereco": people.endereco.toString(),
        "bairro": people.bairro.toString(),
        "numero_casa": people.numeroCasa.toString(),
        "cep": people.cep.toString(),
        "usertype_id": user.userTypeId.toString()
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

  Future<Map<String, dynamic>?> updateUser(People people, User user) async {
    try {
      var token = ServiceStorage.getToken();
      var companyUrl = Uri.parse('$baseUrl/v1/usuario/update/${user.id}');

      var request = http.MultipartRequest('POST', companyUrl);

      if (people.foto != null && people.foto!.isNotEmpty) {
        final file = File(people.foto!);
        if (await file.exists()) {
          request.files
              .add(await http.MultipartFile.fromPath('foto', people.foto!));
        }
      }

      if (people.nome != null && people.nome!.isNotEmpty) {
        request.fields['nome'] = people.nome!;
      }
      if (people.ddd != null && people.ddd!.isNotEmpty) {
        request.fields['ddd'] = people.ddd!;
      }
      if (people.telefone != null && people.telefone!.isNotEmpty) {
        request.fields['telefone'] = people.telefone!;
      }
      if (people.cpf != null && people.cpf!.isNotEmpty) {
        request.fields['cpf'] = people.cpf!;
      }
      if (people.apelido != null && people.apelido!.isNotEmpty) {
        request.fields['apelido'] = people.apelido!;
      }
      if (people.cidade != null && people.cidade!.isNotEmpty) {
        request.fields['cidade'] = people.cidade!;
      }
      if (people.uf != null && people.uf!.isNotEmpty) {
        request.fields['uf'] = people.uf!;
      }
      if (people.status != null && people.status!.toString().isNotEmpty) {
        request.fields['status'] = people.status!.toString();
      }
      if (people.cupomParaIndicar != null &&
          people.cupomParaIndicar!.isNotEmpty) {
        request.fields['cupom_para_indicar'] = people.cupomParaIndicar!;
      }
      if (user.email != null && user.email!.isNotEmpty) {
        request.fields['email'] = user.email!;
      }
      if (user.password != null && user.password!.isNotEmpty) {
        request.fields['password'] = user.password!;
      }

      if (people.endereco != null && people.endereco!.toString().isNotEmpty) {
        request.fields['endereco'] = people.endereco!.toString();
      }

      if (people.bairro != null && people.bairro!.toString().isNotEmpty) {
        request.fields['bairro'] = people.bairro!.toString();
      }

      if (people.numeroCasa != null &&
          people.numeroCasa!.toString().isNotEmpty) {
        request.fields['numero_casa'] = people.numeroCasa!.toString();
      }

      if (people.cep != null && people.cep!.toString().isNotEmpty) {
        request.fields['cep'] = people.cep!.toString();
      }

      request.fields['usertype_id'] = "2";

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      var response = await request.send();

      var responseStream = await response.stream.bytesToString();
      var httpResponse = http.Response(responseStream, response.statusCode);

      if (httpResponse.statusCode == 200 || httpResponse.statusCode == 201) {
        final box = GetStorage('rodocalc');
        Map<String, dynamic> responseData = json.decode(httpResponse.body);
        Map<String, dynamic> oldAuth = box.read('auth');

        Map<String, dynamic> newAuth = {};

        newAuth["user"] = responseData["user"];
        newAuth["access_token"] = responseData["access_token"];
        newAuth["token_type"] = responseData["token_type"];
        newAuth["expires_in"] = responseData["expires_in"];

        box.write('auth', newAuth);

        Get.find<HomeController>().updateUserPhoto();
      }
      return json.decode(httpResponse.body);
    } catch (err) {
      Exception('Error: $err');
      return null;
    }
  }

  forgotPassword(String username) async {
    var loginUrl = Uri.parse('$baseUrl/forgot-password');
    try {
      var response = await httpClient.post(loginUrl, headers: {
        "Accept": "application/json",
      }, body: {
        'username': username,
      });

      return json.decode(response.body);
    } catch (e) {
      Exception(e);
    }
    return null;
  }

  deleteUser() async {
    try {
      var token = ServiceStorage.getToken();
      var userUrl = Uri.parse(
          '$baseUrl/v1/usuario/destroy/${ServiceStorage.getUserId().toString()}');

      var response = await httpClient.delete(
        userUrl,
        headers: {
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
        },
      );
      return json.decode(response.body);
    } catch (e) {
      Exception(e);
    }
    return null;
  }
}
