import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/models/vehicle_model.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class VehicleApiClient {
  final http.Client httpClient = http.Client();

  gettAll() async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      Uri vehicleUrl;
      String url =
          '$baseUrl/v1/veiculo/my/${ServiceStorage.getUserId().toString()}';
      vehicleUrl = Uri.parse(url);
      var response = await httpClient.get(
        vehicleUrl,
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

  insert(Vehicle vehicle) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var vehicleUrl = Uri.parse('$baseUrl/v1/veiculo');

      var request = http.MultipartRequest('POST', vehicleUrl);

      if (vehicle.foto!.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath('foto', vehicle.foto!));
      }
      request.fields.addAll({
        "pessoa_id": vehicle.pessoaId.toString(),
        "marca": vehicle.marca.toString(),
        "ano": vehicle.ano.toString(),
        "modelo": vehicle.modelo.toString(),
        "placa": vehicle.placa.toString(),
        "fipe": vehicle.fipe.toString(),
        "reboque": vehicle.reboque.toString(),
        "status": "1"
      });


      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': token,
      });

      var response = await request.send();

      var responseStream = await response.stream.bytesToString();
      var httpResponse = http.Response(responseStream, response.statusCode);

      if(httpResponse.statusCode == 201){
        return json.decode(httpResponse.body);
      }else{
        return null;
      }

    } catch (err) {
      Exception(err);
    }
    return null;
  }

  update(Vehicle vehicle) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var vehicleUrl = Uri.parse('$baseUrl/v1/veiculo/${vehicle.id}');

      var request = http.MultipartRequest('POST', vehicleUrl);

      if (vehicle.foto!.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath('foto', vehicle.foto!));
      }

      request.fields.addAll({
        "pessoa_id": vehicle.pessoaId.toString(),
        "marca": vehicle.marca.toString(),
        "ano": vehicle.ano.toString(),
        "modelo": vehicle.modelo.toString(),
        "placa": vehicle.placa.toString(),
        "fipe": vehicle.fipe.toString(),
        "reboque": vehicle.reboque.toString(),
        "foto": vehicle.foto.toString(),
        "user_id": ServiceStorage.getUserId().toString(),
        "status": "1"
      });

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': token,
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

  delete(Vehicle vehicle) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var vehicleUrl = Uri.parse('$baseUrl/v1/vehicle/delete/${vehicle.id}');

      var request = http.MultipartRequest('POST', vehicleUrl);

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': token,
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

  searchPlate(String plate) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      Uri vehicleUrl;
      String url =
          '$buscarPlacaUrl/${plate}';
      vehicleUrl = Uri.parse(url);
      var response = await httpClient.get(
        vehicleUrl,
        headers: {
          "Accept": "application/json",
        },
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      Exception(e);
    }
    return null;
  }
}
