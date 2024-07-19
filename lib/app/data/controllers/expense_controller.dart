import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/models/expense_model.dart';
import 'package:rodocalc/app/data/repositories/expense_repository.dart';

class ExpenseController extends GetxController {
  RxBool trailerCheckboxValue = false.obs;

  final formKeyExpense = GlobalKey<FormState>();
  final descriptionController = TextEditingController();
  final expenseCategoryIdController = TextEditingController();
  final specificTypeExpenseIdController = TextEditingController();
  final valueController = TextEditingController();
  final companyController = TextEditingController();
  final cityController = TextEditingController();
  final ufController = TextEditingController();
  final dddController = TextEditingController();
  final phoneController = TextEditingController();
  final commetnsController = TextEditingController();
  final peopleIdController = TextEditingController();
  final vehicleIdController = TextEditingController();
  final statusController = TextEditingController();

  RxBool isLoading = true.obs;

  late Expense selectedExpense;

  RxList<Expense> listExpense = RxList<Expense>([]);

  final repository = Get.find<ExpenseRepository>();

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };
  dynamic mensagem;

  Future<void> getAll() async {
    isLoading.value = true;
    try {
      listExpense.value = await repository.getAll();
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }

  Future<Map<String, dynamic>> insertExpense() async {
    if (formKeyExpense.currentState!.validate()) {
      mensagem = await repository.insert(Expense(
        descricao: descriptionController.text,
        categoriadespesaId: expenseCategoryIdController.text as int,
        tipoespecificodespesaId: specificTypeExpenseIdController.text as int,
        valor: valueController.text as double,
        empresa: companyController.text,
        cidade: cityController.text,
        uf: ufController.text,
        ddd: dddController.text,
        telefone: phoneController.text,
        observacoes: commetnsController.text,
        pessoaId: peopleIdController.text as int,
        veiculoId: vehicleIdController.text as int,
        status: 1,
      ));
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
      getAll();
    }
    return retorno;
  }

  Future<Map<String, dynamic>> updateVehicle(int id) async {
    if (formKeyExpense.currentState!.validate()) {
      mensagem = await repository.update(Expense(
        id: id,
        descricao: descriptionController.text,
        categoriadespesaId: expenseCategoryIdController.text as int,
        tipoespecificodespesaId: specificTypeExpenseIdController.text as int,
        valor: valueController.text as double,
        empresa: companyController.text,
        cidade: cityController.text,
        uf: ufController.text,
        ddd: dddController.text,
        telefone: phoneController.text,
        observacoes: commetnsController.text,
        pessoaId: peopleIdController.text as int,
        veiculoId: vehicleIdController.text as int,
        status: 1,
      ));
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
      getAll();
    }
    return retorno;
  }

  Future<Map<String, dynamic>> deleteVehicle(int id) async {
    if (formKeyExpense.currentState!.validate()) {
      mensagem = await repository.delete(Expense(id: id));
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
      getAll();
    }
    return retorno;
  }

  void fillInFields() {
    descriptionController.text = selectedExpense.descricao.toString();
    expenseCategoryIdController.text =
        selectedExpense.categoriadespesaId.toString();
    specificTypeExpenseIdController.text =
        selectedExpense.tipoespecificodespesaId.toString();
    valueController.text = selectedExpense.valor.toString();
    companyController.text = selectedExpense.empresa.toString();
    cityController.text = selectedExpense.cidade.toString();
    ufController.text = selectedExpense.uf.toString();
    dddController.text = selectedExpense.ddd.toString();
    phoneController.text = selectedExpense.telefone.toString();
    commetnsController.text = selectedExpense.observacoes.toString();
    peopleIdController.text = selectedExpense.pessoaId.toString();
    vehicleIdController.text = selectedExpense.veiculoId.toString();
    statusController.text = selectedExpense.status.toString();
  }

  void clearAllFields() {
    final textControllers = [
      descriptionController,
      expenseCategoryIdController,
      specificTypeExpenseIdController,
      valueController,
      companyController,
      cityController,
      ufController,
      dddController,
      phoneController,
      commetnsController,
      peopleIdController,
      vehicleIdController,
      statusController
    ];

    for (final controller in textControllers) {
      controller.clear();
    }
  }
}
