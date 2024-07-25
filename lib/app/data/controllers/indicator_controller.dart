import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/utils/formatter.dart';

class IndicatorController extends GetxController {
  final formKeyIndicator = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  void onContactChanged(String value) {
    phoneController.value = phoneController.value.copyWith(
      text: FormattedInputers.formatContact(value),
      selection: TextSelection.collapsed(
          offset: FormattedInputers.formatContact(value).length),
    );
  }
}
