// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rodocalc/app/data/controllers/transaction_controller.dart';
import 'package:rodocalc/app/data/controllers/trip_controller.dart';
import 'package:rodocalc/app/data/models/expense_category_model.dart';
import 'package:rodocalc/app/data/models/expense_trip_model.dart';
import 'package:rodocalc/app/data/models/transactions_model.dart';
import 'package:rodocalc/app/data/models/trip_model.dart';
import 'package:rodocalc/app/utils/custom_elevated_button.dart';
import 'package:rodocalc/app/utils/formatter.dart';
import 'package:rodocalc/app/utils/services.dart';

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

  final transactionController = Get.put(TransactionController());

  bool isAbastecimento() {
    return transactionController.expenseCategories.any((category) =>
        category.id == controller.selectedCategory.value &&
        RegExp(r'\b(combustível|abastecimento|abastecer|combustivel|abastece|abasteci)\b',
                caseSensitive: false)
            .hasMatch(category.descricao!));
  }

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
                      child: Text('RECEBIMENTO'),
                    ),
                    DropdownMenuItem(
                      value: 'saida',
                      child: Text('DESPESA'),
                    ),
                  ],
                  onChanged: (value) {
                    controller.txtTipoLancamentoTripController.text = value!;
                    controller.tipoLancamento.value = value;
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.sync_alt),
                    labelText: 'TIPO DE LANÇAMENTO',
                  ),
                ),
                const SizedBox(height: 15),
                Obx(
                  () => controller.tipoLancamento.value == 'saida'
                      ? DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search_rounded),
                            labelText: 'CATEGORIA',
                          ),
                          items: [
                            DropdownMenuItem<int>(
                              value: null,
                              child: SizedBox(
                                width:
                                    Get.width * 0.7, // Limita a largura do item
                                child: const Text(
                                  'SELECIONE UMA CATEGORIA',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Color(0xFFFF6B00)),
                                ),
                              ),
                            ),
                            ...transactionController.expenseCategories
                                .map((ExpenseCategory category) {
                              return DropdownMenuItem<int>(
                                value: category.id!,
                                child: SizedBox(
                                  width: Get.width *
                                      0.7, // Limita a largura do item
                                  child: Text(
                                    Services.capitalizeWords(
                                        category.descricao!),
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontFamily: 'Inter-Bold',
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                          onChanged: (newValue) {
                            controller.selectedCategory.value = newValue!;
                          },
                          value: transactionController.expenseCategories.any(
                                  (category) =>
                                      category.id ==
                                      controller.selectedCategory.value)
                              ? controller.selectedCategory.value
                              : null,
                          validator: (value) {
                            if (controller.tipoLancamento.value == 'saida' &&
                                value == null) {
                              return 'Por favor, selecione a categoria';
                            }
                            return null;
                          },
                        )
                      : const SizedBox.shrink(),
                ),
                Obx(() => controller.tipoLancamento.value == "saida"
                    ? const SizedBox(height: 15)
                    : const SizedBox.shrink()),
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
                Obx(
                  () => Visibility(
                    visible: controller.selectedCategory.value != null &&
                        isAbastecimento(),
                    child: TextFormField(
                      controller: controller.txtLitrosController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+([.,]\d*)?$')),
                      ],
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.local_gas_station),
                        labelText: 'LITROS ABASTECIDO',
                      ),
                      onChanged: (value) {
                        // Se já existir um ponto, impede adicionar outro
                        if (value.contains('.') && value.endsWith('.')) return;

                        // Substitui vírgula por ponto
                        String newValue = value.replaceAll(',', '.');

                        // Atualiza o controlador sem apagar o campo
                        controller.txtLitrosController.value = TextEditingValue(
                          text: newValue,
                          selection:
                              TextSelection.collapsed(offset: newValue.length),
                        );
                      },
                      validator: (value) {
                        if (isAbastecimento()) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, informe o litro abastecido';
                          }

                          // Converte para número e valida
                          final numValue =
                              double.tryParse(value.replaceAll(',', '.'));
                          if (numValue == null) {
                            return 'Digite um número válido';
                          }
                          if (numValue <= 0) {
                            return 'O valor deve ser maior que zero';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
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
                        if (controller.viewTripFormKey.currentState!
                            .validate()) {
                          Map<String, dynamic> retorno = isUpdate
                              ? await controller.updateExpenseTrip(
                                  trip!.id!, transaction!.id!)
                              : await controller.insertExpenseTrip(trip!.id!);
                          if (retorno['success'] == true) {
                            Get.back();
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
