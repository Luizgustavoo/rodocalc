import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/repositories/comission_repository.dart';

import '../models/comission_indicator_model.dart';

class ComissionIndicatorController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<ComissionIndicator> listComissions = RxList<ComissionIndicator>([]);

  final formKeyComissionIndication = GlobalKey<FormState>();
  final txtPixKey = TextEditingController();
  final txtDescription = TextEditingController();

  final repository = Get.put(ComissionRepository());

  RxInt sumComissions = 0.obs;
  RxInt totalPedidoSaque = 0.obs;

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };
  dynamic mensagem;

  /*teste*/

  Future<void> getExistsPedidoSaque() async {
    isLoading.value = true;
    try {
      totalPedidoSaque.value = await repository.getExistsPedidoSaque();
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }

  Future<void> getAllToReceive() async {
    isLoading.value = true;
    try {
      listComissions.value = await repository.getAllToReceive();

      sumComissions.value =
          listComissions.fold(0, (sum, item) => sum + item.valorComissao!);
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }

  Future<Map<String, dynamic>> solicitarSaque() async {
    if (formKeyComissionIndication.currentState!.validate()) {
      mensagem =
          await repository.solicitarSaque(txtPixKey.text, txtDescription.text);
      if (mensagem != null) {
        retorno = {
          'success': mensagem['success'],
          'message': mensagem['message']
        };
        clearAllFields();
      } else {
        retorno = {
          'success': false,
          'message': ['Falha ao realizar a operação!']
        };
      }
    }
    return retorno;
  }

  // void fillInFields(Indication indication) {
  //   txtNomeIndication.text = indication.nome.toString();
  //   txtTelefoneIndication.text = indication.telefone.toString();
  // }

  void clearAllFields() {
    final textControllers = [
      txtPixKey,
      txtDescription,
    ];

    for (final controller in textControllers) {
      controller.clear();
    }
  }
}
