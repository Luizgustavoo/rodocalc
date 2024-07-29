import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneMask {
  static TextEditingController getMaskedTextController() {
    return TextEditingController();
  }

  static String applyMask(String input) {
    input = input.replaceAll(RegExp(r'\D'), '');

    if (input.length > 11) {
      input = input.substring(0, 11);
    }

    String masked = '';

    if (input.isNotEmpty) {
      masked += '(';
    }
    if (input.length > 2) {
      masked += '${input.substring(0, 2)}) ';
    } else if (input.isNotEmpty) {
      masked += input.substring(0);
    }
    if (input.length > 7) {
      masked += '${input.substring(2, 7)}-${input.substring(7)}';
    } else if (input.length > 2) {
      masked += input.substring(2);
    }

    return masked;
  }

  static List<TextInputFormatter> getInputFormatters() {
    return [
      FilteringTextInputFormatter.digitsOnly,
      TextInputFormatter.withFunction((oldValue, newValue) {
        String newText = applyMask(newValue.text);
        int cursorPosition = newText.length;

        if (oldValue.text.length > newValue.text.length) {
          cursorPosition = newValue.selection.start;
        }

        return newValue.copyWith(
          text: newText,
          selection: TextSelection.collapsed(offset: cursorPosition),
        );
      }),
    ];
  }
}
