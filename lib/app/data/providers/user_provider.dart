import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/models/people_model.dart';
import 'package:rodocalc/app/data/models/user_model.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class UserApiClient {
  final http.Client httpClient = http.Client();

  getMyEmployees() async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      Uri documentUrl;
      String url =
          '$baseUrl/v1/usuario/funcionarios/${ServiceStorage.getUserId().toString()}';
      documentUrl = Uri.parse(url);
      var response = await httpClient.get(
        documentUrl,
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

  insertUser(People people, User user, int vehicleId) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var companyUrl = Uri.parse('$baseUrl/v1/usuario/register');

      var request = http.MultipartRequest('POST', companyUrl);

      if (people.foto!.isNotEmpty) {
        request.files
            .add(await http.MultipartFile.fromPath('foto', people.foto!));
      }

      request.fields.addAll({
        "chefe_id": ServiceStorage.getUserId().toString(),
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
        "veiculo_id": vehicleId.toString(),
        "usertype_id": "4"
      });

      request.headers.addAll({
        'Accept': 'application/json',
        "Authorization": token,
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

  Future<Map<String, dynamic>?> updateUser(
      People people, User user, int vehicleId) async {
    try {
      var token = ServiceStorage.getToken();
      var companyUrl =
          Uri.parse('$baseUrl/v1/usuario/updateuserfrotista/${user.id}');

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

      if (vehicleId.toString().isNotEmpty) {
        request.fields['veiculo_id'] = vehicleId.toString();
      }

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      var response = await request.send();

      var responseStream = await response.stream.bytesToString();
      var httpResponse = http.Response(responseStream, response.statusCode);

      return json.decode(httpResponse.body);
    } catch (err) {
      Exception('Error: $err');
      return null;
    }
  }

  gettAll() async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      Uri documentUrl;
      String url =
          '$baseUrl/v1/documento/${ServiceStorage.getUserId().toString()}';
      documentUrl = Uri.parse(url);
      var response = await httpClient.get(
        documentUrl,
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

  getQuantityLicences() async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      Uri vehicleUrl;
      String url =
          '$baseUrl/v1/usuario/licencasdisponiveis/${ServiceStorage.getUserId().toString()}';
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

  delete(User user) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var userUrl = Uri.parse('$baseUrl/v1/usuario/destroy/${user.id}');

      var response = await httpClient.delete(
        userUrl,
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      print(response.body);
      return json.decode(response.body);
    } catch (err) {
      Exception(err);
    }
    return null;
  }
}
