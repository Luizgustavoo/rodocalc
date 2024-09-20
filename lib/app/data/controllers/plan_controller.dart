import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/models/credit_card_model.dart';
import 'package:rodocalc/app/data/models/plan_model.dart';
import 'package:rodocalc/app/data/models/planos_alter_drop_down_model.dart';
import 'package:rodocalc/app/data/models/user_plan_model.dart';
import 'package:rodocalc/app/data/repositories/plan_repository.dart';
import 'package:rodocalc/app/utils/service_storage.dart';
import 'package:rodocalc/app/utils/services.dart';

class PlanController extends GetxController {
  var licenses = 1.obs;
  var selectedPlan = Rxn<Plan>();
  var selectedLicenses = 1.obs;
  RxInt addLicenses = 0.obs;
  var calculatedPrice = ''.obs;
  var selectedPlanDropDown = 0.obs;

  var shouldChangeCard = false.obs;

  var bandeiraCartao = 'NÚMERO DO CARTÃO'.obs;

  final planKey = GlobalKey<FormState>();
  final TextEditingController numberCardController = TextEditingController();
  final TextEditingController validateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController nameCardController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();

  List<CardType> cardTypes = [
    CardType(name: 'American Express', imagePath: 'assets/flags/amex.png'),
    CardType(name: 'Diner Club', imagePath: 'assets/flags/dinner.png'),
    CardType(name: 'Discover', imagePath: 'assets/flags/discover.png'),
    CardType(name: 'Elo', imagePath: 'assets/flags/elo.png'),
    CardType(name: 'Hipercard', imagePath: 'assets/flags/hipercard.png'),
    CardType(name: 'Jcb', imagePath: 'assets/flags/jcb.png'),
    CardType(name: 'Mastercard', imagePath: 'assets/flags/master.png'),
    CardType(name: 'Visa', imagePath: 'assets/flags/visa.png'),
  ];

  var selectedCardType = ''.obs;

  void updateCardType(String? newType) {
    if (newType != null) {
      selectedCardType.value = newType;
    }
  }

  RxList<Plan> listPlans = RxList<Plan>([]);
  RxList<UserPlan> myPlans = RxList<UserPlan>([]);
  RxList<AlterPlanDropDown> myPlansDropDownUpdate =
      RxList<AlterPlanDropDown>([]);

