import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/plan_controller.dart';
import 'package:rodocalc/app/routes/app_routes.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class WidgetPlan extends StatelessWidget {
  const WidgetPlan(
      {super.key,
      required this.titulo,
      required this.data,
      required this.planController});

  final String titulo;
  final String data;
  final PlanController planController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      color: const Color.fromARGB(255, 110, 110, 110),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter-Bold',
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                data,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter-Regular',
                  fontSize: 10,
                ),
              ),
            ],
          ),
          ServiceStorage.getUserTypeId() == 4
              ? const SizedBox.shrink()
              : ElevatedButton(
                  onPressed: () async {
                    await planController.getAll();
                    await planController.getMyPlans();
                    if (planController.myPlans.isEmpty) {
                      Get.toNamed(Routes.plan);
                    } else {
                      Get.toNamed(Routes.newplanview);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'VER PLANOS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
