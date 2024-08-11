import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/models/indication_model.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class IndicationApiClient {
  final http.Client httpClient = http.Client();

  gettAll() async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      Uri indicatorUrl;
      String url =
          '$baseUrl/v1/indicacoes/${ServiceStorage.getUserId().toString()}';
      indicatorUrl = Uri.parse(url);
      var response = await httpClient.get(
        indicatorUrl,
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

  insert(Indication indicator) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";
      final indicatorUrl = Uri.parse('$baseUrl/v1/indicacoes');

      var requestBody = {
        'pessoa_id': indicator.pessoaId.toString(),
        'nome': indicator.nome.toString(),
        'telefone': indicator.telefone.toString(),
        'codigo': indicator.codigo.toString(),
        'status': 'ativo',
      };

      final response = await http.post(
        indicatorUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': token,
        },
        body: requestBody,
      );

      if (response.statusCode == 201 ||
          response.statusCode == 422 ||
          response.statusCode == 404) {
        return json.decode(response.body);
      } else {
        // Log or handle non-successful responses
        return null;
      }
    } catch (err) {
      return null;
    }
  }

  update(Indication indicator) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";
      final indicatorUrl = Uri.parse('$baseUrl/v1/indicacoes/${indicator.id}');

      var requestBody = {
        'pessoa_id': indicator.pessoaId.toString(),
        'nome': indicator.nome.toString(),
        'telefone': indicator.telefone.toString(),
        'codigo': indicator.codigo.toString(),
        'status': '1',
      };

      final response = await http.put(
        indicatorUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': token,
        },
        body: requestBody,
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 422 ||
          response.statusCode == 404) {
        return json.decode(response.body);
      } else {
        // Log or handle non-successful responses
        return null;
      }
    } catch (err) {
      return null;
    }
  }

  delete(Indication indicator) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var indicatorUrl = Uri.parse('$baseUrl/v1/indicacoes/${indicator.id}');

      var response = await httpClient.delete(
        indicatorUrl,
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );

      return json.decode(response.body);
    } catch (err) {
      Exception(err);
    }
    return null;
  }
}
