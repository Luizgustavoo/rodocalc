// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/trip_controller.dart';
import 'package:rodocalc/app/data/models/expense_trip_model.dart';
import 'package:rodocalc/app/data/models/transactions_model.dart';
import 'package:rodocalc/app/data/models/trip_model.dart';
import 'package:rodocalc/app/utils/custom_elevated_button.dart';
import 'package:rodocalc/app/utils/formatter.dart';

class CreateExpenseTripModal extends GetView<TripController> {
  CreateExpenseTripModal({
    super.key,
    required this.isUpdate,
    this.trip,
    this.transaction,
  }) : formKey = GlobalKey<FormState>();

  final bool isUpdate;
  final Trip? trip;
  final Transacoes? transaction;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Form(
          key: controller.viewTripFormKey,
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
                    'LANÇAR TRANSAÇÃO',
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
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: controller.txtTipoLancamentoTripController.text.isEmpty
                      ? 'entrada'
                      : controller.txtTipoLancamentoTripController.text,
                  items: const [
                    DropdownMenuItem(
                      value: 'entrada',
                      child: Text('ENTRADA'),
                    ),
                    DropdownMenuItem(
                      value: 'saida',
                      child: Text('SAÍDA'),
                    ),
                  ],
                  onChanged: (value) {
                    controller.txtTipoLancamentoTripController.text = value!;
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.sync_alt),
                    labelText: 'TIPO DE LANÇAMENTO',
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: controller.txtDateExpenseTripController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    counterText: '',
                    prefixIcon: Icon(
                      Icons.calendar_today,
                    ),
                    labelText: 'DATA E HORA',
                  ),
                  onTap: () async {
                    // Chama o método do controller para selecionar data e hora
                    await controller.selectDateTime(
                        controller.txtDateExpenseTripController);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a data e hora da despesa';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.txtDescriptionExpenseTripController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.message,
                    ),
                    labelText: 'DESCRIÇÃO',
                  ),
                  onChanged: (text) {
                    controller.txtDescriptionExpenseTripController.value =
                        TextEditingValue(
                      text: text.toUpperCase(),
                      selection: controller
                          .txtDescriptionExpenseTripController.selection,
                    );
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a descrição da despesa';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.txtAmountExpenseTripController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.monetization_on,
                    ),
                    labelText: 'VALOR',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o valor';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.txtKmController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    counterText: '',
                    prefixIcon: Icon(Icons.add_road_sharp),
                    labelText: 'Quilometragem',
                  ),
                  onChanged: (value) {
                    FormattedInputers.formatAndUpdateText(
                        controller.txtKmController);
                  },
                ),
                const SizedBox(height: 10),
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
                        if (controller.viewTripFormKey.currentState!
                            .validate()) {
                          Map<String, dynamic> retorno = isUpdate
                              ? await controller.updateExpenseTrip(
                                  trip!.id!, transaction!.id!)
                              : await controller.insertExpenseTrip(trip!.id!);
                          if (retorno['success'] == true) {
                            Get.back();
                            Get.snackbar(
                                'Sucesso!', retorno['message'].join('\n'),
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 2),
                                snackPosition: SnackPosition.BOTTOM);
                          } else {
                            Get.snackbar(
                                'Falha!', retorno['message'].join('\n'),
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 2),
                                snackPosition: SnackPosition.BOTTOM);
                          }
                        }
                      },
                      child: Text(
                        isUpdate ? 'ALTERAR' : 'SALVAR',
                        style: const TextStyle(
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
