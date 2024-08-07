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
  final priceTollsController = TextEditingController();
  final othersExpensesController = TextEditingController();

  final selectedStateOrigin = ''.obs;
  final selectedStateDestiny = ''.obs;
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
      case 'valueToll':
        othersExpensesController.value =
            othersExpensesController.value.copyWith(
          text: formattedValue,
          selection: TextSelection.collapsed(offset: formattedValue.length),
        );
        break;
      default:
        throw ArgumentError('Controller passado incorreto: $controllerType');
    }
  }

  String cleanValue(String value) {
    String cleanedValue = value.replaceAll(RegExp(r'R\$|\s'), '');
    cleanedValue = cleanedValue.replaceAll('.', '').replaceAll(',', '.');
    return cleanedValue;
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

    double tolls = double.parse(cleanValue(priceTollsController.text));

    double otherExpenses =
        double.parse(cleanValue(othersExpensesController.text));

    final double F1 = (D / M) * P;
    final double F2 = (((Pn * D) / 800) / 100) * T;

    final double totalExpenses = F1 + F2 + otherExpenses;

    final double profit = valueReceive - totalExpenses - tolls;

    print("Distancia: $D");
    print("Media km/l: $M");
    print("quantidade de pneus: $Pn");
    print("Preco dos pneus: $T");
    print("Preco litro diesel: $P");
    print("outras despesas: $otherExpenses");
    print("Pedagios: $tolls");

    print("Formula 1: ${F1}");
    print("Formula 2: ${F2}");

    print("Voce ira lucrar $profit");
  }
}
