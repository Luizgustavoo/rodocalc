import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/models/expense_trip_model.dart';
import 'package:rodocalc/app/data/models/transactions_model.dart';
import 'package:rodocalc/app/data/models/trip_model.dart';
import 'package:rodocalc/app/data/models/viagens_model.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class ViagensApiClient {
  final http.Client httpClient = http.Client();

  getAll() async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      String veiculoId = ServiceStorage.idSelectedVehicle().toString();
      String userId = ServiceStorage.getUserId().toString();

      Uri viagensUrl;
      String url = '$baseUrl/v1/viagens/$userId/$veiculoId';
      viagensUrl = Uri.parse(url);
      var response = await httpClient.get(
        viagensUrl,
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );

      print(response.body);

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

  insert(Viagens viagem) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";
      final viagensUrl = Uri.parse('$baseUrl/v1/viagens');

      String veiculoId = ServiceStorage.idSelectedVehicle().toString();
      String userId = ServiceStorage.getUserId().toString();

      var requestBody = {
        'motorista_id': userId,
        'veiculo_id': veiculoId,
        'titulo': viagem.titulo.toString(),
        'situacao': viagem.situacao.toString(),
        'numero_viagem': viagem.numeroViagem.toString()
      };

      final response = await http.post(
        viagensUrl,
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

  update(Viagens viagem) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";
      final tripUrl = Uri.parse('$baseUrl/v1/viagens/${viagem.id}');

      String veiculoId = ServiceStorage.idSelectedVehicle().toString();
      String userId = ServiceStorage.getUserId().toString();

      var requestBody = {
        'motorista_id': userId,
        'veiculo_id': veiculoId,
        'titulo': viagem.titulo.toString(),
        'situacao': viagem.situacao.toString(),
        'numero_viagem': viagem.numeroViagem.toString()
      };

      final response = await http.put(
        tripUrl,
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

  delete(Viagens viagem) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var tripUrl = Uri.parse('$baseUrl/v1/viagens/${viagem.id}');

      var response = await httpClient.delete(
        tripUrl,
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

  close(Viagens viagem) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var tripUrl = Uri.parse('$baseUrl/v1/viagens/close/${viagem.id}');

      var response = await httpClient.post(
        tripUrl,
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
