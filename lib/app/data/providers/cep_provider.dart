import 'package:http/http.dart' as http;
import 'dart:convert';

class CepApiClient {
  Future<Map<String, dynamic>> fetchAddressByCep(String cep) async {
    final response =
        await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load address');
    }
  }
}
