import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlanController extends GetxController {
  var currentPlan = 'Nenhum'.obs;
  var licenses = 1.obs;
  var selectedPlan = Rxn<Map<String, dynamic>>();
  var selectedLicenses = 1.obs;
  var calculatedPrice = ''.obs;

  final planKey = GlobalKey<FormState>();
  final cpfController = TextEditingController();
  final numberCardController = TextEditingController();
  final nameCardController = TextEditingController();
  final cvvController = TextEditingController();
  final validateController = TextEditingController();

  List<Map<String, dynamic>> plans = [
    {
      'name': 'PLANO MENSAL',
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque auctor, nibh vitae vehicula pretium, odio ligula varius urna, id tristique purus lacus ac ante. Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'price': 'R\$ 59,90',
    },
    {
      'name': 'PLANO TRIMESTRAL',
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque auctor, nibh vitae vehicula pretium, odio ligula varius urna, id tristique purus lacus ac ante. Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'price': 'R\$ 59,90',
    },
    {
      'name': 'PLANO SEMESTRAL',
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque auctor, nibh vitae vehicula pretium, odio ligula varius urna, id tristique purus lacus ac ante. Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'price': 'R\$ 59,90',
    },
  ];

  void updateSelectedPlan(Map<String, dynamic> plan) {
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
      double pricePerLicense = double.parse(selectedPlan.value!['price']
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
}
