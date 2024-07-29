import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/home_controller.dart';
import 'package:rodocalc/app/data/models/vehicle_model.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class CustomStackCard extends StatelessWidget {
  final HomeController controller = Get.find();

  CustomStackCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 32, left: 32, top: 5),
      child: Card(
        color: Colors.black.withOpacity(0.8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Bem vindo, Claudinei',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(height: 5),
              const Text(
                'Veículo selecionado:',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              Text(
                ServiceStorage.titleSelectedVehicle(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
