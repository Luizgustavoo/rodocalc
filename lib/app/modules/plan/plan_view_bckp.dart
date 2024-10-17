import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/plan_controller.dart';
import 'package:rodocalc/app/data/models/plan_model.dart';
import 'package:rodocalc/app/global/custom_app_bar.dart';
import 'package:rodocalc/app/modules/plan/widgets/create_plan_modal.dart';
import 'package:rodocalc/app/modules/plan/widgets/custom_plan_card.dart';
import 'package:rodocalc/app/routes/app_routes.dart';
import 'package:rodocalc/app/utils/formatter.dart';

class PlanViewOld extends GetView<PlanController> {
  const PlanViewOld({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'PLANOS'),
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
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // Card fixo no topo
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 80, 78, 77),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.only(bottom: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Obx(
                                  () => Text(
                                    controller.myPlans.length <= 1
                                        ? 'Meu Plano Ativo'
                                        : 'Meus Planos Ativos',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontFamily: 'Inter-Regular',
                                      color: Colors.black,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                Obx(() {
                                  if (controller.myPlans.isEmpty) {
                                    return const Text(
                                      textAlign: TextAlign.center,
                                      'Nenhum plano disponível',
                                      style: TextStyle(
                                        fontFamily: 'Inter-Black',
                                        color: Colors.white,
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }

                                  return Column(
                                    children: controller.myPlans.map((plan) {
                                      final planDescription =
                                          plan.plano?.descricao;
                                      final dataVencimentoPlano =
                                          plan.dataVencimentoPlano;

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            planDescription != null
                                                ? planDescription.toUpperCase()
                                                : 'Descrição não disponível',
                                            style: const TextStyle(
                                              fontFamily: 'Inter-Black',
                                              color: Colors.white,
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            dataVencimentoPlano != null
                                                ? "Vencimento: ${FormattedInputers.formatApiDate(dataVencimentoPlano)}"
                                                : "Data de vencimento não disponível",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Inter_Regular',
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(height: 8.0),
                                          // Espaçamento entre os planos
                                        ],
                                      );
                                    }).toList(),
                                  );
                                }),
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: TextButton(
                                onPressed: () {
                                  controller.getMyPlans();
                                  Get.toNamed(Routes.manageplan);
                                },
                                child: const Text(
                                  'GERENCIAR',
                                  style: TextStyle(
                                      color: Colors.black,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold),
                                ),
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
                // Conteúdo rolável
                Expanded(
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Obx(
                        () => ListView.builder(
                          itemCount: controller.listPlans.length,
                          itemBuilder: (context, index) {
                            final Plan plan = controller.listPlans[index];
                            return CustomPlanCard(
                              corCard: plan.corCard,
                              corTexto: plan.corTexto,
                              minLicencas: plan.minLicencas,
                              name: plan.descricao,
                              description: plan.observacoes,
                              price:
                                  "R\$ ${FormattedInputers.formatValuePTBR(plan.valor)}",
                              onPressed: () {
                                controller.updateSelectedPlan(plan);
                                showModalBottomSheet(
                                  context: context,
                                  builder: (_) => const CreatePlanModal(),
                                  isScrollControlled: true,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
