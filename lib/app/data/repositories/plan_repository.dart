import 'package:rodocalc/app/data/models/credit_card_model.dart';
import 'package:rodocalc/app/data/models/plan_model.dart';
import 'package:rodocalc/app/data/models/user_plan_model.dart';
import 'package:rodocalc/app/data/providers/plan_provider.dart';

class PlanRepository {
  final PlanApiClient apiClient = PlanApiClient();

  getAll() async {
    List<Plan> list = <Plan>[];

    var response = await apiClient.gettAll();

    if (response != null) {
      response['data'].forEach((e) {
        list.add(Plan.fromJson(e));
      });
    } else {
      return null;
    }
    return list;
  }

  getMyplan() async {
    var response = await apiClient.getMyplan();
    if (response != null) {
      return UserPlan.fromJson(response['data']);
    } else {
      return null;
    }
  }

  subscribe(UserPlan userplan, CreditCard creditCard) async {
    try {
      var response = await apiClient.subscribe(userplan, creditCard);
      return response;
    } catch (e) {
      Exception(e);
    }
  }
}
