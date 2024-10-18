import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/comission_indicator_controller.dart';
import 'package:rodocalc/app/data/models/indication_model.dart';
import 'package:rodocalc/app/utils/custom_elevated_button.dart';
import 'package:rodocalc/app/utils/formatter.dart';

class WithdrawalRequestModal extends GetView<ComissionIndicatorController> {
  const WithdrawalRequestModal(
      {super.key, required this.isUpdate, this.indication});

  final bool isUpdate;
  final Indication? indication;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Form(
          key: controller.formKeyComissionIndication,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 5),
                  child: Text(
                    'SOLICITAR SAQUE',
                    style: TextStyle(
                        fontFamily: 'Inter-Bold',
                        fontSize: 17,
                        color: Color(0xFFFF6B00)),
                  ),
                ),
                const Divider(
                  endIndent: 20,
                  indent: 20,
                  height: 5,
                  thickness: 2,
                  color: Colors.black,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.txtDescription,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      size: 25,
                    ),
                    labelText: 'NOME OU DESCRIÇAO DA CONTA',
                  ),
                  textCapitalization: TextCapitalization.characters,
                  onChanged: (value) => FormattedInputers.toUpperCase(
                      value, controller.txtDescription),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o nome correto da descricao da conta.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.txtPixKey,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      FontAwesomeIcons.pix,
                      size: 25,
                    ),
                    labelText: 'CHAVE PIX',
                  ),
                  textCapitalization: TextCapitalization.characters,
                  onChanged: (value) => FormattedInputers.toUpperCase(
                      value, controller.txtPixKey),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a chave pix.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 120,
                      child: TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text(
                            'CANCELAR',
                            style: TextStyle(
                                fontFamily: 'Inter-Bold',
                                color: Color(0xFFFF6B00)),
                          )),
                    ),
                    const SizedBox(width: 10),
                    CustomElevatedButton(
                      onPressed: () async {
                        Map<String, dynamic> retorno =
                            await controller.solicitarSaque();

                        if (retorno['success'] == true) {
                          Get.back();
                          controller.getExistsPedidoSaque();
                          Get.snackbar(
                              'Sucesso!', retorno['message'].join('\n'),
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              duration: const Duration(seconds: 2),
                              snackPosition: SnackPosition.BOTTOM);
                        } else {
                          Get.snackbar('Falha!', retorno['message'].join('\n'),
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                              duration: const Duration(seconds: 2),
                              snackPosition: SnackPosition.BOTTOM);
                        }
                      },
                      child: Text(
                        isUpdate ? 'ALTERAR' : 'CADASTRAR',
                        style: const TextStyle(
                            fontFamily: 'Inter-Bold', color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          )),
    );
  }
}
