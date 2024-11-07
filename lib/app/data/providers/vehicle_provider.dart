import 'dart:convert';
import 'dart:io';

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
      print(json.decode(response.body));
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
          '$baseUrl/v1/planousuario/licencasdisponiveis/${ServiceStorage.getUserId().toString()}';
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

  getAllDropDown() async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      Uri vehicleUrl;
      String url =
          '$baseUrl/v1/veiculo/mypeople/${ServiceStorage.getUserId().toString()}';
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

  getAllUserPlans() async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      Uri vehicleUrl;
      String url =
          '$baseUrl/v1/planousuario/my/${ServiceStorage.getUserId().toString()}';
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

  getAllUserPlansEdit() async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      Uri vehicleUrl;
      String url =
          '$baseUrl/v1/planousuario/my/${ServiceStorage.getUserId().toString()}';
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
        request.files
            .add(await http.MultipartFile.fromPath('foto', vehicle.foto!));
      }
      request.fields.addAll({
        "pessoa_id": vehicle.pessoaId.toString(),
        "marca": vehicle.marca.toString(),
        "ano": vehicle.ano.toString(),
        "modelo": vehicle.modelo.toString(),
        "placa": vehicle.placa.toString(),
        "fipe": vehicle.fipe.toString(),
        "valor_fipe": vehicle.valorFipe.toString(),
        "reboque": vehicle.reboque.toString(),
        "status": "1",
        "planousuario_id": vehicle.planoUsuarioId.toString(),
      });

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': token,
      });

      var response = await request.send();

      var responseStream = await response.stream.bytesToString();
      var httpResponse = http.Response(responseStream, response.statusCode);

      if (httpResponse.statusCode == 201 ||
          httpResponse.statusCode == 422 ||
          httpResponse.statusCode == 404) {
        return json.decode(httpResponse.body);
      } else {
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
        File file = File(vehicle.foto!);
        if (await file.exists()) {
          request.files
              .add(await http.MultipartFile.fromPath('foto', vehicle.foto!));
        }
      }

      request.fields.addAll({
        "pessoa_id": vehicle.pessoaId.toString(),
        "marca": vehicle.marca.toString(),
        "ano": vehicle.ano.toString(),
        "modelo": vehicle.modelo.toString(),
        "placa": vehicle.placa.toString(),
        "fipe": vehicle.fipe.toString(),
        "valor_fipe": vehicle.valorFipe.toString(),
        "reboque": vehicle.reboque.toString(),
        "user_id": ServiceStorage.getUserId().toString(),
        "status": "1",
        "planousuario_id": vehicle.planoUsuarioId.toString(),
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

      var vehicleUrl = Uri.parse('$baseUrl/v1/veiculo/${vehicle.id}');

      var response = await httpClient.delete(
        vehicleUrl,
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

  searchPlate(String plate) async {
    try {
      // final token = "Bearer ${ServiceStorage.getToken()}";

      Uri vehicleUrl;
      String url =
          'https://placas.fipeapi.com.br/placas/$plate?key=4eaee9cc36d4204e92f6e9bec62ecf94';
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
