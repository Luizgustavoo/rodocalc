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
  RxDouble licensePrice = 0.0.obs;

  var paymentMethod = ''.obs;

  var selectedRecurrence = ''.obs;
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

  void updateRecurrence(String? recurrence) {
    if (recurrence != null) {
      selectedRecurrence.value = recurrence;
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
          selectedRecurrence.value);

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

  var linkQrCode = ''.obs;
  var codeCopyPaste = ''.obs;
  var isGeneratePix = false.obs;
  var remainingTime = 15.obs;

  Future<Map<String, dynamic>> createPix() async {
    // Verificar se o formulário é válido
    if (planKey.currentState!.validate()) {
      isLoadingSubscrible.value = true;
      linkQrCode.value = '';
      codeCopyPaste.value = '';
      isGeneratePix.value = false;

      try {
        // Chamar o método do repositório para criar o Pix
        final mensagem = await repository.createPix(
          UserPlan(
            usuarioId: ServiceStorage.getUserId(),
            planoId: selectedPlan.value!.id!,
            quantidadeLicencas: selectedLicenses.value,
            valorPlano: Services.converterParaCentavos(calculatedPrice.value),
          ),
          selectedRecurrence.value,
        );

        isLoadingSubscrible.value = false;

        if (mensagem != null && mensagem['charges'] != null) {
          final lastTransaction = mensagem['charges'][0]['last_transaction'];

          // Armazenar o QR Code e a URL
          codeCopyPaste.value = lastTransaction['qr_code'] ?? '';
          linkQrCode.value = lastTransaction['qr_code_url'] ?? '';

          isGeneratePix.value = true;

          // Retornar sucesso
          return {
            'success': true,
            'message': 'Pix gerado com sucesso!',
          };
        } else {
          isGeneratePix.value = false;
          return {
            'success': false,
            'message': 'Falha ao gerar o Pix!',
          };
        }
      } catch (e) {
        // Tratar erros da chamada à API
        isGeneratePix.value = false;
        isLoadingSubscrible.value = false;
        return {
          'success': false,
          'message': 'Erro ao realizar a operação!',
        };
      }
    }

    // Caso o formulário não seja válido
    return {
      'success': false,
      'message': 'Dados inválidos!',
    };
  }

  Future<Map<String, dynamic>> createTokenCard() async {
    if (planKey.currentState!.validate()) {
      isLoadingSubscrible.value = true;
      mensagem = await repository.createTokenCard(
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

  Future<Map<String, dynamic>> updateSubscribe(UserPlan planoUsuario) async {
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
        // creditCard.valor =
        //     Services.converterParaCentavos(calculatedPrice.value);
        creditCard.brand = selectedCardType.value.toString();
      }
      UserPlan userplan = UserPlan();
      if (addLicenses.value > 0) {
        userplan.assignatureId = planoUsuario.assignatureId;
        userplan.quantidadeLicencas = addLicenses.value;
        userplan.valorPlano = planoUsuario.valorPlano;
      }

      mensagem = await repository.updateSubscribe(
          userplan, creditCard, planoUsuario.assignatureId.toString());

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

  // Valor de cada licença (exemplo)

  // Método para calcular o valor total
  void calculateTotalPrice() {
    calculatedPrice.value =
        (addLicenses.value * licensePrice.value).toStringAsFixed(2);
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

      double total = pricePerLicense * selectedLicenses.value;
      if (selectedRecurrence.value == 'ANUAL') {
        total = (total * 12) * (1 - (selectedPlan.value!.descontoAnual! / 100));
      }

      calculatedPrice.value = 'R\$ ${(total).toStringAsFixed(2)}';
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

  verifyPlan() async {
    try {
      var response = await repository.verifyPlan();
      if (response["success"] == true) {
        return {
          "success": true,
          "exists_plan": response['exists_plan'],
          "posts_plan": response['posts_plan'],
          "licenses_plan": response['licenses_plan'],
          "classifieds_registered": response['classifieds_registered'],
          "vehicles_registered": response['vehicles_registered'],
          "error": ""
        };
      }
    } catch (e) {
      Exception(e);
      return {
        "success": false,
        "exists_plan": false,
        "posts_plan": 0,
        "licenses_plan": 0,
        "classifieds_registered": 0,
        "vehicles_registered": 0,
        "error": e
      };
    }
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
    addLicenses.value = 0;
  }
}

class CardType {
  final String name;
  final String imagePath;

  CardType({required this.name, required this.imagePath});
}
