// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/city_state_controller.dart';
import 'package:rodocalc/app/data/controllers/trip_controller.dart';
import 'package:rodocalc/app/data/models/viagens_model.dart';
import 'package:rodocalc/app/utils/custom_elevated_button.dart';

class CreateTravelModal extends GetView<TripController> {
  CreateTravelModal({super.key, required this.isUpdate, this.travel});

  final cityController = Get.put(CityStateController());

  final bool isUpdate;
  final Viagens? travel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Form(
        key: controller.viagensFormKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 5),
                child: Text(
                  'LANÇAMENTO DE VIAGENS',
                  style: TextStyle(
                      fontFamily: 'Inter-Bold',
                      fontSize: 17,
                      color: Color(0xFFFF6B00)),
                ),
              ),
              const Divider(
                endIndent: 20,
                indent: 20,
                height: 5,
                thickness: 2,
                color: Colors.black,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: controller.tituloViagensController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.numbers_rounded,
                  ),
                  labelText: 'TÍTULO DA VIAGEM',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Titulo é obrigatório!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: controller.numeroViagemController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.numbers_rounded,
                  ),
                  labelText: 'NÚMERO DA VIAGEM',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Número da viagem é obrigatório!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 120,
                    child: TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text(
                          'CANCELAR',
                          style: TextStyle(
                              fontFamily: 'Inter-Bold',
                              color: Color(0xFFFF6B00)),
                        )),
                  ),
                  const SizedBox(width: 10),
                  isUpdate && travel!.situacao!.toUpperCase() == "CLOSED"
                      ? const SizedBox.shrink()
                      : Obx(() {
                          return controller.isLoadingCRUDViagens.value
                              ? const CircularProgressIndicator()
                              : CustomElevatedButton(
                                  onPressed: () async {
                                    if (controller.viagensFormKey.currentState!
                                        .validate()) {
                                      Map<String, dynamic> retorno = isUpdate
                                          ? await controller
                                              .updateViagens(travel!.id!)
                                          : await controller.insertViagens();

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
                                    }
                                  },
                                  child: const Text(
                                    'SALVAR',
                                    style: TextStyle(
                                        fontFamily: 'Inter-Bold',
                                        color: Colors.white),
                                  ),
                                );
                        }),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
