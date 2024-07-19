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

  void onValueChanged(String value, String controllerType) {
    String formattedValue = FormattedInputers.formatValue(value);

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
}
