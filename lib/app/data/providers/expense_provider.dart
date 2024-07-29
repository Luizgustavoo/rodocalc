import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/models/expense_category_model.dart';
import 'package:rodocalc/app/data/models/expense_model.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class ExpenseApiClient {
  final http.Client httpClient = http.Client();

  gettAll() async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      Uri companyUrl;
      String url =
          '$baseUrl/v1/expense/my/${ServiceStorage.getUserId().toString()}';
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

  insert(Expense expense) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var vehicleUrl = Uri.parse('$baseUrl/v1/despesa');

      var request = http.MultipartRequest('POST', vehicleUrl);

      // if (expense.foto!.isNotEmpty) {
      //   request.files
      //       .add(await http.MultipartFile.fromPath('foto', expense.foto!));
      // }
      request.fields.addAll({
        "descricao": expense.descricao.toString(),
        "categoriadespesa_id": expense.categoriadespesaId.toString(),
        "tipoespecificodespesa_id": expense.tipoespecificodespesaId.toString(),
        "valor": expense.valor.toString(),
        "empresa": expense.empresa.toString(),
        "cidade": expense.cidade.toString(),
        "uf": expense.uf.toString(),
        "ddd": expense.ddd.toString(),
        "telefone": expense.telefone.toString(),
        "observacoes": expense.observacoes.toString(),
        "status": expense.status.toString(),
        "pessoa_id": expense.pessoaId.toString(),
        "veiculo_id": expense.veiculoId.toString(),
        "data_despesa": expense.expenseDate.toString()
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

  insertCategory(ExpenseCategory category) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var vehicleUrl = Uri.parse('$baseUrl/v1/categoriadespesa');

      var request = http.MultipartRequest('POST', vehicleUrl);

      request.fields.addAll({
        "descricao": category.descricao.toString(),
        "status": category.status.toString(),
        "pessoa_id": category.userId.toString()
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

  update(Expense expense) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var expenseUrl = Uri.parse('$baseUrl/v1/expense/update/${expense.id}');

      var request = http.MultipartRequest('POST', expenseUrl);

      request.fields.addAll({
        "descricao": expense.descricao.toString(),
        "categoriadespesa_id": expense.categoriadespesaId.toString(),
        "tipoespecificodespesa_id": expense.tipoespecificodespesaId.toString(),
        "valor": expense.valor.toString(),
        "empresa": expense.empresa.toString(),
        "cidade": expense.cidade.toString(),
        "uf": expense.uf.toString(),
        "ddd": expense.ddd.toString(),
        "telefone": expense.telefone.toString(),
        "observacoes": expense.observacoes.toString(),
        "status": expense.status.toString(),
        "pessoa_id": expense.pessoaId.toString(),
        "veiculo_id": expense.veiculoId.toString()
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

  delete(Expense expense) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var expenseUrl = Uri.parse('$baseUrl/v1/expense/delete/${expense.id}');

      var request = http.MultipartRequest('POST', expenseUrl);

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
