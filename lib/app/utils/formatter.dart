import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

  static bool validateCEP(String cep) {
    return cep.replaceAll(RegExp(r'\D'), '').length == 8;
  }

  static void onCpfChanged(
      String value, TextEditingController textEditingController) {
    textEditingController.value = textEditingController.value.copyWith(
      text: FormattedInputers.formatCpfCnpj(value),
      selection: TextSelection.collapsed(
          offset: FormattedInputers.formatCpfCnpj(value).length),
    );
  }

  static void onCPFCNPJChanged(
      String value, TextEditingController textEditingController) {
    textEditingController.value = textEditingController.value.copyWith(
      text: FormattedInputers.formatCpfCnpj2(value),
      selection: TextSelection.collapsed(
          offset: FormattedInputers.formatCpfCnpj2(value).length),
    );
  }

  static String formatCpfCnpj2(String value) {
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

  static void onDateChanged(
      String value, TextEditingController textEditingController) {
    textEditingController.value = textEditingController.value.copyWith(
      text: formatDate(value),
      selection: TextSelection.collapsed(offset: formatDate(value).length),
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

  static void onContactChanged(
      String value, TextEditingController textEditingController) {
    textEditingController.value = textEditingController.value.copyWith(
      text: formatContact(value),
      selection: TextSelection.collapsed(offset: formatContact(value).length),
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

  static void onformatValueChanged(
      String value, TextEditingController textEditingController) {
    textEditingController.value = textEditingController.value.copyWith(
      text: formatValue(value),
      selection: TextSelection.collapsed(offset: formatValue(value).length),
    );
  }

  static String getCardType(String cardNumber) {
    // Remove todos os espaços e traços do número do cartão
    String cleanedNumber = cardNumber.replaceAll(RegExp(r'\s+|-'), '');

    if (RegExp(r'^4[0-9]{0,}$').hasMatch(cleanedNumber)) {
      return 'Visa';
    } else if (RegExp(r'^5[1-5][0-9]{0,}$').hasMatch(cleanedNumber) ||
        RegExp(r'^2(2[2-9][1-9]|2[3-6][0-9]|7[0-1][0-9]|720)[0-9]{0,}$')
            .hasMatch(cleanedNumber)) {
      return 'Mastercard';
    } else if (RegExp(r'^3[47][0-9]{0,}$').hasMatch(cleanedNumber)) {
      return 'American Express';
    } else if (RegExp(r'^(6011|622[1-9]|64[4-9]|65)[0-9]{0,}$')
        .hasMatch(cleanedNumber)) {
      return 'Discover';
    } else if (RegExp(r'^(30[0-5]|36|38)[0-9]{0,}$').hasMatch(cleanedNumber)) {
      return 'Diners Club';
    } else if (RegExp(r'^(352[8-9]|35[3-8][0-9])[0-9]{0,}$')
        .hasMatch(cleanedNumber)) {
      return 'JCB';
    } else if (RegExp(
            r'^(4011|4312|4389|4514|4576|5041|5066|5090|6277|6362|6504|6550)[0-9]{0,}$')
        .hasMatch(cleanedNumber)) {
      return 'Elo';
    }

    return 'Cartão Desconhecido';
  }

  static void onformatValueChangedDecimal(
      String value, TextEditingController textEditingController) {
    textEditingController.value = textEditingController.value.copyWith(
      text: formatValueDecimal(value),
      selection:
          TextSelection.collapsed(offset: formatValueDecimal(value).length),
    );
  }

  static String formatToDecimal(String value) {
    // Remove tudo que não é dígito ou vírgula
    String cleanedValue = value.replaceAll(RegExp(r'[^\d,]'), '');

    // Se houver mais de uma vírgula, mantém apenas a primeira
    List<String> parts = cleanedValue.split(',');
    if (parts.length > 2) {
      cleanedValue = parts.sublist(0, 2).join(',');
    } else {
      cleanedValue = parts.join(',');
    }

    // Converte a parte decimal para garantir uma única casa decimal
    if (cleanedValue.contains(',')) {
      List<String> splitValue = cleanedValue.split(',');
      String integerPart = splitValue[0];
      String decimalPart = splitValue.length > 1 ? splitValue[1] : '';

      if (decimalPart.length > 1) {
        decimalPart =
            decimalPart.substring(0, 1); // Mantém apenas uma casa decimal
      }

      cleanedValue = '$integerPart,$decimalPart';
    }

    return cleanedValue;
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

  static String formatValueDecimal(String value) {
    var text = value.replaceAll(RegExp(r'[^0-9]'), '');
    var buffer = StringBuffer();
    var textLength = text.length;

    if (textLength > 1) {
      for (var i = 0; i < textLength; i++) {
        if (i == textLength - 1) {
          buffer.write(',');
        } else if (i > 0 && (textLength - i - 1) % 3 == 0) {
          buffer.write('');
        }
        buffer.write(text[i]);
      }
    } else {
      buffer.write(text);
    }

    return buffer.toString();
  }

  static RxString formatCEP(String cep) {
    final RegExp cepRegex = RegExp(r'^(\d{5})(\d{3})$');

    final matches = cepRegex.allMatches(cep);

    if (matches.isNotEmpty) {
      final match = matches.first;
      return RxString('${match[1]}-${match[2]}');
    }

    return RxString(cep);
  }

  static String formatTESTE(String value) {
    var text = value.replaceAll(RegExp(r'[^0-9]'), '');
    var textLength = text.length;

    if (textLength > 2) {
      var formattedText =
          '${text.substring(0, textLength - 2)},${text.substring(textLength - 2)}';
      return 'R\$ ${formattedText.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
    } else {
      return 'R\$ $text';
    }
  }

  static String formatValuePTBR(dynamic value) {
    if (value is String) {
      value = double.tryParse(value) ?? 0.0;
    }
    final NumberFormat formatter =
        NumberFormat.currency(symbol: '', decimalDigits: 2, locale: 'pt_BR');
    return formatter.format(value);
  }

  static String formatDoubleForDecimal(double value) {
    String formatted = value.toStringAsFixed(2).replaceAll('.', ',');

    if (formatted.endsWith(',00')) {
      return formatted.substring(0, formatted.length - 3);
    }
    if (formatted.endsWith(',0')) {
      return formatted.substring(0, formatted.length - 2);
    }

    return formatted;
  }

  static bool validatePlate(String value) {
    if (value.isEmpty) {
      return false;
    }
    final regex = RegExp(r'^[A-Z]{3}\d[A-Z\d]\d{2}$');
    if (!regex.hasMatch(value.toUpperCase())) {
      return false;
    }
    return true;
  }

  static double convertToDouble(String valorString) {
    try {
      String valorSemMoeda = valorString.replaceAll("R\$ ", "");
      valorSemMoeda = valorSemMoeda.replaceAll(".", "");
      valorSemMoeda = valorSemMoeda.replaceAll(",", ".");
      double valorDouble = double.parse(valorSemMoeda);

      return valorDouble;
    } catch (e) {
      Exception("Erro ao converter o valor: $e");
    }
    return 0;
  }

  static int convertForCents(String valorString) {
    try {
      // Remove o símbolo de moeda e os espaços
      String valorSemMoeda = valorString.replaceAll("R\$ ", "").trim();

      // Remove os pontos de separação de milhares
      valorSemMoeda = valorSemMoeda.replaceAll('.', '');

      // Substitui a vírgula por ponto para transformar em número decimal
      valorSemMoeda = valorSemMoeda.replaceAll(',', '.');

      // Converte para double e multiplica por 100 para obter os centavos
      double valorDouble = double.parse(valorSemMoeda) * 100;

      // Converte para int, que representa os centavos
      return valorDouble.round();
    } catch (e) {
      throw Exception("Erro ao converter o valor: $e");
    }
  }

  static String formatApiDate(String dateString) {
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } catch (e) {
      return 'Data inválida';
    }
  }

  static String formatApiDateHour(String dateString) {
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
    } catch (e) {
      return 'Data inválida';
    }
  }

  static bool validateDate(String value) {
    // Verifica se o valor não está vazio
    if (value.isEmpty) {
      return false;
    }

    // Verifica o formato da data no formato DD/MM/YYYY
    final regex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    if (!regex.hasMatch(value)) {
      return false;
    }

    // Verifica se a data é válida
    try {
      final parts = value.split('/');
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      // Usa DateTime.utc para evitar problemas com fusos horários
      final date = DateTime.utc(year, month, day);
      if (date.year != year || date.month != month || date.day != day) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  static void toUpperCase(String text, TextEditingController controller) {
    if (controller.text != text.toUpperCase()) {
      controller.value = controller.value.copyWith(
        text: text.toUpperCase(),
        selection: TextSelection.fromPosition(
          TextPosition(offset: text.toUpperCase().length),
        ),
      );
    }
  }

  static bool isValidCardNumber(String input) {
    int sum = 0;
    bool shouldDouble = false;

    // Itera do final para o início
    for (int i = input.length - 1; i >= 0; i--) {
      int digit = int.parse(input[i]);

      if (shouldDouble) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }

      sum += digit;
      shouldDouble = !shouldDouble;
    }

    return sum % 10 == 0;
  }

  static String formatCardExpiryDate(String value) {
    var text = value.replaceAll(RegExp(r'[^0-9]'), '');
    var buffer = StringBuffer();

    for (var i = 0; i < text.length; i++) {
      if (i == 2) {
        buffer.write('/');
      }
      buffer.write(text[i]);
    }

    return buffer.toString();
  }

  static void onCardExpiryDateChanged(
      String value, TextEditingController textEditingController) {
    final formatted = formatCardExpiryDate(value);
    textEditingController.value = textEditingController.value.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  static String? validateCardExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira a validade do cartão';
    }

    // Remove qualquer caracter não numérico
    final text = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (text.length != 4) {
      return 'Data inválida';
    }

    final month = int.tryParse(text.substring(0, 2));
    final year = int.tryParse('20${text.substring(2, 4)}');

    if (month == null || year == null) {
      return 'Data inválida';
    }

    if (month < 1 || month > 12) {
      return 'Mês inválido';
    }

    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;

    if (year < currentYear || (year == currentYear && month < currentMonth)) {
      return 'Cartão expirado';
    }

    return null;
  }

  static String formatDate2(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static DateTime parseDate(String date) {
    return DateFormat('dd/MM/yyyy').parse(date);
  }

  static String parseDateForApi(String date) {
    List<String> dateParts = date.split('/');
    if (dateParts.length == 3) {
      String day = dateParts[0];
      String month = dateParts[1];
      String year = dateParts[2];
      return '$year-$month-$day';
    } else {
      throw FormatException('Formato de data inválido. Use dd/mm/yyyy.');
    }
  }
}
