// ignore_for_file: equal_keys_in_map, unnecessary_null_comparison

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

  getExistsPlanActive() async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      Uri plansUrl;
      String url =
          '$baseUrl/v1/planousuario/planovencendo/${ServiceStorage.getUserId()}';
      plansUrl = Uri.parse(url);
      var response = await httpClient.get(
        plansUrl,
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

  getMyPlans() async {
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

  getAllPlansAlterPlanDropDown(int plano) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";

      Uri plansUrl;
      String url =
          '$baseUrl/v1/plano/myupdatevehicles/${ServiceStorage.getUserId()}/$plano';
      plansUrl = Uri.parse(url);
      var response = await httpClient.get(
        plansUrl,
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

  subscribe(UserPlan userPlan, CreditCard creditCard) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";
      final indicatorUrl = Uri.parse('$baseUrl/v1/planousuario/contratar');

      final Auth auth = ServiceStorage.getAuth();

      Map<String, String> telefoneSplit =
          Services.separarDDD(auth.user!.people!.telefone.toString());

      Map<String, String> mesAno =
          Services.mesAnoValidateCreditCart(creditCard.validate.toString());

      String enderecoCompleto =
          "${auth.user!.people!.numeroCasa}, ${auth.user!.people!.endereco}, ${auth.user!.people!.bairro}";

      String cpf = Services.limparCPF(creditCard.cpf.toString());
      String cep = Services.limparCEP(auth.user!.people!.cep.toString());

      String cidade = auth.user!.people!.cidade.toString();
      String uf = auth.user!.people!.uf.toString();

      int valor = userPlan.valorPlano!;

      var requestBody = {
        'usuario_id': userPlan.usuarioId.toString(),
        'plano_id': userPlan.planoId.toString(),
        'quantidade_licencas': userPlan.quantidadeLicencas.toString(),
        /*--------DADOS DO CARTÃO--------*/
        'number':
            Services.sanitizarCartaoCredito(creditCard.cardNumber.toString()),
        'holder_name': creditCard.cardName.toString(),
        'holder_document': cpf,
        'exp_month': mesAno['mes'],
        'exp_year': mesAno['ano'],
        'cvv': creditCard.cvv.toString(),
        'brand': creditCard.brand,
        'label': 'Rodocalc',
        'billing_address_line_1': enderecoCompleto,
        'billing_address_line_2': '',
        'billing_address_zip_code': cep,
        'billing_address_city': cidade,
        'billing_address_state': uf,
        'billing_address_country': 'BR',
        /*---------FIM DADOS DO CARTÃO-------*/
        "item_id": "123456",
        "item_description": "Item description",
        "item_amount": valor.toString(),
        "item_quantity": userPlan.quantidadeLicencas.toString(),
        "interval": "30",
        "customer_name": creditCard.cardName.toString(),
        "customer_email": auth.user!.email.toString(),
        "customer_document": cpf,
        "installments": "1",
        "billing_address_line_1": enderecoCompleto,
        "billing_address_zipcode": cep,
        "billing_address_city": cidade,
        "billing_address_state": uf,
        "billing_address_country": "BR",
        "customer_address_line_1": enderecoCompleto,
        "customer_address_zip_code": cep,
        "customer_address_city": cidade,
        "customer_address_state": uf,
        "customer_address_country": "BR",
        "customer_phone_home_country_code": "55",
        "customer_phone_home_area_code": telefoneSplit['ddd'],
        "customer_phone_home_number": telefoneSplit['numero'],
        "customer_phone_mobile_country_code": "55",
        "customer_phone_mobile_area_code": telefoneSplit['ddd'],
        "customer_phone_mobile_number": telefoneSplit['numero'],
        "plan_id": "plan_pV0yebkI72CBvZ85",
        "payment_method": "credit_card",
        "card_token": "token_RYV93LKFvFPpq6nX",
        "start_at": Services.obterDataHoraAtualISO(),
        "credit_card": {
          "installments": "1",
          "statement_descriptor": "RODOCALC",
          "billing_address": {
            "line_1": enderecoCompleto,
            "zip_code": cep,
            "city": cidade,
            "state": uf,
            "country": "BR"
          }
        },
        "metadata": {
          "id": "my_subscription_id",
          "licenses": userPlan.quantidadeLicencas.toString()
        }
      };

      final response = await http.post(
        indicatorUrl,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': token,
        },
        body: jsonEncode(requestBody),
      );

      print(response.body);
      return json.decode(response.body);
    } catch (err) {
      return null;
    }
  }

  updateSubscribe(
      UserPlan userPlan, CreditCard creditCard, String subscriptionId) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";
      final indicatorUrl =
          Uri.parse('$baseUrl/v1/planousuario/alterarassinatura');

      final Auth auth = ServiceStorage.getAuth();

      // Map<String, String> telefoneSplit =
      //     Services.separarDDD(auth.user!.people!.telefone.toString());

      String enderecoCompleto =
          "${auth.user!.people!.numeroCasa}, ${auth.user!.people!.endereco}, ${auth.user!.people!.bairro}";

      String cpf = Services.limparCPF(creditCard.cpf.toString());
      String cep = Services.limparCEP(auth.user!.people!.cep.toString());

      String cidade = auth.user!.people!.cidade.toString();
      String uf = auth.user!.people!.uf.toString();

      // int valor = userPlan.valorPlano!;

      var requestBody = {
        'subscriptionId': subscriptionId.toString(),
        'alterar_cartao': "nao",
        'alterar_licenca': "nao",
      };

      if (userPlan.assignatureId != null && userPlan.assignatureId != '') {
        requestBody["name"] = "Licença adicionada";
        requestBody["description"] = "Licença adicionada";
        requestBody["quantity"] = userPlan.quantidadeLicencas.toString();
        requestBody["price"] = userPlan.valorPlano.toString();
        requestBody['alterar_licenca'] = 'sim';
      }

      if (creditCard.cardNumber != null) {
        Map<String, String> mesAno =
            Services.mesAnoValidateCreditCart(creditCard.validate.toString());
        requestBody['number'] =
            Services.sanitizarCartaoCredito(creditCard.cardNumber.toString());
        requestBody['holder_name'] = creditCard.cardName.toString();
        requestBody['holder_document'] = cpf;
        requestBody['exp_month'] = mesAno['mes'].toString();
        requestBody['exp_year'] = mesAno['ano'].toString();
        requestBody['cvv'] = creditCard.cvv.toString();
        requestBody['brand'] = creditCard.brand.toString();
        requestBody['label'] = 'Rodocalc';
        requestBody['billing_address_line_1'] = enderecoCompleto;
        requestBody['billing_address_line_2'] = '';
        requestBody['zip_code'] = cep;
        requestBody['city'] = cidade;
        requestBody['state'] = uf;
        requestBody['country'] = 'BR';
        requestBody['alterar_cartao'] = "sim";
      }

      if (requestBody.isEmpty) {
        return null;
      }

      final response = await http.post(
        indicatorUrl,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': token,
        },
        body: jsonEncode(requestBody),
      );
      print(response.body);
      return json.decode(response.body);
    } catch (err) {
      return null;
    }
  }

  cancelSubscribe(String idSubscription) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";
      final indicatorUrl = Uri.parse('$baseUrl/v1/pagarme/cancelsignature');

      var requestBody = {
        'assignature': idSubscription.toString(),
      };

      final response = await http.post(
        indicatorUrl,
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

  updatePlanVehicle(int vehicle, int plan) async {
    try {
      final token = "Bearer ${ServiceStorage.getToken()}";
      final indicatorUrl =
          Uri.parse('$baseUrl/v1/planousuario/alterarplanoveiculo');

      var requestBody = {
        'veiculo': vehicle.toString(),
        'plano': plan.toString(),
      };

      final response = await http.post(
        indicatorUrl,
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
}
