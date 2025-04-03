import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/models/viagens_model.dart';
import 'package:rodocalc/app/data/repositories/viagens_repository.dart';

class ViagensController extends GetxController {
  RxList<Viagens> listViagens = RxList<Viagens>([]);
  RxList<Viagens> filteredViagens = RxList<Viagens>([]);

  RxBool isLoadingViagens = true.obs;
  RxBool isLoadingCRUDViagens = false.obs;
  RxBool isLoadingDataViagens = true.obs;
  RxBool isLoadingInsertPhotosViagens = false.obs;

  final viagensFormKey = GlobalKey<FormState>();

  final tituloViagensController = TextEditingController();
  final situacaoViagensController = TextEditingController();
  final numeroViagemController = TextEditingController();
  final searchViagensController = TextEditingController();

  var situacaoViagens = 'OPENED'.obs;

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };

  dynamic mensagem;

  final repositoryViagens = Get.put(ViagensRepository());

  Future<void> getAllViagens() async {
    isLoadingViagens.value = true;
    try {
      searchViagensController.clear();
      listViagens.value = await repositoryViagens.getAll();
      filteredViagens.assignAll(listViagens);
    } catch (e) {
      listViagens.clear();
      filteredViagens.clear();
      Exception(e);
    }
    isLoadingViagens.value = false;
  }

  var searchFilter = ''.obs;

  void fillInFieldsViagens(Viagens viagem) {
    tituloViagensController.text = viagem.titulo ?? '';
    situacaoViagensController.text = viagem.situacao ?? '';
    numeroViagemController.text = viagem.numeroViagem ?? '';
  }

  void clearAllFieldsViagens() {
    final textControllers = [
      tituloViagensController,
      situacaoViagensController,
      numeroViagemController
    ];

    for (final controller in textControllers) {
      controller.clear();
    }
  }

  Future<Map<String, dynamic>> updateViagens(int id) async {
    isLoadingCRUDViagens(false);
    if (viagensFormKey.currentState!.validate()) {
      mensagem = await repositoryViagens.update(Viagens(
          id: id,
          situacao: situacaoViagens.value,
          titulo: tituloViagensController.text,
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
    isLoadingCRUDViagens(false);
    return retorno;
  }

  Future<Map<String, dynamic>> deleteViagens(int id) async {
    isLoadingCRUDViagens(false);
    if (id > 0) {
      mensagem = await repositoryViagens.delete(Viagens(id: id));
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
    isLoadingCRUDViagens(false);
    return retorno;
  }

  Future<Map<String, dynamic>> closeViagens(int id) async {
    isLoadingCRUDViagens(false);
    if (id > 0) {
      mensagem = await repositoryViagens.close(Viagens(id: id));
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
    isLoadingCRUDViagens(false);
    return retorno;
  }

  Future<Map<String, dynamic>> insertViagens() async {
    if (viagensFormKey.currentState!.validate()) {
      mensagem = await repositoryViagens.insert(Viagens(
          situacao: situacaoViagens.value,
          titulo: tituloViagensController.text,
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
