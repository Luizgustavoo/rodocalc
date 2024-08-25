import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class ComissionApiClient {
  final http.Client httpClient = http.Client();

  getAllToReceive() async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      Uri plansUrl;
      String url =
          '$baseUrl/v1/comissaoindicador/areceber/${ServiceStorage.getUserId()}';
      plansUrl = Uri.parse(url);
      var response = await httpClient.get(
        plansUrl,
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

  getExistsPedidoSaque() async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      Uri plansUrl;
      String url =
          '$baseUrl/v1/comissaoindicador/pedidosaque/${ServiceStorage.getUserId()}';
      plansUrl = Uri.parse(url);
      var response = await httpClient.get(
        plansUrl,
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

  solicitarSaque(String chavePix, String descricao) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";
      final indicatorUrl =
          Uri.parse('$baseUrl/v1/comissaoindicador/solicitarsaque');

      var requestBody = {
        'indicador_id': ServiceStorage.getUserId().toString(),
        'descricao': descricao.toString(),
        'chave_pix': chavePix.toString(),
        'status': 'aguardando_pagamento',
      };

      final response = await http.post(
        indicatorUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': token,
        },
        body: requestBody,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        // Log or handle non-successful responses
        return null;
      }
    } catch (err) {
      return null;
    }
  }
}
