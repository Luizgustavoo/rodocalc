import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/plan_controller.dart';
import 'package:rodocalc/app/data/models/user_plan_model.dart';
import 'package:rodocalc/app/global/custom_app_bar.dart';
import 'package:rodocalc/app/modules/plan/widgets/manage_plan_card.dart';
import 'package:rodocalc/app/utils/formatter.dart';

class ManagePlanView extends GetView<PlanController> {
  const ManagePlanView({super.key});

  @override
  Widget build(BuildContext context) {
    RxList<UserPlan> myPlans = <UserPlan>[].obs;
    if (Get.arguments != null && Get.arguments is List<UserPlan>) {
      myPlans.value = Get.arguments as List<UserPlan>;
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'MEUS PLANOS'),
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
          SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height,
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    margin: const EdgeInsets.all(12.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(children: [
                        const SizedBox(height: 5),
                        Obx(() {
                          if (myPlans.isEmpty) {
                            return const Expanded(
                                child: Center(
                              child: Text(
                                  'Nenhum Plano encontrado para o seu usuário!'),
                            ));
                          }
                          return Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: myPlans.length,
                              itemBuilder: (context, index) {
                                final UserPlan plan = myPlans[index];
                                return ManagePlanCard(
                                  plano: plan.id!,
                                  controller: controller,
                                  titulo:
                                      "PLANO ${plan.plano!.descricao.toString()}",
                                  descricao:
                                      "${plan.quantidadeLicencas.toString()} licença(s) ativas",
                                  vencimento:
                                      "${FormattedInputers.formatApiDate(plan.dataVencimentoPlano.toString())}",
                                  valor: 'R\$250,00',
                                  vehicles: plan.veiculos!,
                                );
                              },
                            ),
                          );
                        })
                      ]),
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
