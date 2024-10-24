import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/models/charge_type_model.dart';
import 'package:rodocalc/app/data/models/expense_category_model.dart';
import 'package:rodocalc/app/data/models/transactions_model.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class TransactionApiClient {
  final http.Client httpClient = http.Client();

  gettAll() async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      Uri companyUrl;
      String url =
          '$baseUrl/v1/transacao/${ServiceStorage.idSelectedVehicle().toString()}';
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

  getTransactionsWithFilter(
      String? dataInicial, String? dataFinal, String? descricao) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      Uri transactionUrl;
      String url = '$baseUrl/v1/transacao/filter';
      transactionUrl = Uri.parse(url);

      var body = {'veiculo_id': ServiceStorage.idSelectedVehicle().toString()};

      if (dataInicial!.isNotEmpty && dataFinal!.isNotEmpty) {
        body['data_inicial'] = dataInicial.toString();
        body['data_final'] = dataFinal.toString();
      }

      if (descricao!.isNotEmpty) {
        body['descricao'] = descricao.toString();
      }

      var response = await httpClient.post(
        transactionUrl,
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
        body: body,
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

  getLast() async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      Uri companyUrl;
      String url =
          '$baseUrl/v1/transacao/last/${ServiceStorage.idSelectedVehicle().toString()}';
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

  gettSaldo() async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      Uri companyUrl;
      String url =
          '$baseUrl/v1/transacao/saldo/${ServiceStorage.idSelectedVehicle().toString()}';
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

  insert(Transacoes transacoes) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var vehicleUrl = Uri.parse('$baseUrl/v1/transacao');

      var request = http.MultipartRequest('POST', vehicleUrl);

      if (transacoes.photos != null && transacoes.photos!.isNotEmpty) {
        for (var foto in transacoes.photos!) {
          request.files
              .add(await http.MultipartFile.fromPath('fotos[]', foto.arquivo!));
        }
      }

      String descricao = transacoes.descricao.toString();

      if ((transacoes.descricao == null || transacoes.descricao!.isEmpty)) {
        if (transacoes.tipoTransacao == 'entrada') {
          descricao = "FRETE";
        } else {
          descricao = "NÃO INFORMADA";
        }
      }

      final requestBody = {
        "descricao": descricao.toString(),
        "valor": transacoes.valor.toString(),
        "empresa": transacoes.empresa.toString(),
        "cidade": transacoes.cidade.toString(),
        "uf": transacoes.uf.toString(),
        "ddd": transacoes.ddd.toString(),
        "telefone": transacoes.telefone.toString(),
        "status": transacoes.status.toString(),
        "pessoa_id": transacoes.pessoaId.toString(),
        "veiculo_id": transacoes.veiculoId.toString(),
        "data": transacoes.data.toString(),
        "origem": transacoes.origem.toString(),
        "destino": transacoes.destino.toString(),
        "tipo_transacao": transacoes.tipoTransacao.toString(),
      };

      if (transacoes.quantidadeTonelada != null) {
        requestBody["quantidade_tonelada"] =
            transacoes.quantidadeTonelada.toString();
      }
      if (transacoes.tipoCargaId != null) {
        requestBody["tipocarga_id"] = transacoes.tipoCargaId.toString();
      }

      if (transacoes.tipoEspecificoDespesaId != null) {
        requestBody["tipoespecificodespesa_id"] =
            transacoes.tipoEspecificoDespesaId.toString();
      }

      if (transacoes.categoriaDespesaId != null) {
        requestBody["categoriadespesa_id"] =
            transacoes.categoriaDespesaId.toString();
      }

      request.fields.addAll(requestBody);

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

  insertCategory(ExpenseCategory category, String type, int categoryId) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";
      String finalRoute = "categoriadespesa";

      if (type == 'tipoespecificodespesa') {
        finalRoute = "tipoespecificodespesa";
      }

      var vehicleUrl = Uri.parse('$baseUrl/v1/$finalRoute');

      var request = http.MultipartRequest('POST', vehicleUrl);

      request.fields.addAll({
        "descricao": category.descricao.toString(),
        "status": category.status.toString(),
        "user_id": category.userId.toString(),
        "tipo": type.toString(),
        "categoria_id": categoryId.toString()
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

  insertChargeType(ChargeType charge) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var specificTypeExpenseUrl = Uri.parse('$baseUrl/v1/tipocarga/create');

      var request = http.MultipartRequest('POST', specificTypeExpenseUrl);

      request.fields.addAll({
        "descricao": charge.descricao.toString(),
        "status": charge.status.toString(),
        "user_id": ServiceStorage.getUserId().toString(),
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

  getMyCategories() async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      Uri categoriesUrl;
      String url =
          '$baseUrl/v1/categoriadespesa/my/${ServiceStorage.getUserId().toString()}';
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

  getMySpecifics(int categoriaId) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      Uri categoriesUrl;
      String url =
          '$baseUrl/v1/tipoespecificodespesa/my/${ServiceStorage.getUserId().toString()}/$categoriaId';
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

  update(Transacoes transacoes, List<String> photosRemove) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var transacoesUrl =
          Uri.parse('$baseUrl/v1/transacao/update/${transacoes.id}');

      var request = http.MultipartRequest('POST', transacoesUrl);

      if (transacoes.photos != null && transacoes.photos!.isNotEmpty) {
        for (var foto in transacoes.photos!) {
          request.files
              .add(await http.MultipartFile.fromPath('fotos[]', foto.arquivo!));
        }
      }

      String descricao = transacoes.descricao.toString();

      if ((transacoes.descricao == null || transacoes.descricao!.isEmpty)) {
        if (transacoes.tipoTransacao == 'entrada') {
          descricao = "FRETE";
        } else {
          descricao = "NÃO INFORMADA";
        }
      }

      var requestBody = {
        "descricao": descricao.toString(),
        "valor": transacoes.valor.toString(),
        "empresa": transacoes.empresa.toString(),
        "cidade": transacoes.cidade.toString(),
        "uf": transacoes.uf.toString(),
        "ddd": transacoes.ddd.toString(),
        "telefone": transacoes.telefone.toString(),
        "status": transacoes.status.toString(),
        "pessoa_id": transacoes.pessoaId.toString(),
        "veiculo_id": transacoes.veiculoId.toString(),
        "data": transacoes.data.toString(),
        "origem": transacoes.origem.toString(),
        "destino": transacoes.destino.toString(),
        "tipo_transacao": transacoes.tipoTransacao.toString(),
        "fotos_para_excluir": photosRemove.join(','),
      };

      if (transacoes.quantidadeTonelada != null) {
        requestBody["quantidade_tonelada"] =
            transacoes.quantidadeTonelada.toString();
      }
      if (transacoes.tipoCargaId != null) {
        requestBody["tipocarga_id"] = transacoes.tipoCargaId.toString();
      }

      if (transacoes.tipoEspecificoDespesaId != null) {
        requestBody["tipoespecificodespesa_id"] =
            transacoes.tipoEspecificoDespesaId.toString();
      }

      if (transacoes.categoriaDespesaId != null) {
        requestBody["categoriadespesa_id"] =
            transacoes.categoriaDespesaId.toString();
      }

      request.fields.addAll(requestBody);

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

  delete(Transacoes transacoes) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var expenseUrl =
          Uri.parse('$baseUrl/v1/transacao/delete/${transacoes.id}');

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
