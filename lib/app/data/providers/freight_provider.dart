import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/models/freight_model.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class FreightApiClient {
  final http.Client httpClient = http.Client();

  gettAll() async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      Uri freightUrl;
      String url =
          '$baseUrl/v1/calculofrete/${ServiceStorage.getUserId().toString()}';
      freightUrl = Uri.parse(url);
      var response = await httpClient.get(
        freightUrl,
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

  getTripData(
      String origem, String ufOrigem, String destino, String ufDestino) async {
    try {
      Uri freightUrl;
      String url =
          'https://rotasbrasil.com.br/apiRotas/enderecos/?pontos=$origem,$ufOrigem;$destino,$ufDestino&veiculo=caminhao&token=f613a82d2cdde0ee09b75d8b43cd1878';
      freightUrl = Uri.parse(url);
      var response = await httpClient.get(
        freightUrl,
        headers: {
          "Accept": "application/json",
        },
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      Exception(e);
    }
    return null;
  }

  insert(Freight freight) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";
      final freightUrl = Uri.parse('$baseUrl/v1/calculofrete');

      var requestBody = {
        'origem': freight.origem.toString(),
        'uf_origem': freight.ufOrigem.toString(),
        'destino': freight.destino.toString(),
        'uf_destino': freight.ufDestino.toString(),
        'valor_pedagio': freight.valorPedagio.toString(),
        'valor_recebido': freight.valorRecebido.toString(),
        'lucro': freight.lucro.toString(),
        'distancia_km': freight.distanciaKm.toString(),
        'media_km_l': freight.mediaKmL.toString(),
        'preco_combustivel': freight.precoCombustivel.toString(),
        'quantidade_pneus': freight.quantidadePneus.toString(),
        'valor_pneu': freight.valorPneu.toString(),
        'outros_gastos': freight.outrosGastos.toString(),
        'total_gastos': freight.totalGastos.toString(),
        'status': freight.status.toString(),
        'user_id': freight.userId.toString(),
      };

      final response = await http.post(
        freightUrl,
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

  update(Freight freight) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";
      final freightUrl = Uri.parse('$baseUrl/v1/calculofrete/${freight.id}');

      var requestBody = {
        'origem': freight.origem.toString(),
        'uf_origem': freight.ufOrigem.toString(),
        'destino': freight.destino.toString(),
        'uf_destino': freight.ufDestino.toString(),
        'valor_pedagio': freight.valorPedagio.toString(),
        'valor_recebido': freight.valorRecebido.toString(),
        'lucro': freight.lucro.toString(),
        'distancia_km': freight.distanciaKm.toString(),
        'media_km_l': freight.mediaKmL.toString(),
        'preco_combustivel': freight.precoCombustivel.toString(),
        'quantidade_pneus': freight.quantidadePneus.toString(),
        'valor_pneu': freight.valorPneu.toString(),
        'outros_gastos': freight.outrosGastos.toString(),
        'total_gastos': freight.totalGastos.toString(),
        'status': freight.status.toString(),
        'user_id': freight.userId.toString(),
      };

      final response = await http.put(
        freightUrl,
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

  delete(Freight freight) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      var freightUrl = Uri.parse('$baseUrl/v1/calculofrete/${freight.id}');

      var response = await httpClient.delete(
        freightUrl,
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
