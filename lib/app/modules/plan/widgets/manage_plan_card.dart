import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/plan_controller.dart';
import 'package:rodocalc/app/data/models/planos_alter_drop_down_model.dart';

import '../../../data/models/user_plan_model.dart';
import '../../../utils/formatter.dart';

class ManagePlanCard extends StatelessWidget {
  const ManagePlanCard({
    super.key,
    required this.controller,
    required this.userPlan,
  });

  final PlanController controller;
  final UserPlan userPlan;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade200,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: ExpansionTile(
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            showDialogCancelSubscription(
                context, userPlan.assignatureId.toString(), controller);
          },
          icon: Obx(() => controller.isLoadingSubscrible.value
              ? CircularProgressIndicator()
              : const Icon(
                  Icons.delete,
                  color: Colors.red,
                )),
        ),
        tilePadding: const EdgeInsets.all(12),
        childrenPadding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 21,
                  color: Colors.black,
                  fontFamily: 'Inter-Regular',
                ),
                children: [
                  TextSpan(
                    text: "PLANO ${userPlan.plano!.descricao!}",
                    style: const TextStyle(
                      fontFamily: 'Inter-Bold',
                    ),
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontFamily: 'Inter-Regular',
                ),
                children: [
                  const TextSpan(
                    style: TextStyle(
                      fontFamily: 'Inter-Bold',
                    ),
                  ),
                  TextSpan(
                      text:
                          "${userPlan.quantidadeLicencas.toString()} licença(s) ativas"),
                ],
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontFamily: 'Inter-Regular',
                ),
                children: [
                  const TextSpan(
                    text: 'VENCIMENTO: ',
                    style: TextStyle(
                      fontFamily: 'Inter-Bold',
                    ),
                  ),
                  TextSpan(
                      text:
                          "${FormattedInputers.formatApiDate(userPlan.dataVencimentoPlano.toString())}"),
                ],
              ),
            ),
          ],
        ),
        children: userPlan.veiculos != null && userPlan.veiculos!.isNotEmpty
            ? userPlan.veiculos!.map((vehicle) {
                return Card(
                  color: Colors.white,
                  child: ListTile(
                    title: Text(vehicle!.modelo!),
                    trailing: IconButton(
                      onPressed: () {
                        controller.getAllPlansAlterPlanDropDown(userPlan.id!);

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            String?
                                selectedOption; // Variável para armazenar a opção selecionada
                            return AlertDialog(
                              title: const Text(
                                'Alterar plano do veículo selecionado.',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Obx(
                                    () => DropdownButtonFormField<int?>(
                                      decoration: const InputDecoration(
                                        labelText: 'Plano',
                                      ),
                                      items: [
                                        const DropdownMenuItem<int?>(
                                          value: 0,
                                          child: Text('Selecione um plano'),
                                        ),
                                        ...controller.myPlansDropDownUpdate
                                            .map((AlterPlanDropDown plan) {
                                          // Verifique se plan.id é nulo e use um valor padrão se necessário
                                          if (plan.id == null) {
                                            return DropdownMenuItem<int?>(
                                              value: null,
                                              // Ou qualquer outro valor que não conflite
                                              child: Text(plan.plano ??
                                                  'Descrição não disponível'),
                                            );
                                          }

                                          return DropdownMenuItem<int?>(
                                            value: plan.id,
                                            child: Container(
                                              constraints: BoxConstraints(
                                                  maxWidth: Get.width * .7),
                                              child: Text(
                                                "${plan.plano}",
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          );
                                        }),
                                      ],
                                      onChanged: (newValue) {
                                        controller.selectedPlanDropDown.value =
                                            newValue!;
                                      },
                                      value: null,
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Por favor, selecione um plano';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Fecha o diálogo
                                  },
                                  child: Text('Cancelar'),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (controller.selectedPlanDropDown.value >
                                        0) {
                                      Map<String, dynamic> retorno =
                                          await controller.updatePlanVehicle(
                                              vehicle.id!,
                                              controller
                                                  .selectedPlanDropDown.value);

                                      if (retorno['success'] == true) {
                                        Get.back();
                                        Get.snackbar('Sucesso!',
                                            retorno['message'].join('\n'),
                                            backgroundColor: Colors.green,
                                            colorText: Colors.white,
                                            duration:
                                                const Duration(seconds: 2),
                                            snackPosition:
                                                SnackPosition.BOTTOM);
                                      } else {
                                        Get.snackbar('Falha!',
                                            retorno['message'].join('\n'),
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                            duration:
                                                const Duration(seconds: 2),
                                            snackPosition:
                                                SnackPosition.BOTTOM);
                                      }
                                    } else {
                                      Get.snackbar(
                                          'Falha!', "Selecione um plano!",
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                          duration: const Duration(seconds: 2),
                                          snackPosition: SnackPosition.BOTTOM);
                                    }
                                  },
                                  child: const Text(
                                    "CONFIRMAR",
                                    style: TextStyle(
                                        fontFamily: 'Poppinss',
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.red.shade500,
                      ),
                    ),
                  ),
                );
              }).toList()
            : [
                ListTile(
                  title: Text('Nenhum veículo disponível'),
                ),
              ],
      ),
    );
  }
}

void showDialogCancelSubscription(
    context, String idSubscription, PlanController controller) {
  Get.defaultDialog(
    titlePadding: const EdgeInsets.all(16),
    contentPadding: const EdgeInsets.all(16),
    title: "Confirmação",
    content: const Text(
      textAlign: TextAlign.center,
      "Tem certeza que deseja cancelar o plano selecionado?",
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 18,
      ),
    ),
    actions: [
      ElevatedButton(
        onPressed: () async {
          Map<String, dynamic> retorno =
              await controller.cancelSubscribe(idSubscription);

          if (retorno['success'] == true) {
            Get.back();
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
        child: const Text(
          "CONFIRMAR",
          style: TextStyle(fontFamily: 'Poppinss', color: Colors.white),
        ),
      ),
      TextButton(
        onPressed: () {
          Get.back();
        },
        child: const Text(
          "CANCELAR",
          style: TextStyle(fontFamily: 'Poppinss'),
        ),
      ),
    ],
  );
}
