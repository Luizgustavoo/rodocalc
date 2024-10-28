import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/plan_controller.dart';
import 'package:rodocalc/app/routes/app_routes.dart';
import 'package:rodocalc/app/utils/custom_elevated_button.dart';
import 'package:rodocalc/app/utils/formatter.dart';
import 'package:rodocalc/app/utils/services.dart';

class CreatePlanModal extends GetView<PlanController> {
  final String? recurrence;

  const CreatePlanModal({super.key, this.recurrence});

  @override
  Widget build(BuildContext context) {
    // int multiplicacao = recurrence == "ANUAL" ? 12 : 1;
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: controller.planKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Obx(() => Text(
                    "${controller.selectedPlan.value!.descricao ?? ''} - $recurrence",
                    style: const TextStyle(
                        fontFamily: 'Inter-Bold',
                        fontSize: 20,
                        color: Color(0xFFFF6B00)),
                  )),
              const SizedBox(height: 20),
              const Divider(
                endIndent: 20,
                indent: 20,
                height: 5,
                thickness: 2,
                color: Colors.black,
              ),
              const SizedBox(height: 20),
              Obx(
                () {
                  // Obtém o valor mínimo de licenças
                  int minLicencas = controller.selectedPlan.value!.minLicencas!;

                  // Gera a lista de itens a partir do valor mínimo até 50
                  List<DropdownMenuItem<int>> items = List.generate(
                    50 - minLicencas + 1,
                    (index) => DropdownMenuItem(
                      value: minLicencas + index,
                      child: Text('${minLicencas + index} Licença(s)'),
                    ),
                  );

                  // Verifica se o valor atual está na lista de itens
                  if (!items.any((item) =>
                      item.value == controller.selectedLicenses.value)) {
                    controller.selectedLicenses.value = minLicencas;
                  }

                  return DropdownButtonFormField<int>(
                    value: controller.selectedLicenses.value,
                    items: items,
                    onChanged: controller.updateLicenses,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.location_on),
                      labelText: 'QUANTIDADE DE LICENÇAS',
                    ),
                  );
                },
              ),
              // const SizedBox(height: 15.0),
              // Obx(
              //   () => DropdownButtonFormField<String>(
              //     value: controller.selectedRecurrence.value.isEmpty
              //         ? null
              //         : controller.selectedRecurrence.value,
              //     items:
              //         ['MENSAL', 'SEMESTRAL', 'ANUAL'].map((String recurrence) {
              //       return DropdownMenuItem<String>(
              //         value: recurrence,
              //         child: Text(recurrence),
              //       );
              //     }).toList(),
              //     onChanged: (newValue) {
              //       controller.updateRecurrence(newValue);
              //     },
              //     decoration: const InputDecoration(
              //       prefixIcon: Icon(Icons.calendar_today),
              //       labelText: 'RECORRÊNCIA',
              //     ),
              //     validator: (value) {
              //       if (value == null || value.isEmpty) {
              //         return 'Por favor, selecione uma recorrência';
              //       }
              //       return null;
              //     },
              //   ),
              // ),
              const SizedBox(height: 15.0),
              TextFormField(
                controller: controller.numberCardController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.credit_card),
                    labelText: 'NÚMERO DO CARTÃO',
                    counterText: ''),
                keyboardType: TextInputType.number,
                maxLength: 19,
                onChanged: (value) {
                  controller.numberCardController.text =
                      controller.formatCardNumber(value);
                  controller.numberCardController.selection =
                      TextSelection.fromPosition(TextPosition(
                          offset: controller.numberCardController.text.length));

                  controller.bandeiraCartao.value =
                      FormattedInputers.getCardType(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o número do cartão';
                  }
                  value =
                      value.replaceAll(RegExp(r'\s+'), ''); // Remove espaços
                  if (value.length < 16 || value.length > 19) {
                    return 'Número do cartão inválido';
                  }
                  if (!FormattedInputers.isValidCardNumber(value)) {
                    return 'Número do cartão inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedCardType.value.isEmpty
                      ? null
                      : controller.selectedCardType.value,
                  items: controller.cardTypes.map((cardType) {
                    return DropdownMenuItem<String>(
                      value: cardType.name,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 30,
                            height: 25,
                            child: Image.asset(
                              cardType.imagePath,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(cardType.name),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    controller.updateCardType(newValue);
                  },
                  decoration: const InputDecoration(
                    labelText: 'BANDEIRA DO CARTÃO',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      maxLength: 5,
                      controller: controller.validateController,
                      decoration: const InputDecoration(
                        counterText: '',
                        prefixIcon: Icon(Icons.date_range),
                        labelText: 'VALIDADE',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        FormattedInputers.onCardExpiryDateChanged(
                            value, controller.validateController);
                      },
                      validator: (value) {
                        return FormattedInputers.validateCardExpiryDate(value);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: controller.cvvController,
                      maxLength: 3,
                      decoration: const InputDecoration(
                        counterText: '',
                        prefixIcon: Icon(Icons.lock),
                        labelText: 'CVV',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Digite o cvv do cartão.';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.nameCardController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: 'NOME NO CARTÃO',
                ),
                onChanged: (text) {
                  controller.nameCardController.value = TextEditingValue(
                    text: text.toUpperCase(),
                    selection: controller.nameCardController.selection,
                  );
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite o nome igual do cartão.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.cpfController,
                keyboardType: TextInputType.number,
                maxLength: 14,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.badge),
                    labelText: 'CPF DO TITULAR',
                    counterText: ''),
                onChanged: (value) {
                  FormattedInputers.onCpfChanged(
                      value, controller.cpfController);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Digite seu cpf ou cnpj";
                  }
                  if (!Services.validCPF(value)) {
                    return "Digite um cpf ou cnpj válido";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                        'TOTAL: ${(FormattedInputers.formatValue(controller.calculatedPrice.value))}',
                        style: const TextStyle(
                            fontFamily: 'Inter-Black', fontSize: 18),
                      )),
                  CustomElevatedButton(
                    onPressed: () async {
                      Map<String, dynamic> retorno =
                          await controller.subscribe();

                      if (retorno['success'] == true) {
                        controller.clearAllFields();
                        Get.offAllNamed(Routes.home);
                        Get.snackbar('Sucesso!', retorno['message'].join('\n'),
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
                    child: Obx(() {
                      if (controller.isLoadingSubscrible.value) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return const Text(
                        'CONTRATAR',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'InterBold'),
                      );
                    }),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
