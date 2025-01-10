import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/plan_controller.dart';
import 'package:rodocalc/app/routes/app_routes.dart';
import 'package:rodocalc/app/utils/custom_elevated_button.dart';
import 'package:rodocalc/app/utils/formatter.dart';
import 'package:rodocalc/app/utils/services.dart';
import 'package:flutter/services.dart';

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
              Obx(
                () => Visibility(
                  visible: controller.showPaymentMethod.value,
                  child: const SizedBox(
                    child: Column(
                      children: [
                        SizedBox(height: 15.0),
                        Text("Selecione uma forma de pagamento:"),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: controller.showPaymentMethod.value,
                  child: Row(
                    children: [
                      controller.paymentMethod.value == 'CARD'
                          ? const SizedBox.shrink()
                          : Expanded(
                              child: CustomElevatedButton(
                                gradient:
                                    controller.paymentMethod.value == 'PIX'
                                        ? const LinearGradient(colors: [
                                            Color.fromARGB(255, 11, 135, 5),
                                            Color.fromARGB(255, 40, 255, 108)
                                          ])
                                        : const LinearGradient(colors: [
                                            Color.fromARGB(255, 210, 209, 209),
                                            Color.fromARGB(255, 195, 194, 194)
                                          ]),
                                onPressed: () {
                                  controller.paymentMethod('PIX');
                                },
                                child: const Text("PIX"),
                              ),
                            ),
                      const SizedBox(width: 10), // Espaço entre os botões
                      controller.paymentMethod.value == 'PIX'
                          ? const SizedBox.shrink()
                          : Expanded(
                              child: CustomElevatedButton(
                                gradient:
                                    controller.paymentMethod.value == 'CARD'
                                        ? const LinearGradient(colors: [
                                            Color.fromARGB(255, 11, 135, 5),
                                            Color.fromARGB(255, 40, 255, 108)
                                          ])
                                        : const LinearGradient(colors: [
                                            Color.fromARGB(255, 210, 209, 209),
                                            Color.fromARGB(255, 195, 194, 194)
                                          ]),
                                onPressed: () {
                                  controller.paymentMethod('CARD');
                                },
                                child: const Text("CARTÃO"),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
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

                  return Visibility(
                      visible: (controller.paymentMethod.value == 'CARD' ||
                              controller.paymentMethod.value == 'PIX') &&
                          controller.showPaymentMethod.value,
                      child: DropdownButtonFormField<int>(
                        value: controller.selectedLicenses.value,
                        items: items,
                        onChanged: controller.updateLicenses,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.location_on),
                          labelText: 'QUANTIDADE DE LICENÇAS',
                        ),
                      ));
                },
              ),
              Obx(
                () => Visibility(
                  visible: controller.paymentMethod == 'CARD',
                  child: SizedBox(
                    child: Column(mainAxisSize: MainAxisSize.max, children: [
                      const SizedBox(height: 10),
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
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o número do cartão';
                          }
                          value = value.replaceAll(
                              RegExp(r'\s+'), ''); // Remove espaços
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
                                return FormattedInputers.validateCardExpiryDate(
                                    value);
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
                          controller.nameCardController.value =
                              TextEditingValue(
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Digite seu cpf ou cnpj";
                          }
                          if (!Services.validCPF(value) &&
                              !Services.validCNPJ(value)) {
                            return "Digite um cpf ou cnpj válido";
                          }
                          return null;
                        },
                      ),
                    ]),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Obx(
                () => Visibility(
                  visible: (controller.paymentMethod.value == 'CARD' ||
                          controller.paymentMethod.value == 'PIX') &&
                      controller.showPaymentMethod.value,
                  child: TextButton(
                    onPressed: () {
                      controller.showCoupon(!controller.showCoupon.value);
                    },
                    child: Obx(
                      () => controller.isCouponApplied.value
                          ? const Text("CUPOM APLICADO!")
                          : Text(
                              "${controller.showCoupon.value ? 'Não tenho um ' : 'Tenho um '} cupom"),
                    ),
                  ),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: controller.showCoupon.value,
                  child: SizedBox(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: controller.isCouponApplied.value,
                            controller: controller.couponController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.currency_exchange),
                              labelText: 'CUPOM DE DESCONTO',
                            ),
                            onChanged: (text) {
                              controller.couponController.value =
                                  TextEditingValue(
                                text: text.toUpperCase(),
                                selection:
                                    controller.couponController.selection,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        controller.isCouponApplied.value
                            ? const SizedBox.shrink()
                            : TextButton(
                                onPressed: () async {
                                  Map<String, dynamic> retorno =
                                      await controller.validateCoupon();

                                  if (retorno["success"] == false) {
                                    Get.snackbar(
                                        'Falha!', retorno['message'].join('\n'),
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                        duration: const Duration(seconds: 2),
                                        snackPosition: SnackPosition.BOTTOM);
                                  }
                                },
                                child: const Text('Aplicar'),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Obx(() => Visibility(
                  visible: controller.paymentMethod == 'CARD',
                  child: SizedBox(
                    child: Row(
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

                            controller.showCoupon.value = false;
                            controller.showPaymentMethod.value = false;

                            if (retorno['success'] == true) {
                              controller.clearAllFields();
                              Get.offAllNamed(Routes.home);
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
                    ),
                  ))),
              const SizedBox(height: 20.0),
              Obx(
                () => Visibility(
                  visible: controller.paymentMethod == 'PIX',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(() {
                        final linkQrCode = controller.linkQrCode.value;
                        final codeCopyPaste = controller.codeCopyPaste.value;

                        if (linkQrCode.isNotEmpty) {
                          return Column(
                            children: [
                              const SizedBox(height: 10),
                              const Text(
                                "Aguardando pagamento...",
                                style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                "Caso haja cobrança e demore para atualizar o aplicativo. Saia do app e efetue login novamente.",
                                style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              // Exibição da imagem do QR Code
                              Image.network(
                                linkQrCode,
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Text(
                                    'Erro ao carregar o QR Code',
                                    style: TextStyle(color: Colors.red),
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                              // Texto e link para copiar
                              const Text(
                                'Link copia e cola:',
                                style: TextStyle(
                                  fontFamily: 'Inter-Bold',
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 5),
                              GestureDetector(
                                onTap: () {
                                  // Copia o link `codeCopyPaste` para a área de transferência
                                  Clipboard.setData(
                                      ClipboardData(text: codeCopyPaste));
                                  Get.snackbar(
                                    'Código Copiado!',
                                    'O código foi copiado para a área de transferência.',
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                    duration: const Duration(seconds: 2),
                                  );
                                },
                                child: Text(
                                  codeCopyPaste,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          );
                        }
                        return const SizedBox(); // Retorna um espaço vazio caso não haja URL
                      }),
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(() => Text(
                            'TOTAL: ${(FormattedInputers.formatValue(controller.calculatedPrice.value))}',
                            style: const TextStyle(
                                fontFamily: 'Inter-Black', fontSize: 18),
                          )),
                      const SizedBox(height: 20.0),
                      Visibility(
                        visible: !controller.isGeneratePix.value,
                        child: CustomElevatedButton(
                          onPressed: () async {
                            controller.isGeneratePix.value = false;

                            Map<String, dynamic> retorno =
                                await controller.createPix();

                            if (retorno['success'] == true) {
                              Get.snackbar('Sucesso!', retorno['message'],
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                  duration: const Duration(seconds: 2),
                                  snackPosition: SnackPosition.BOTTOM);
                              controller.showCoupon.value = false;
                              controller.showPaymentMethod.value = false;
                            } else {
                              Get.snackbar('Falha!', retorno['message'],
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
                              'GERAR QR CODE',
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'InterBold'),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
