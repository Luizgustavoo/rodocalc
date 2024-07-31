import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/models/charge_type_model.dart';
import 'package:rodocalc/app/data/models/receipt_model.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class ReceiptApiClient {
  final http.Client httpClient = http.Client();

  gettAll() async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      Uri receiptUrl;
      String url =
          '$baseUrl/v1/receita/my/${ServiceStorage.getUserId().toString()}';
      receiptUrl = Uri.parse(url);
      var response = await httpClient.get(
        receiptUrl,
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

  insert(Receipt receipt) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var vehicleUrl = Uri.parse('$baseUrl/v1/receita');

      var request = http.MultipartRequest('POST', vehicleUrl);

      if (receipt.photos != null && receipt.photos!.isNotEmpty) {
        for (var foto in receipt.photos!) {
          request.files
              .add(await http.MultipartFile.fromPath('fotos[]', foto.arquivo!));
        }
      }

      request.fields.addAll({
        "descricao": receipt.descricao.toString(),
        "origem": receipt.origem.toString(),
        "destino": receipt.destino.toString(),
        "valor": receipt.valor.toString(),
        "quantidade_tonelada": receipt.quantidadeTonelada.toString(),
        "veiculo_id": receipt.veiculoId.toString(),
        "tipocarga_id": receipt.tipoCargaId.toString(),
        "data_receita": receipt.receiptDate.toString(),
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

  insertChargeType(ChargeType type) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var vehicleUrl = Uri.parse('$baseUrl/v1/tipocarga');

      var request = http.MultipartRequest('POST', vehicleUrl);

      request.fields.addAll({
        "descricao": type.descricao.toString(),
        "status": type.status.toString()
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

  getMyChargeTypes() async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      Uri categoriesUrl;
      String url =
          '$baseUrl/v1/tipocarga/my/${ServiceStorage.getUserId().toString()}';
      categoriesUrl = Uri.parse(url);
      var response = await httpClient.get(
        categoriesUrl,
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

  update(Receipt receipt) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var receiptUrl = Uri.parse('$baseUrl/v1/tipocarga/update/${receipt.id}');

      var request = http.MultipartRequest('POST', receiptUrl);

      request.fields.addAll({
        "descricao": receipt.descricao.toString(),
        "origem": receipt.origem.toString(),
        "destino": receipt.destino.toString(),
        "valor": receipt.valor.toString(),
        "quantidade_tonelada": receipt.quantidadeTonelada.toString(),
        "veiculo_id": receipt.veiculoId.toString(),
        "tipocarga_id": receipt.tipoCargaId.toString(),
        "data_receita": receipt.receiptDate.toString(),
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

  delete(Receipt receipt) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var receiptUrl = Uri.parse('$baseUrl/v1/tipocarga/delete/${receipt.id}');

      var request = http.MultipartRequest('POST', receiptUrl);

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
