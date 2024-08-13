import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/models/plan_model.dart';
import 'package:rodocalc/app/data/models/user_plan_model.dart';
import 'package:rodocalc/app/data/repositories/plan_repository.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class PlanController extends GetxController {
  var licenses = 1.obs;
  var selectedPlan = Rxn<Plan>();
  var selectedLicenses = 1.obs;
  var calculatedPrice = ''.obs;

  final planKey = GlobalKey<FormState>();
  final cpfController = TextEditingController();
  final numberCardController = TextEditingController();
  final nameCardController = TextEditingController();
  final cvvController = TextEditingController();
  final validateController = TextEditingController();

  RxList<Plan> listPlans = RxList<Plan>([]);
  var myPlan = Rxn<UserPlan>();

  final repository = Get.put(PlanRepository());

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };

  dynamic mensagem;
  RxBool isLoading = true.obs;
  RxBool isLoadingMyPlan = true.obs;

  Future<Map<String, dynamic>> subscribe() async {
    if (planKey.currentState!.validate()) {
      mensagem = await repository.subscribe(UserPlan(
        usuarioId: ServiceStorage.getUserId(),
        planoId: selectedPlan.value!.id!,
        quantidadeLicencas: selectedLicenses.value,
      ));
      if (mensagem != null) {
        retorno = {
          'success': mensagem['success'],
          'message': mensagem['message']
        };
        getMyPlan();
      } else {
        retorno = {
          'success': false,
          'message': ['Falha ao realizar a operação!']
        };
      }
    }
    return retorno;
  }

  Future<void> getAll() async {
    isLoading.value = true;
    try {
      listPlans.value = await repository.getAll();
      print(listPlans);
    } catch (e) {
      listPlans.clear();
      Exception(e);
    }
    isLoading.value = false;
  }

  Future<void> getMyPlan() async {
    isLoadingMyPlan.value = true;
    try {
      myPlan.value = await repository.getMyplan();
      print(myPlan.value);
    } catch (e) {
      Exception(e);
    }
    isLoadingMyPlan.value = false;
  }

  void updateSelectedPlan(Plan plan) {
    selectedPlan.value = plan;
    updatePrice();
  }

  void updateLicenses(int? value) {
    if (value != null) {
      selectedLicenses.value = value;
      updatePrice();
    }
  }

  void updatePrice() {
    if (selectedPlan.value != null) {
      double pricePerLicense = double.parse(selectedPlan.value!.valor!
          .toString()
          .replaceAll('R\$ ', '')
          .replaceAll(',', '.'));
      calculatedPrice.value =
          'R\$ ${(pricePerLicense * selectedLicenses.value).toStringAsFixed(2)}';
    }
  }

  String formatCardNumber(String value) {
    // Remove tudo que não é número
    value = value.replaceAll(RegExp(r'\D'), '');
    // Formata o número do cartão
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < value.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(value[i]);
    }
    return buffer.toString();
  }

  void clearAllFields() {
    final textControllers = [
      cpfController,
      numberCardController,
      nameCardController,
      cvvController,
      validateController,
    ];

    for (final controller in textControllers) {
      controller.clear();
    }
    licenses = 1.obs;
    selectedPlan = Rxn<Plan>();
    selectedLicenses = 1.obs;
    calculatedPrice = ''.obs;
  }
}
