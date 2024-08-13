import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/plan_controller.dart';
import 'package:rodocalc/app/data/models/plan_model.dart';
import 'package:rodocalc/app/global/custom_app_bar.dart';
import 'package:rodocalc/app/modules/plan/widgets/create_plan_modal.dart';
import 'package:rodocalc/app/modules/plan/widgets/custom_plan_card.dart';
import 'package:rodocalc/app/utils/formatter.dart';

class PlanView extends GetView<PlanController> {
  const PlanView({super.key});

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
                    color: Color(0xFFFF7B28),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Meu plano atual:',
                        style: TextStyle(
                          fontFamily: 'Inter-Regular',
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                            () => Text(
                              controller.myPlan.value!.plano!.descricao!,
                              style: const TextStyle(
                                fontFamily: 'Inter-Black',
                                color: Colors.black,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          Obx(
                            () => Text(
                              "Assinatura: ${FormattedInputers.formatApiDate(controller.myPlan.value!.dataAssinaturaPlano!)}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Obx(
                            () => Text(
                              "Vencimento: ${FormattedInputers.formatApiDate(controller.myPlan.value!.dataVencimentoPlano!)}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Obx(() => Text(
                                '${controller.myPlan.value!.quantidadeLicencas!} licença(s)',
                                style: const TextStyle(
                                  fontFamily: 'Inter-Regular',
                                  color: Colors.black,
                                  fontSize: 16.0,
                                ),
                              )),
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
