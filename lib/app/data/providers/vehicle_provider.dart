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

      Uri companyUrl;
      String url =
          '$baseUrl/v1/vehicle/my/${ServiceStorage.getUserId().toString()}';
      companyUrl = Uri.parse(url);
      var response = await httpClient.get(
        companyUrl,
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else if (response.statusCode == 401 &&
          json.decode(response.body)['message'] == "Token has expired") {
        var resposta = {
          'success': false,
          'data': null,
          'message': ['Token expirado']
        };
        var box = GetStorage('projeto');
        box.erase();
        Get.offAllNamed('/login');
        return json.decode(resposta as String);
      }
    } catch (e) {
      Exception(e);
    }
    return null;
  }

  insert(Vehicle vehicle, File imageFile) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var vehicleUrl = Uri.parse('$baseUrl/v1/vehicle/create');

      var request = http.MultipartRequest('POST', vehicleUrl);

      request.fields.addAll({
        "pessoa_id": vehicle.pessoaId.toString(),
        "marca": vehicle.marca.toString(),
        "ano": vehicle.ano.toString(),
        "modelo": vehicle.modelo.toString(),
        "placa": vehicle.placa.toString(),
        "fipe": vehicle.fipe.toString(),
        "reboque": vehicle.reboque.toString(),
        "foto": vehicle.foto.toString(),
        "status": "1"
      });

      if (imageFile.path.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
          'foto',
          imageFile.path,
        ));
      }

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

  update(Vehicle vehicle, File imageFile) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var vehicleUrl = Uri.parse('$baseUrl/v1/vehicle/update/${vehicle.id}');

      var request = http.MultipartRequest('POST', vehicleUrl);

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

      if (imageFile.path.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
          'foto',
          imageFile.path,
        ));
      }

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
}
