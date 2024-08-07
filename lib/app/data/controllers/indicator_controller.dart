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

  RxList<Indication> listIndications = RxList<Indication>([]);

  final repository = Get.put(IndicationRepository());

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };

  dynamic mensagem;
  RxBool isLoading = true.obs;

  Future<void> getAll() async {
    isLoading.value = true;
    try {
      listIndications.value = await repository.getAll();
    } catch (e) {
      listIndications.clear();
      Exception(e);
    }
    isLoading.value = false;
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
