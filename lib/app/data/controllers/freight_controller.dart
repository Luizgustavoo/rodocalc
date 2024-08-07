import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/utils/formatter.dart';

class FreightController extends GetxController {
  final freightKey = GlobalKey<FormState>();

  final originController = TextEditingController();
  final destinyController = TextEditingController();
  final valueReceiveController = TextEditingController();
  final distanceController = TextEditingController();
  final averageController = TextEditingController();
  final priceController = TextEditingController();
  final totalTiresController = TextEditingController();
  final priceTiresController = TextEditingController();
  var result = ''.obs;
  void onValueChanged(String value, String controllerType) {
    String formattedValue = FormattedInputers.formatTESTE(value);

    switch (controllerType) {
      case 'valueReceive':
        valueReceiveController.value = valueReceiveController.value.copyWith(
          text: formattedValue,
          selection: TextSelection.collapsed(offset: formattedValue.length),
        );
        break;
      case 'price':
        priceController.value = priceController.value.copyWith(
          text: formattedValue,
          selection: TextSelection.collapsed(offset: formattedValue.length),
        );
        break;
      case 'priceTires':
        priceTiresController.value = priceTiresController.value.copyWith(
          text: formattedValue,
          selection: TextSelection.collapsed(offset: formattedValue.length),
        );
        break;
      default:
        throw ArgumentError('Controller passado incorreto: $controllerType');
    }
  }

  String cleanValue(String value) {
    return value.replaceAll(RegExp(r'[^0-9,]'), '').replaceAll(',', '.');
  }

  void calculateFreight() {
    final double valueReceive =
        double.parse(cleanValue(valueReceiveController.text));
    final double distance = double.parse(cleanValue(distanceController.text));
    final double average = double.parse(cleanValue(averageController.text));
    final double price = double.parse(cleanValue(priceController.text));
    final int totalTires = int.parse(totalTiresController.text);
    final double priceTires =
        double.parse(cleanValue(priceTiresController.text));

    final double dieselExpense = (distance / average) * price;
    print(dieselExpense);

    final double tireWearExpense =
        (distance / 800) * (totalTires * priceTires * 0.27 / 100);

    const double otherExpenses = 45.80;

    final double totalExpenses =
        dieselExpense + tireWearExpense + otherExpenses;

    final double profit = valueReceive - totalExpenses;

    result.value = 'Você irá lucrar R\$ ${profit.toStringAsFixed(2)}';
  }
}
