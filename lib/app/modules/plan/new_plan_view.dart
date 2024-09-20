import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/plan_controller.dart';
import 'package:rodocalc/app/global/custom_app_bar.dart';
import 'package:rodocalc/app/modules/plan/widgets/update_plan_modal.dart';
import 'package:rodocalc/app/utils/custom_elevated_button.dart';
import 'package:rodocalc/app/utils/formatter.dart';

class NewPlanView extends GetView<PlanController> {
  const NewPlanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'MEU PLANO'),
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.darken,
              ),
              child: Image.asset(
                'assets/images/signup.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Obx(() {
              if (controller.myPlans.isEmpty) {
                return const CircularProgressIndicator();
              } else {
                final userPlan = controller.myPlans.first;

                final plano = controller.listPlans.first;
                return Container(
                  width: Get.width / 1.1,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        userPlan.plano!.descricao!,
                        style: const TextStyle(
                            fontSize: 28, fontFamily: 'Inter-Bold'),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "R\$ ${FormattedInputers.formatValuePTBR(userPlan.plano!.valor)}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'Inter-Regular',
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        " ${userPlan.plano!.status == 1 ? 'ATIVO' : 'INATIVO'}",
                        style: TextStyle(
                            fontSize: 16,
                            color: userPlan.plano!.status == 1
                                ? Colors.green
                                : Colors.red,
                            fontFamily: 'Inter-Black'),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "ASSINATURA:",
                            style: TextStyle(fontFamily: 'Inter-Bold'),
                          ),
                          Text(
                            FormattedInputers.formatApiDate(
                                userPlan.dataAssinaturaPlano.toString()),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "PRÓXIMO VENCIMENTO:",
                            style: TextStyle(fontFamily: 'Inter-Bold'),
                          ),
                          Text(
                            FormattedInputers.formatApiDate(
                                userPlan.dataVencimentoPlano.toString()),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "LICENÇAS:",
                            style: TextStyle(fontFamily: 'Inter-Bold'),
                          ),
                          Text("${userPlan.quantidadeLicencas} LICENÇAS"),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "CARTÃO:",
                            style: TextStyle(fontFamily: 'Inter-Black'),
                          ),
                          Text(
                            '**** - **** - **** - ****',
                            style: TextStyle(fontFamily: 'Inter-Black'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      CustomElevatedButton(
                        width: Get.width / 1,
                        onPressed: () {
                          controller.clearAllFields();

                          showModalBottomSheet(
                            context: context,
                            builder: (_) => UpdatePlanModal(
                              plano: userPlan,
                              isUpdate: true,
                            ),
                            isScrollControlled: true,
                          );
                        },
                        child: const Text(
                          "ALTERAR",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      CustomElevatedButton(
                        width: Get.width / 1,
                        gradient: LinearGradient(colors: [
                          Colors.red.shade900,
                          Colors.red.shade300,
                        ]),
                        onPressed: () {
                          showDialogCancelSubscription(context,
                              userPlan.assignatureId.toString(), controller);
                        },
                        child: const Text(
                          "CANCELAR ASSINATURA",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                );
              }
            }),
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
    titleStyle: const TextStyle(fontFamily: 'Inter-Bold'),
    content: const Text(
      textAlign: TextAlign.center,
      "Tem certeza que deseja cancelar o plano selecionado?",
      style: TextStyle(
        fontFamily: 'Inter-Regular',
        fontSize: 18,
      ),
    ),
    actions: [
      TextButton(
        onPressed: () {
          Get.back();
        },
        child: const Text(
          "CANCELAR",
          style: TextStyle(fontFamily: 'Poppinss'),
        ),
      ),
      ElevatedButton(
        onPressed: () async {
          Map<String, dynamic> retorno =
              await controller.cancelSubscribe(idSubscription);

          if (retorno['success'] == true) {
            Get.back();
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
    ],
  );
}
