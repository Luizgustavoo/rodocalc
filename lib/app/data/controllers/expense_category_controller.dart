import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/models/expense_category_model.dart';
import 'package:rodocalc/app/data/repositories/expense_category_repository.dart';

class ExpenseCategoryController extends GetxController {
  RxBool trailerCheckboxValue = false.obs;

  final formKeyExpenseCategory = GlobalKey<FormState>();
  final descriptionController = TextEditingController();

  RxBool isLoading = true.obs;

  late ExpenseCategory selectedExpenseCategory;

  RxList<ExpenseCategory> listExpenseCategory = RxList<ExpenseCategory>([]);

  final repository = Get.find<ExpenseCategoryRepository>();

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };
  dynamic mensagem;

  Future<void> getAll() async {
    isLoading.value = true;
    try {
      listExpenseCategory.value = await repository.getAll();
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }

  Future<Map<String, dynamic>> insertExpenseCategory() async {
    if (formKeyExpenseCategory.currentState!.validate()) {
      mensagem = await repository.insert(ExpenseCategory(
        descricao: descriptionController.text,
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
    if (formKeyExpenseCategory.currentState!.validate()) {
      mensagem = await repository.update(ExpenseCategory(
        id: id,
        descricao: descriptionController.text,
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
    if (formKeyExpenseCategory.currentState!.validate()) {
      mensagem = await repository.delete(ExpenseCategory(id: id));
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
      getAll();
    }
    return retorno;
  }

  void fillInFields() {
    descriptionController.text = selectedExpenseCategory.descricao.toString();
  }

  void clearAllFields() {
    final textControllers = [descriptionController];

    for (final controller in textControllers) {
      controller.clear();
    }
  }
}
