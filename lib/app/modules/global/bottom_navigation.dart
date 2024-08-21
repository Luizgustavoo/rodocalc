import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/routes/app_routes.dart';

class WidgetPlan extends StatelessWidget {
  const WidgetPlan({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      color: Colors.red,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'PLANO ATUAL: AVALIAÇÃO',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter-Bold',
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'EXPIRA DIA 27/08/2024',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter-Regular',
                  fontSize: 10,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Get.toNamed(Routes.plan);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
