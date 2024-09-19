import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/plan_controller.dart';
import 'package:rodocalc/app/data/models/plan_model.dart';
import 'package:rodocalc/app/routes/app_routes.dart';
import 'package:rodocalc/app/utils/custom_elevated_button.dart';
import 'package:rodocalc/app/utils/formatter.dart';
import 'package:rodocalc/app/utils/services.dart';

class UpdatePlanModal extends GetView<PlanController> {
  const UpdatePlanModal({super.key, this.plano, required this.isUpdate});

  final Plan? plano;

  final bool isUpdate;

  @override
  Widget build(BuildContext context) {
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
                    controller.selectedPlan.value!.descricao ?? '',
                    style: const TextStyle(
                        fontFamily: 'Inter-Bold',
                        fontSize: 25,
                        color: Color(0xFFFF6B00)),
                  )),
              const Divider(
                endIndent: 8,
                indent: 8,
                height: 5,
                thickness: 2,
                color: Colors.black,
              ),
              const SizedBox(height: 20),
              Obx(() => Text(
                    '${controller.selectedLicenses.value} licença(s) ativa(s)',
                    style:
                        const TextStyle(fontSize: 18, fontFamily: 'Inter-Bold'),
                  )),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Adicionar licença(s)',
                        style: TextStyle(
                            fontSize: 16, fontFamily: 'Inter-Regular')),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if (controller.selectedLicenses.value > 0) {
                              controller.selectedLicenses.value--;
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            controller.selectedLicenses.value++;
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Obx(
                () => DropdownButtonFormField<Plan>(
                  value: controller.selectedPlan.value,
                  items: controller.listPlans.map((plan) {
                    return DropdownMenuItem<Plan>(
                      value: plan,
                      child: Text(plan.descricao ?? ''),
                    );
                  }).toList(),
                  onChanged: (Plan? selectedPlan) {
                    if (selectedPlan != null) {
                      controller.updateSelectedPlan(selectedPlan);
                    }
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.assignment),
                    labelText: 'SELECIONE O PLANO',
                  ),
                ),
              ),
              const SizedBox(height: 15),
              if (isUpdate) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      'Deseja alterar o cartão de crédito?',
                      style: TextStyle(fontFamily: 'Inter-Bold'),
                    ),
                    Obx(() => Switch(
                          value: controller.shouldChangeCard.value,
                          onChanged: (newValue) {
                            controller.shouldChangeCard.value = newValue;
                          },
                        )),
                  ],
                ),
              ],
              Obx(() {
                if (controller.shouldChangeCard.value) {
                  return Column(
                    children: [
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
                                  offset: controller
                                      .numberCardController.text.length));

                          controller.bandeiraCartao.value =
                              FormattedInputers.getCardType(value);
                        },
                        validator: (value) {
                          if ((value == null || value.isEmpty) &&
                              controller.shouldChangeCard.value) {
                            return 'Por favor, insira o número do cartão';
                          }
                          value = value!
                              .replaceAll(RegExp(r'\s+'), ''); // Remove espaços
                          if ((value.length < 16 || value.length > 19) &&
                              controller.shouldChangeCard.value) {
                            return 'Número do cartão inválido';
                          }
                          if (controller.shouldChangeCard.value) {
                            if (!FormattedInputers.isValidCardNumber(value)) {
                              return 'Número do cartão inválido';
                            }
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
                                if (controller.shouldChangeCard.value) {
                                  return FormattedInputers
                                      .validateCardExpiryDate(value);
                                }
                                return null;
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
                                if ((value == null || value.isEmpty) &&
                                    controller.shouldChangeCard.value) {
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
                        validator: (value) {
                          if ((value == null || value.isEmpty) &&
                              controller.shouldChangeCard.value) {
                            return 'Digite o nome igual do cartão.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: controller.cpfController,
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
                          if ((value == null || value.isEmpty) &&
                              controller.shouldChangeCard.value) {
                            return "Digite seu cpf ou cnpj";
                          }
                          if (controller.shouldChangeCard.value) {
                            if (!Services.validCPF(value!)) {
                              return "Digite um cpf ou cnpj válido";
                            }
                          }
                          return null;
                        },
                      ),
                    ],
                  );
                } else {
                  return const SizedBox
                      .shrink(); // Retorna um espaço vazio se não for para mostrar os campos
                }
              }),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          'TOTAL: ${(FormattedInputers.formatValue(controller.calculatedPrice.value))}',
                          style: const TextStyle(
                              fontFamily: 'Inter-Black', fontSize: 18),
                        ),
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
                      return Text(
                        isUpdate ? 'ALTERAR PLANO' : 'CONTRATAR',
                        style: const TextStyle(
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
