import 'package:rodocalc/app/data/models/credit_card_model.dart';
import 'package:rodocalc/app/data/models/plan_model.dart';
import 'package:rodocalc/app/data/models/planos_alter_drop_down_model.dart';
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

  getExistsPlanActive() async {
    var response = await apiClient.getExistsPlanActive();
    return response["data"];
  }

  verifyPlan() async {
    return await apiClient.verifyPlan();
  }

  getMyPlans() async {
    List<UserPlan> list = <UserPlan>[];
    try {
      var response = await apiClient.getMyPlans();
      if (response != null) {
        response['data'].forEach((e) {
          list.add(UserPlan.fromJson(e));
        });
      } else {
        return null;
      }
    } catch (e) {
      Exception(e);
    }
    return list;
  }

  getAllPlansAlterPlanDropDown(int plano) async {
    List<AlterPlanDropDown> list = <AlterPlanDropDown>[];
    try {
      var response = await apiClient.getAllPlansAlterPlanDropDown(plano);
      if (response != null) {
        response['data'].forEach((e) {
          list.add(AlterPlanDropDown.fromJson(e));
        });
      } else {
        return null;
      }
    } catch (e) {
      Exception(e);
    }
    return list;
  }

  subscribe(UserPlan userplan, CreditCard creditCard, String recurrence) async {
    try {
      var response =
          await apiClient.subscribe(userplan, creditCard, recurrence);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  updateSubscribe(
      UserPlan userplan, CreditCard creditCard, String subscriptionId) async {
    try {
      var response =
          await apiClient.updateSubscribe(userplan, creditCard, subscriptionId);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  cancelSubscribe(String idSubscription) async {
    try {
      var response = await apiClient.cancelSubscribe(idSubscription);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  updatePlanVehicle(int vehicle, int plan) async {
    try {
      var response = await apiClient.updatePlanVehicle(vehicle, plan);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  createTokenCard(CreditCard creditCard) async {
    try {
      var response = await apiClient.createTokenCard(creditCard);
      return response;
    } catch (e) {
      Exception(e);
    }
  }
}
