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
  final priceDieselController = TextEditingController();
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
        priceDieselController.value = priceDieselController.value.copyWith(
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

    final double D =
        double.parse(cleanValue(distanceController.text)); //distancia
    final double M =
        double.parse(cleanValue(averageController.text)); // media km/l

    final double P = double.parse(
        cleanValue(priceDieselController.text)); //preco litro diesel

    final int Pn = int.parse(totalTiresController.text); //total de pneus
    final double T =
        double.parse(cleanValue(priceTiresController.text)); // preco dos pneus

    final double dieselExpense = (D / M) * P; // gasto com diesel

    final double tireWearExpense = (Pn * D) / 800; //desgaste com pneu

    const double toolsExpenses = 45.80;

    final double totalExpenses =
        dieselExpense + tireWearExpense + toolsExpenses;

    final double profit = valueReceive - totalExpenses;

    result.value = 'Você irá lucrar R\$ ${profit.toStringAsFixed(2)}';
  }
}
