import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/login_controller.dart';
import 'package:rodocalc/app/data/controllers/plan_controller.dart';
import 'package:rodocalc/app/global/custom_app_bar.dart';
import 'package:rodocalc/app/modules/plan/widgets/update_plan_modal.dart';
import 'package:rodocalc/app/routes/app_routes.dart';
import 'package:rodocalc/app/utils/custom_elevated_button.dart';
import 'package:rodocalc/app/utils/formatter.dart';

class NewPlanView extends GetView<PlanController> {
  const NewPlanView({super.key});

  @override
  Widget build(BuildContext context) {
    // RxString mensagem = ''.obs;

    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   String status = message.data['status'] ?? '';

    //   mensagem.value = status.isNotEmpty
    //       ? status
    //       : message.notification?.body ?? 'Sem mensagem';

    //   if (status == 'paid') {
    //     Get.find<PlanController>().updateStorageUserPlan();
    //     Get.offAllNamed(Routes.home);
    //   }
    // });

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

                // Inside the Obx widget:
                final now = DateTime.now();
                final expirationDate =
                    DateTime.parse(userPlan.dataVencimentoPlano.toString());

// Ajusta as datas para considerar apenas o dia, mês e ano
                final nowWithoutTime = DateTime(now.year, now.month, now.day);
                final expirationDateWithoutTime = DateTime(expirationDate.year,
                    expirationDate.month, expirationDate.day);

// Calcula a diferença entre as datas
                final difference =
                    expirationDateWithoutTime.difference(nowWithoutTime).inDays;

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
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            letterSpacing: .5,
                            fontSize: 28,
                            fontFamily: 'Inter-Bold'),
                      ),
                      Divider(
                        thickness: 2,
                        color: Colors.orange.shade500,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "R\$ ${FormattedInputers.formatValuePTBR(userPlan.plano!.valor)}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'Inter-Bold',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "PAGAMENTO VIA:",
                            style: TextStyle(fontFamily: 'Inter-Black'),
                          ),
                          Text(
                            userPlan.pix == 1 ? 'PIX' : 'Cartão de creédito',
                            style: const TextStyle(fontFamily: 'Inter-Black'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      userPlan.pix == 1
                          ? const SizedBox.shrink()
                          : CustomElevatedButton(
                              width: Get.width / 1,
                              onPressed: () {
                                controller.clearAllFields();
                                controller.licensePrice.value =
                                    userPlan.plano!.valor!;
                                controller.isLoadingSubscrible.value = false;

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
                        gradient: const LinearGradient(colors: [
                          Color.fromARGB(255, 4, 157, 53),
                          Color.fromARGB(255, 3, 109, 35),
                        ]),
                        onPressed: () {
                          Get.toNamed(Routes.plan);
                        },
                        child: const Text(
                          "RENOVAR CONTRATAÇAO",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () {
                          showDialogCancelSubscription(context,
                              userPlan.assignatureId.toString(), controller);
                        },
                        child: const Text(
                          "Cancelar assinatura",
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        ),
                      )
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

          Get.back();
          if (retorno['success'] == true) {
            final loginController = Get.put(LoginController());
            loginController.logout();
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
