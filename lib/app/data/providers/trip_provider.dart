import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/models/expense_trip_model.dart';
import 'package:rodocalc/app/data/models/transactions_model.dart';
import 'package:rodocalc/app/data/models/trip_model.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class TripApiClient {
  final http.Client httpClient = http.Client();

  getAll() async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      String veiculoId = ServiceStorage.idSelectedVehicle().toString();

      Uri tripUrl;
      String url = '$baseUrl/v1/trechopercorrido/$veiculoId';
      tripUrl = Uri.parse(url);
      var response = await httpClient.get(
        tripUrl,
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

  insert(Trip trip) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";
      final tripUrl = Uri.parse('$baseUrl/v1/trechopercorrido');

      var requestBody = {
        'user_id': trip.userId.toString(),
        'veiculo_id': trip.veiculoId.toString(),
        'data_hora': trip.dataHora.toString(),
        'data_hora_chegada': trip.dataHoraChegada.toString(),
        'tipo_saida_chegada': trip.tipoSaidaChegada.toString(),
        'origem': trip.origem.toString(),
        'uf_origem': trip.ufOrigem.toString(),
        'destino': trip.destino.toString(),
        'uf_destino': trip.ufDestino.toString(),
        'distancia': trip.distancia.toString(),
        'status': trip.status.toString(),
        'km': trip.km.toString(),
        'km_final': trip.kmFinal.toString(),
        'numero_viagem': trip.numeroViagem.toString(),
        'quantidade_tonelada': trip.quantidadeTonelada.toString(),
        'tipocarga_id': trip.tipoCargaId.toString(),
      };

      final response = await http.post(
        tripUrl,
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

  insertExpenseTrip(ExpenseTrip expense) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";
      final tripUrl = Uri.parse('$baseUrl/v1/trechopercorrido/despesa');

      var requestBody = {
        'data_hora': expense.dataHora.toString(),
        'trechopercorrido_id': expense.trechoPercorridoId.toString(),
        'descricao': expense.descricao.toString(),
        'valor_despesa': expense.valorDespesa.toString(),
        'status': expense.status.toString(),
        'user_id': ServiceStorage.getUserId().toString(),
        'km': expense.km.toString(),
      };

      final response = await http.post(
        tripUrl,
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

  updateExpenseTrip(ExpenseTrip expense) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";
      final tripUrl = Uri.parse(
          '$baseUrl/v1/trechopercorrido/despesa/update/${expense.id}');

      var requestBody = {
        'data_hora': expense.dataHora.toString(),
        'trechopercorrido_id': expense.trechoPercorridoId.toString(),
        'descricao': expense.descricao.toString(),
        'valor_despesa': expense.valorDespesa.toString(),
        'status': expense.status.toString(),
        'km': expense.km.toString(),
      };

      final response = await http.post(
        tripUrl,
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

  deleteExpenseTrip(ExpenseTrip expense) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var tripUrl = Uri.parse(
          '$baseUrl/v1/trechopercorrido/despesa/delete/${expense.id}');

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

  update(Trip trip) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";
      final tripUrl = Uri.parse('$baseUrl/v1/trechopercorrido/${trip.id}');

      var requestBody = {
        'user_id': trip.userId.toString(),
        'veiculo_id': trip.veiculoId.toString(),
        'data_hora': trip.dataHora.toString(),
        'data_hora_chegada': trip.dataHoraChegada.toString(),
        'tipo_saida_chegada': trip.tipoSaidaChegada.toString(),
        'origem': trip.origem.toString(),
        'uf_origem': trip.ufOrigem.toString(),
        'destino': trip.destino.toString(),
        'uf_destino': trip.ufDestino.toString(),
        'distancia': trip.distancia.toString(),
        'status': trip.status.toString(),
        'km': trip.km.toString(),
        'km_final': trip.kmFinal.toString(),
        'numero_viagem': trip.numeroViagem.toString(),
        'quantidade_tonelada': trip.quantidadeTonelada.toString(),
        'tipocarga_id': trip.tipoCargaId.toString(),
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

  delete(Trip trip) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var tripUrl = Uri.parse('$baseUrl/v1/trechopercorrido/${trip.id}');

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

  close(Trip trip) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var tripUrl = Uri.parse('$baseUrl/v1/trechopercorrido/close/${trip.id}');

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

  insertFotoTrecho(Trip trip) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var tripUrl = Uri.parse('$baseUrl/v1/trechopercorrido/fotostrecho');

      var request = http.MultipartRequest('POST', tripUrl);

      if (trip.photos != null && trip.photos!.isNotEmpty) {
        for (var foto in trip.photos!) {
          request.files
              .add(await http.MultipartFile.fromPath('fotos[]', foto.arquivo!));
        }
      }

      final requestBody = {
        "trecho_id": trip.id.toString(),
      };

      request.fields.addAll(requestBody);

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': token,
      });
      var response = await request.send();

      var responseStream = await response.stream.bytesToString();
      var httpResponse = http.Response(responseStream, response.statusCode);

      print(httpResponse.body);

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

  insertFotoTrechoTransaction(Transacoes transaction) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var transactionUrl =
          Uri.parse('$baseUrl/v1/trechopercorrido/fotostrechotransaction');

      var request = http.MultipartRequest('POST', transactionUrl);

      if (transaction.photos != null && transaction.photos!.isNotEmpty) {
        for (var foto in transaction.photos!) {
          request.files
              .add(await http.MultipartFile.fromPath('fotos[]', foto.arquivo!));
        }
      }

      final requestBody = {
        "transaction_id": transaction.id.toString(),
      };

      request.fields.addAll(requestBody);

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': token,
      });
      var response = await request.send();

      var responseStream = await response.stream.bytesToString();
      var httpResponse = http.Response(responseStream, response.statusCode);

      print(httpResponse.body);

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

  deletePhotoTrip(int id) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var tripUrl = Uri.parse('$baseUrl/v1/trechopercorrido/delete/photo/$id');

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
}
