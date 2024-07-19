import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/home_controller.dart';

class CustomStackCard extends StatelessWidget {
  final HomeController controller = Get.find();

  CustomStackCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 32, left: 32, top: 5),
      child: Card(
        color: Colors.black.withOpacity(0.8),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Bem vindo, Claudinei',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(height: 5),
              Text(
                'Veículo selecionado:',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              Text(
                'SCANIA - P360 BITRUCK - CARROCERIA 9MTS',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
