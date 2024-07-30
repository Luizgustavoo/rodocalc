import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rodocalc/app/data/models/expense_model.dart';
import 'package:rodocalc/app/data/repositories/expense_repository.dart';
import 'package:rodocalc/app/utils/formatter.dart';

class FinancialController extends GetxController {
  var selectedImagePath = ''.obs;

  RxList<String> selectedsImagesExpense = <String>[].obs;
  RxBool setImage = false.obs;
  RxBool isLoading = true.obs;

  //CONTROLLER E KEY DO RECEBIMENTO
  final formKeyReceipt = GlobalKey<FormState>();
  final descriptionController = TextEditingController();
  final originController = TextEditingController();
  final destinyController = TextEditingController();
  final amountController = TextEditingController();
  final tonController = TextEditingController();

  var balance = 10000.0.obs;
  var transactions = <Transaction>[].obs;
  var filteredTransactions = <Transaction>[].obs;
  var searchQuery = ''.obs;

  var cargoTypes = ['Tipo 1', 'Tipo 2', 'Tipo 3', 'Tipo 4'].obs;
  var selectedCargoType = 'Tipo 1'.obs;

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };
  dynamic mensagem;

  var specificTypes =
      ['Específico 1', 'Específico 2', 'Específico 3', 'Específico 4'].obs;
  var selectedSpecificType = 'Específico 1'.obs;

  var categories =
      ['Categoria 1', 'Categoria 2', 'Categoria 3', 'Categoria 4'].obs;
  var selectedCategory = 'Categoria 1'.obs;

  var ufs = [
    'AC',
    'AL',
    'AP',
    'AM',
    'BA',
    'CE',
    'DF',
    'ES',
    'GO',
    'MA',
    'MT',
    'MS',
    'MG',
    'PA',
    'PB',
    'PR',
    'PE',
    'PI',
    'RJ',
    'RN',
    'RS',
    'RO',
    'RR',
    'SC',
    'SP',
    'SE',
    'TO'
  ].obs;
  var selectedUf = 'AC'.obs;

  RxList<Expense> listExpenses = RxList<Expense>([]);

  final repository = Get.put(ExpenseRepository());

  @override
  void onInit() {
    super.onInit();
    loadTransactions();
  }

  Future<void> getAllExpense() async {
    isLoading.value = true;
    try {
      listExpenses.value = await repository.getAll();
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }

  void loadTransactions() {
    transactions.value = [
      Transaction(
          date: '11/07/2024',
          description: 'MANUTENÇÃO PREVENTIVA',
          amount: -3000.0,
          type: 'COD. DESPESA',
          code: '00123'),
      Transaction(
          date: '01/07/2024',
          description: 'FRETE - ARAPONGAS - BAHIA',
          amount: 1550.0,
          type: 'COD. RECEBIMENTO',
          code: '00124'),
      // Adicione outras transações aqui
    ];
    filteredTransactions.value = transactions;
  }

  void onValueChanged(String value, String controllerType) {
    String formattedValue = FormattedInputers.formatValue(value);

    switch (controllerType) {
      case 'valueReceive':
        amountController.value = amountController.value.copyWith(
          text: formattedValue,
          selection: TextSelection.collapsed(offset: formattedValue.length),
        );
        break;
      // case 'value':
      //   //txtValueController.value = txtValueController.value.copyWith(
      //    // text: formattedValue,
      //     //selection: TextSelection.collapsed(offset: formattedValue.length),
      //   );
      //   break;
      default:
        throw ArgumentError('Controller passado incorreto: $controllerType');
    }
  }

  void filterTransactions(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredTransactions.value = transactions;
    } else {
      filteredTransactions.value = transactions.where((transaction) {
        return transaction.description
            .toLowerCase()
            .contains(query.toLowerCase());
      }).toList();
    }
  }

  void pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Recortar Imagem',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ],
          ),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
            title: 'Recortar Imagem',
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
            ],
          ),
        ],
      );
      if (croppedFile != null) {
        selectedImagePath.value = croppedFile.path;
        selectedsImagesExpense.add(selectedImagePath.value);
      }
    } else {
      Get.snackbar('Erro', 'Nenhuma imagem selecionada');
    }
  }
}

class Transaction {
  final String date;
  final String description;
  final double amount;
  final String type;
  final String code;

  Transaction(
      {required this.date,
      required this.description,
      required this.amount,
      required this.type,
      required this.code});
}
