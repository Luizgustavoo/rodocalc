import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rodocalc/app/data/models/indication_model.dart';
import 'package:rodocalc/app/data/repositories/Indication_repository.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class IndicationController extends GetxController {
  final box = GetStorage('rodocalc');

  late Indication selectedIndication;

  final formKeyIndication = GlobalKey<FormState>();
  final txtNomeIndication = TextEditingController();
  final txtTelefoneIndication = TextEditingController();
  final searchIndicatorController = TextEditingController();

  RxList<Indication> listIndications = RxList<Indication>([]);
  RxList<Indication> filteredIndications = RxList<Indication>([]);

  final repository = Get.put(IndicationRepository());

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };

  dynamic mensagem;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    filteredIndications.assignAll(listIndications);
  }

  Future<void> getAll() async {
    isLoading.value = true;
    try {
      searchIndicatorController.clear();
      listIndications.value = await repository.getAll();
      filteredIndications.assignAll(listIndications);
    } catch (e) {
      listIndications.clear();
      filteredIndications.clear();
      Exception(e);
    }
    isLoading.value = false;
  }

  void filterIndications(String query) {
    if (query.isEmpty) {
      // Se a busca estiver vazia, mostra todos os fretes
      filteredIndications.assignAll(listIndications);
    } else {
      // Filtra os fretes com base no campo "origem", "destino" ou qualquer outro
      filteredIndications.assignAll(
        listIndications
            .where((indicator) =>
                indicator.nome!.toLowerCase().contains(query.toLowerCase()) ||
                indicator.telefone!.toLowerCase().contains(query.toLowerCase()))
            .toList(),
      );
    }
  }

  Future<Map<String, dynamic>> insertIndication() async {
    if (formKeyIndication.currentState!.validate()) {
      mensagem = await repository.insert(Indication(
        pessoaId: ServiceStorage.getUserId(),
        nome: txtNomeIndication.text,
        telefone: txtTelefoneIndication.text,
        status: 'ativo',
      ));
      if (mensagem != null) {
        retorno = {
          'success': mensagem['success'],
          'message': mensagem['message']
        };
        getAll();
      } else {
        retorno = {
          'success': false,
          'message': ['Falha ao realizar a operação!']
        };
      }
    }
    return retorno;
  }

  void fillInFields(Indication indication) {
    txtNomeIndication.text = indication.nome.toString();
    txtTelefoneIndication.text = indication.telefone.toString();
  }

  void clearAllFields() {
    final textControllers = [
      txtNomeIndication,
      txtTelefoneIndication,
    ];

    for (final controller in textControllers) {
      controller.clear();
    }
  }

  Future<Map<String, dynamic>> updateIndication(int id) async {
    if (formKeyIndication.currentState!.validate()) {
      mensagem = await repository.update(Indication(
        id: id,
        pessoaId: ServiceStorage.getUserId(),
        nome: txtNomeIndication.text,
        telefone: txtTelefoneIndication.text,
        status: 'ativo',
      ));
      if (mensagem != null) {
        retorno = {
          'success': mensagem['success'],
          'message': mensagem['message']
        };
        getAll();
      } else {
        retorno = {
          'success': false,
          'message': ['Falha ao realizar a operação!']
        };
      }
    }
    return retorno;
  }

  Future<Map<String, dynamic>> deleteIndication(int id) async {
    if (id > 0) {
      mensagem = await repository.delete(Indication(id: id));
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
    } else {
      retorno = {
        'success': false,
        'message': ['Falha ao realizar a operação!']
      };
    }
    getAll();
    return retorno;
  }
}
