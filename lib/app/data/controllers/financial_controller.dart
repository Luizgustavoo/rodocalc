import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/models/financial_model.dart';
import 'package:rodocalc/app/data/repositories/financial_repository.dart';

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

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };
  dynamic mensagem;

  final repository = Get.put(FinancialRepository());

  RxList<Financial> listFinancial = RxList<Financial>([]);

  @override
  void onInit() {
    super.onInit();
    getAll();
  }

  Future<void> getAll() async {
    isLoading.value = true;
    try {
      listFinancial.value = await repository.getAll();
      if (listFinancial.isNotEmpty) {
        for (var financial in listFinancial) {
          transactions.add(
            Transaction(
              date: financial.data!,
              description: financial.descricao!,
              amount: financial.valor!,
              type: financial.tipo!,
              code: financial.id.toString(),
            ),
          );
        }
        filteredTransactions.value = transactions;
      }
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
