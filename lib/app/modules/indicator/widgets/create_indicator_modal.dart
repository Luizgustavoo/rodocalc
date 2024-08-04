import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/indicator_controller.dart';
import 'package:rodocalc/app/data/models/indication_model.dart';
import 'package:rodocalc/app/utils/custom_elevated_button.dart';
import 'package:rodocalc/app/utils/formatter.dart';

class CreateIndicatorModal extends GetView<IndicationController> {
  const CreateIndicatorModal(
      {super.key, required this.isUpdate, this.indication});

  final bool isUpdate;
  final Indication? indication;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Form(
          key: controller.formKeyIndication,
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
                    'CADASTRO DE INDICADOR',
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
                  controller: controller.txtNomeIndication,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      size: 25,
                    ),
                    labelText: 'NOME',
                  ),
                  textCapitalization: TextCapitalization.characters,
                  onChanged: (value) => FormattedInputers.toUpperCase(
                      value, controller.txtNomeIndication),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o nome';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: controller.txtTelefoneIndication,
                  keyboardType: TextInputType.number,
                  maxLength: 15,
                  decoration: const InputDecoration(
                    counterText: '',
                    prefixIcon: Icon(
                      Icons.phone,
                    ),
                    labelText: 'TELEFONE',
                  ),
                  onChanged: (value) {
                    FormattedInputers.onContactChanged(
                        value, controller.txtTelefoneIndication);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o telefone';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
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
                        Map<String, dynamic> retorno = isUpdate
                            ? await controller.updateIndication(indication!.id!)
                            : await controller.insertIndication();

                        if (retorno['success'] == true) {
                          Get.back();
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
                      child: const Text(
                        'CADASTRAR',
                        style: TextStyle(
                            fontFamily: 'Inter-Bold', color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
