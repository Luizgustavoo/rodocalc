import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/models/viagens_model.dart';
import 'package:rodocalc/app/data/repositories/viagens_repository.dart';

class ViagensController extends GetxController {
  RxList<Viagens> listViagens = RxList<Viagens>([]);
  RxList<Viagens> filteredViagens = RxList<Viagens>([]);

  RxBool isLoading = true.obs;
  RxBool isLoadingPDF = false.obs;
  RxBool isLoadingCRUD = false.obs;
  RxBool isLoadingData = true.obs;
  RxBool isLoadingInsertPhotos = false.obs;

  final viagensFormKey = GlobalKey<FormState>();

  final tituloController = TextEditingController();
  final situacaoController = TextEditingController();
  final numeroViagemController = TextEditingController();
  final searchViagensController = TextEditingController();

  var situacao = 'OPENED'.obs;

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };

  dynamic mensagem;

  final repository = Get.put(ViagensRepository());

  Future<void> getAllViagens() async {
    isLoading.value = true;
    try {
      searchViagensController.clear();
      listViagens.value = await repository.getAll();
      filteredViagens.assignAll(listViagens);
    } catch (e) {
      listViagens.clear();
      filteredViagens.clear();
      Exception(e);
    }
    isLoading.value = false;
  }

  var searchFilter = ''.obs;

  void fillInFieldsViagens(Viagens viagem) {
    tituloController.text = viagem.titulo ?? '';
    situacaoController.text = viagem.situacao ?? '';
    numeroViagemController.text = viagem.numeroViagem ?? '';
  }

  void clearAllFieldsViagens() {
    final textControllers = [
      tituloController,
      situacaoController,
      numeroViagemController
    ];

    for (final controller in textControllers) {
      controller.clear();
    }
  }

  Future<Map<String, dynamic>> updateViagens(int id) async {
    isLoadingCRUD(false);
    if (viagensFormKey.currentState!.validate()) {
      mensagem = await repository.update(Viagens(
          id: id,
          situacao: situacao.value,
          titulo: tituloController.text,
          numeroViagem: numeroViagemController.text));

      if (mensagem != null) {
        retorno = {
          'success': mensagem['success'],
          'message': mensagem['message']
        };
        getAllViagens();
      } else {
        retorno = {
          'success': false,
          'message': ['Falha ao realizar a operação!']
        };
      }
    }
    isLoadingCRUD(false);
    return retorno;
  }

  Future<Map<String, dynamic>> deleteViagens(int id) async {
    isLoadingCRUD(false);
    if (id > 0) {
      mensagem = await repository.delete(Viagens(id: id));
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
      getAllViagens();
    } else {
      retorno = {
        'success': false,
        'message': ['Falha ao realizar a operação!']
      };
    }
    isLoadingCRUD(false);
    return retorno;
  }

  Future<Map<String, dynamic>> closeViagens(int id) async {
    isLoadingCRUD(false);
    if (id > 0) {
      mensagem = await repository.close(Viagens(id: id));
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
      getAllViagens();
    } else {
      retorno = {
        'success': false,
        'message': ['Falha ao realizar a operação!']
      };
    }
    isLoadingCRUD(false);
    return retorno;
  }

  Future<Map<String, dynamic>> insertViagens() async {
    if (viagensFormKey.currentState!.validate()) {
      mensagem = await repository.insert(Viagens(
          situacao: situacao.value,
          titulo: tituloController.text,
          numeroViagem: numeroViagemController.text));
      if (mensagem != null) {
        retorno = {
          'success': mensagem['success'],
          'message': mensagem['message']
        };
        getAllViagens();
      } else {
        retorno = {
          'success': false,
          'message': ['Falha ao realizar a operação!']
        };
      }
    }
    return retorno;
  }
}
