import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/models/credit_card_model.dart';
import 'package:rodocalc/app/data/models/user_plan_model.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class PlanApiClient {
  final http.Client httpClient = http.Client();

  gettAll() async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      Uri plansUrl;
      String url = '$baseUrl/v1/plano/list';
      plansUrl = Uri.parse(url);
      var response = await httpClient.get(
        plansUrl,
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      print(json.decode(response.body));
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

  getMyplan() async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      Uri plansUrl;
      String url = '$baseUrl/v1/plano/my/${ServiceStorage.getUserId()}';
      plansUrl = Uri.parse(url);
      var response = await httpClient.get(
        plansUrl,
        headers: {
          "Accept": "application/json",
          "Authorization": token,
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

  subscribe(UserPlan userPlan, CreditCard creditCard) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";
      final indicatorUrl = Uri.parse('$baseUrl/v1/planousuario/contratar');

      var requestBody = {
        'usuario_id': userPlan.usuarioId.toString(),
        'plano_id': userPlan.planoId.toString(),
        'quantidade_licencas': userPlan.quantidadeLicencas.toString(),

        "item_id": "123456",
        "item_description": "Item description",
        "item_amount": 1000, // Valor em centavos, dependendo da API
        "item_quantity": 1,
        "interval": 30,
        "customer_name": "Tony Stark",
        "customer_email": "avengerstark@ligadajustica.com.br",
        "customer_document": "03154435026",
        "installments": 1,
        "billing_address_line_1": "7221, Avenida Dra Ruth Cardoso, Pinheiro",
        "billing_address_zipcode": "05425070",
        "billing_address_city": "São Paulo",
        "billing_address_state": "SP",
        "billing_address_country": "BR",
        "customer_address_line_1": "7221, Avenida Dra Ruth Cardoso, Pinheiro",
        "customer_address_zip_code": "05425070",
        "customer_address_city": "São Paulo",
        "customer_address_state": "SP",
        "customer_address_country": "BR",
        "customer_phone_home_country_code": "55",
        "customer_phone_home_area_code": "11",
        "customer_phone_home_number": "000000000",
        "customer_phone_mobile_country_code": "55",
        "customer_phone_mobile_area_code": "11",
        "customer_phone_mobile_number": "000000000",
        "plan_id": "plan_pV0yebkI72CBvZ85",
        "payment_method": "credit_card",
        "card_token": "token_RYV93LKFvFPpq6nX",
        "start_at": "2024-08-16T00:00:00Z",
        "credit_card": {
          "installments": 1,
          "statement_descriptor": "AVENGERS",
          "billing_address": {
            "line_1": "7221, Avenida Dra Ruth Cardoso, Pinheiro",
            "zip_code": "05425070",
            "city": "São Paulo",
            "state": "SP",
            "country": "BR"
          }
        },
        "metadata": {"id": "my_subscription_id"}
      };

      final response = await http.post(
        indicatorUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': token,
        },
        body: requestBody,
      );

      print(json.decode(response.body));
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
}
