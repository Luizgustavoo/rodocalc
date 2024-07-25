import 'package:flutter/cupertino.dart';

abstract class FormattedInputers {
  static String formatCpfCnpj(String value) {
    value = value.replaceAll(RegExp(r'\D'), '');

    if (value.length <= 11) {
      return value.replaceAllMapped(RegExp(r'(\d{3})(\d{3})(\d{3})(\d{2})'),
          (Match m) => "${m[1]}.${m[2]}.${m[3]}-${m[4]}");
    } else {
      return value.replaceAllMapped(
          RegExp(r'(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})'),
          (Match m) => "${m[1]}.${m[2]}.${m[3]}/${m[4]}-${m[5]}");
    }
  }

  static void onCpfChanged(String value, TextEditingController textEditingController) {
    textEditingController.value = textEditingController.value.copyWith(
      text: FormattedInputers.formatCpfCnpj(value),
      selection: TextSelection.collapsed(
          offset: FormattedInputers.formatCpfCnpj(value).length),
    );
  }

  static String formatContact(String value) {
    value = value.replaceAll(RegExp(r'\D'), '');

    if (value.length <= 10) {
      return value.replaceAllMapped(RegExp(r'(\d{2})(\d{4})(\d{4})'),
          (Match m) => "(${m[1]}) ${m[2]}-${m[3]}");
    } else {
      return value.replaceAllMapped(RegExp(r'(\d{2})(\d{5})(\d{4})'),
          (Match m) => "(${m[1]}) ${m[2]}-${m[3]}");
    }
  }

  static void onContactChanged(String value, TextEditingController textEditingController) {
    textEditingController.value = textEditingController.value.copyWith(
      text: formatContact(value),
      selection: TextSelection.collapsed(
          offset: formatContact(value).length),
    );
  }

  static String formatDate(String value) {
    var text = value.replaceAll(RegExp(r'[^0-9]'), '');
    var buffer = StringBuffer();
    var textIndex = 0;

    for (var i = 0; i < text.length; i++) {
      if (i == 2 || i == 4) {
        buffer.write('/');
      }
      buffer.write(text[textIndex]);
      textIndex++;
    }

    return buffer.toString();
  }

  static String formatValue(String value) {
    var text = value.replaceAll(RegExp(r'[^0-9]'), '');
    var buffer = StringBuffer();
    var textLength = text.length;

    if (textLength > 2) {
      buffer.write('R\$ ');
      for (var i = 0; i < textLength; i++) {
        if (i == textLength - 2) {
          buffer.write(',');
        } else if (i > 0 && (textLength - i - 2) % 3 == 0) {
          buffer.write('.');
        }
        buffer.write(text[i]);
      }
    } else {
      buffer.write('R\$ $text');
    }

    return buffer.toString();
  }

  static bool validatePlate(String value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    final regex = RegExp(r'^[A-Z]{3}\d[A-Z\d]\d{2}$');
    if (!regex.hasMatch(value.toUpperCase())) {
      return false;
    }
    return true;
  }
}
