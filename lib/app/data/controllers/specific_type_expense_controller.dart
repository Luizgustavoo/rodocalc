import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/models/specific_type_expense_model.dart';
import 'package:rodocalc/app/data/repositories/specific_type_expense_repository.dart';

class SpecificTypeExpenseController extends GetxController {
  RxBool trailerCheckboxValue = false.obs;

  final formKeySpecificTypeExpense = GlobalKey<FormState>();
  final descriptionController = TextEditingController();

  late SpecificTypeExpense specificTypeExpense;

  RxBool isLoading = true.obs;

  RxList<SpecificTypeExpense> listSpecificTypeExpense =
      RxList<SpecificTypeExpense>([]);

  final repository = Get.find<SpecificTypeExpenseRepository>();

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };
  dynamic mensagem;

  Future<void> getAll() async {
    isLoading.value = true;
    try {
      listSpecificTypeExpense.value = await repository.getAll();
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }

  Future<Map<String, dynamic>> insertSpecificTypeExpense() async {
    if (formKeySpecificTypeExpense.currentState!.validate()) {
      mensagem = await repository.insert(SpecificTypeExpense(
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
    if (formKeySpecificTypeExpense.currentState!.validate()) {
      mensagem = await repository.update(SpecificTypeExpense(
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
    if (formKeySpecificTypeExpense.currentState!.validate()) {
      mensagem = await repository.delete(SpecificTypeExpense(id: id));
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
      getAll();
    }
    return retorno;
  }

  void fillInFields() {
    descriptionController.text = specificTypeExpense.descricao.toString();
  }

  void clearAllFields() {
    final textControllers = [descriptionController];

    for (final controller in textControllers) {
      controller.clear();
    }
  }
}
