import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/plan_controller.dart';
import 'package:rodocalc/app/utils/custom_elevated_button.dart';
import 'package:rodocalc/app/utils/formatter.dart';
import 'package:rodocalc/app/utils/services.dart';

class CreatePlanModal extends GetView<PlanController> {
  const CreatePlanModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: controller.planKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() => Text(
                    controller.selectedPlan.value?['name'] ?? '',
                    style: const TextStyle(
                        fontFamily: 'Inter-Bold',
                        fontSize: 17,
                        color: Color(0xFFFF6B00)),
                  )),
              const Divider(
                endIndent: 20,
                indent: 20,
                height: 5,
                thickness: 2,
                color: Colors.black,
              ),
              const SizedBox(height: 15),
              Obx(
                () => DropdownButtonFormField<int>(
                  value: controller.selectedLicenses.value,
                  items: List.generate(
                    10,
                    (index) => DropdownMenuItem(
                      value: index + 1,
                      child: Text('${index + 1} Licença(s)'),
                    ),
                  ),
                  onChanged: controller.updateLicenses,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.location_on),
                    labelText: 'LICENÇAS',
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              TextFormField(
                controller: controller.numberCardController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.credit_card),
                    labelText: 'NUMERO DO CARTÃO',
                    counterText: ''),
                keyboardType: TextInputType.number,
                maxLength: 19,
                onChanged: (value) {
                  controller.numberCardController.text =
                      controller.formatCardNumber(value);
                  controller.numberCardController.selection =
                      TextSelection.fromPosition(TextPosition(
                          offset: controller.numberCardController.text.length));
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller.validateController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.date_range),
                        labelText: 'VALIDADE',
                      ),
                      keyboardType: TextInputType.number,
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
                        'TOTAL: ${controller.calculatedPrice.value}',
                        style: const TextStyle(
                            fontFamily: 'Inter-Black', fontSize: 18),
                      )),
                  CustomElevatedButton(
                      onPressed: () {},
                      child: const Text(
                        'CONTRATAR',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'InterBold'),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
