import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/models/auth_model.dart';
import 'package:rodocalc/app/data/models/credit_card_model.dart';
import 'package:rodocalc/app/data/models/user_plan_model.dart';
import 'package:rodocalc/app/utils/service_storage.dart';
import 'package:rodocalc/app/utils/services.dart';

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

      final Auth auth = ServiceStorage.getAuth();

      if (auth == null) {
        return {
          'success': false,
          'data': null,
          'message': 'Usuário nao encontrado na sessão ativa!'
        };
      }

      Map<String, String> telefoneSplit =
          Services.separarDDD(auth.user!.people!.telefone.toString());

      String enderecoCompleto =
          "${auth.user!.people!.numeroCasa}, ${auth.user!.people!.endereco}, ${auth.user!.people!.bairro}";

      String cep = Services.limparCEP(auth.user!.people!.cep.toString());
      String cpfStorage = Services.limparCPF(auth.user!.people!.cpf.toString());
      String cpfCredicard = Services.limparCPF(creditCard.cpf.toString());
      String dataHora = Services.obterDataHoraAtualISO();

      var billing_address = {
        "line_1": enderecoCompleto.toString(),
        "zip_code": cep.toString(),
        "city": auth.user!.people!.cidade.toString(),
        "state": auth.user!.people!.uf.toString(),
        "country": "BR"
      };

      var credit_card = {
        "installments": "1",
        "statement_descriptor": "RODOCALC",
        "billing_address": billing_address
      };

      var meta_data = {"id": "my_subscription_id"};

      var requestBody = {
        'usuario_id': userPlan.usuarioId.toString(),
        'plano_id': userPlan.planoId.toString(),
        'quantidade_licencas': userPlan.quantidadeLicencas.toString(),

        "item_id": "123456",
        "item_description": "Item description",
        "item_amount": creditCard.valor.toString(),
        // Valor em centavos, dependendo da API
        "item_quantity": "1",
        "interval": "30",
        "customer_name": creditCard.cardName.toString(),
        "customer_email": auth.user!.email.toString(),
        "customer_document": cpfCredicard.toString(),
        "installments": "1",
        "billing_address_line_1": enderecoCompleto.toString(),
        "billing_address_zipcode": cep.toString(),
        "billing_address_city": auth.user!.people!.cidade.toString(),
        "billing_address_state": auth.user!.people!.uf.toString(),
        "billing_address_country": "BR",
        "customer_address_line_1": enderecoCompleto.toString(),
        "customer_address_zip_code": cep.toString(),
        "customer_address_city": auth.user!.people!.cidade.toString(),
        "customer_address_state": auth.user!.people!.uf.toString(),
        "customer_address_country": "BR",
        "customer_phone_home_country_code": "55",
        "customer_phone_home_area_code": telefoneSplit['ddd'].toString(),
        "customer_phone_home_number": telefoneSplit['numero'].toString(),
        "customer_phone_mobile_country_code": "55",
        "customer_phone_mobile_area_code": telefoneSplit['ddd'].toString(),
        "customer_phone_mobile_number": telefoneSplit['numero'].toString(),
        "plan_id": "plan_pV0yebkI72CBvZ85",
        "payment_method": "credit_card",
        "card_token": "token_RYV93LKFvFPpq6nX",
        "start_at": dataHora.toString(),
        "credit_card": credit_card,
        "metadata": meta_data
      };

      final response = await http.post(
        indicatorUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
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