  final repository = Get.put(PlanRepository());

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };

  dynamic mensagem;
  RxBool isLoading = true.obs;
  RxBool isLoadingMyPlan = true.obs;
  RxBool isLoadingSubscrible = false.obs;
  RxBool isLoadingUpdateVehiclePlan = false.obs;

  Future<Map<String, dynamic>> subscribe() async {
    if (planKey.currentState!.validate()) {
      isLoadingSubscrible.value = true;
      mensagem = await repository.subscribe(
        UserPlan(
          usuarioId: ServiceStorage.getUserId(),
          planoId: selectedPlan.value!.id!,
          quantidadeLicencas: selectedLicenses.value,
          valorPlano: Services.converterParaCentavos(calculatedPrice.value),
        ),
        CreditCard(
          cardName: nameCardController.text,
          validate: validateController.text,
          cpf: cpfController.text,
          cvv: cvvController.text,
          cardNumber: numberCardController.text,
          valor: Services.converterParaCentavos(calculatedPrice.value),
          brand: selectedCardType.value.toString(),
        ),
      );

      isLoadingSubscrible.value = false;

      if (mensagem != null) {
        retorno = {
          'success': mensagem['success'],
          'message': mensagem['message']
        };

        getMyPlans();
      } else {
        retorno = {
          'success': false,
          'message': ['Falha ao realizar a operação!']
        };
      }
    }
    isLoadingSubscrible.value = false;
    return retorno;
  }

  Future<Map<String, dynamic>> updateSubscribe(UserPlan userplan) async {
    if (planKey.currentState!.validate()) {
      isLoadingSubscrible.value = true;

      final CreditCard creditCard = CreditCard();

      if (addLicenses.value <= 0 && !shouldChangeCard.value) {
        retorno = {
          'success': false,
          'message': [
            'Dados incorretos, nenhuma licença para adionar e nenhum cartão informado!'
          ]
        };

        isLoadingSubscrible.value = false;
        return retorno;
      }

      if (shouldChangeCard.value == true) {
        creditCard.cardName = nameCardController.text;
        creditCard.validate = validateController.text;
        creditCard.cpf = cpfController.text;
        creditCard.cvv = cvvController.text;
        creditCard.cardNumber = numberCardController.text;
        creditCard.valor =
            Services.converterParaCentavos(calculatedPrice.value);
        creditCard.brand = selectedCardType.value.toString();
      }
      UserPlan userplan = UserPlan();
      if (addLicenses.value > 0) {
        userplan.assignatureId = userplan.assignatureId;
        userplan.quantidadeLicencas = addLicenses.value;
        userplan.valorPlano =
            Services.converterParaCentavos(userplan.plano!.valor.toString());
      }

      mensagem = await repository.updateSubscribe(userplan, creditCard);

      if (mensagem != null) {
        retorno = {
          'success': mensagem['success'],
          'message': mensagem['message']
        };

        getMyPlans();
      } else {
        retorno = {
          'success': false,
          'message': ['Falha ao realizar a operação!']
        };
      }
    }
    isLoadingSubscrible.value = false;
    return retorno;
  }

  Future<Map<String, dynamic>> cancelSubscribe(String idSubscription) async {
    if (idSubscription.isNotEmpty) {
      isLoadingSubscrible.value = true;
      mensagem = await repository.cancelSubscribe(idSubscription);
      isLoadingSubscrible.value = false;

      if (mensagem != null) {
        retorno = {
          'success': mensagem['success'],
          'message': mensagem['message']
        };

        getMyPlans();
      } else {
        retorno = {
          'success': false,
          'message': ['Falha ao realizar a operação!']
        };
      }
    }
    isLoadingSubscrible.value = false;
    return retorno;
  }

  Future<Map<String, dynamic>> updatePlanVehicle(int vehicle, int plan) async {
    if (vehicle > 0 && plan > 0) {
      isLoadingUpdateVehiclePlan.value = true;
      mensagem = await repository.updatePlanVehicle(vehicle, plan);
      isLoadingUpdateVehiclePlan.value = false;

      if (mensagem != null) {
        retorno = {
          'success': mensagem['success'],
          'message': mensagem['message']
        };
      } else {
        retorno = {
          'success': false,
          'message': ['Falha ao realizar a operação!']
        };
      }
    }
    getMyPlans();
    isLoadingUpdateVehiclePlan.value = false;
    return retorno;
  }

  Future<void> getAll() async {
    isLoading.value = true;
    try {
      listPlans.value = await repository.getAll();
    } catch (e) {
      listPlans.clear();
      Exception(e);
    }
    isLoading.value = false;
  }

  Future<void> getMyPlans() async {
    isLoadingMyPlan.value = true;
    try {
      myPlans.value = await repository.getMyPlans();
    } catch (e) {
      Exception(e);
    }
    isLoadingMyPlan.value = false;
  }

  Future<void> getAllPlansAlterPlanDropDown(int plano) async {
    isLoadingMyPlan.value = true;
    try {
      myPlansDropDownUpdate.value =
          await repository.getAllPlansAlterPlanDropDown(plano);
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

  //**TESTE DE INCREMENTAR VALOR */

  final double licensePrice = 59.90; // Valor de cada licença (exemplo)

  // Método para calcular o valor total
  void calculateTotalPrice() {
    calculatedPrice.value =
        (addLicenses.value * licensePrice).toStringAsFixed(2);
  }

  // Método para incrementar licenças
  void incrementLicenses() {
    addLicenses.value++;
    calculateTotalPrice();
  }

  // Método para decrementar licenças
  void decrementLicenses() {
    if (selectedLicenses.value > 0) {
      addLicenses.value--;
      if (addLicenses.value < 0) {
        addLicenses.value = 0;
      }
      calculateTotalPrice();
    }
  }

  //** */

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
    selectedPlan.value = null;
    selectedCardType = ''.obs;
    shouldChangeCard.value = false;
  }
}

class CardType {
  final String name;
  final String imagePath;

  CardType({required this.name, required this.imagePath});
}
