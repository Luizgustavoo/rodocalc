// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/city_state_controller.dart';
import 'package:rodocalc/app/data/controllers/trip_controller.dart';
import 'package:rodocalc/app/data/models/trip_model.dart';
import 'package:rodocalc/app/utils/custom_elevated_button.dart';
import 'package:rodocalc/app/utils/formatter.dart';
import 'package:searchfield/searchfield.dart';

class CreateTripModal extends GetView<TripController> {
  CreateTripModal({super.key, required this.isUpdate, this.trip});

  final cityController = Get.put(CityStateController());

  final bool isUpdate;
  final Trip? trip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Form(
        key: controller.tripFormKey,
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
                  'LANÇAMENTO DE TRECHOS',
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

              // Dados de Saída
              const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 5),
                child: Text(
                  'DADOS DE SAÍDA',
                  style: TextStyle(
                      fontFamily: 'Inter-Bold',
                      fontSize: 13,
                      color: Colors.grey),
                ),
              ),
              TextFormField(
                controller: controller.tripNumberController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.numbers_rounded,
                  ),
                  labelText: 'NÚMERO DA VIAGEM',
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: controller.txtDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  counterText: '',
                  prefixIcon: Icon(
                    Icons.calendar_today,
                    size: 25,
                  ),
                  labelText: 'DATA E HORA DA SAÍDA',
                ),
                onTap: () async {
                  await controller.selectDateTime(controller.txtDateController);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a data e hora da despesa';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.txtKmInicialTrechoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  counterText: '',
                  prefixIcon: Icon(Icons.add_road_sharp),
                  labelText: 'KM INICIAL DO VEÍCULO',
                ),
                onChanged: (value) {
                  FormattedInputers.formatAndUpdateText(
                      controller.txtKmInicialTrechoController);
                },
              ),

              // Dados do Trecho
              const Padding(
                padding: EdgeInsets.only(top: 15, bottom: 5),
                child: Text(
                  'DADOS DO TRECHO',
                  style: TextStyle(
                      fontFamily: 'Inter-Bold',
                      fontSize: 13,
                      color: Colors.grey),
                ),
              ),
              Obx(
                () => SearchField<String>(
                  controller: controller.originController,
                  suggestions: cityController.listCities
                      .map((city) =>
                          SearchFieldListItem<String>(city.cidadeEstado!))
                      .toList(),
                  searchInputDecoration: InputDecoration(
                    labelText: cityController.isLoading.value
                        ? "CARREGANDO..."
                        : "ORIGEM",
                    hintText: "Digite o nome da cidade",
                  ),
                  onSuggestionTap: (suggestion) {
                    controller.originController.text = suggestion.searchKey;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, selecione a cidade';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              Obx(
                () => SearchField<String>(
                  controller: controller.destinyController,
                  suggestions: cityController.listCities
                      .map((city) =>
                          SearchFieldListItem<String>(city.cidadeEstado!))
                      .toList(),
                  searchInputDecoration: InputDecoration(
                    labelText: cityController.isLoading.value
                        ? "CARREGANDO..."
                        : "DESTINO",
                    hintText: "Digite o nome da cidade",
                  ),
                  onSuggestionTap: (suggestion) {
                    controller.destinyController.text = suggestion.searchKey;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, selecione a cidade';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.distanceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.social_distance_rounded,
                  ),
                  labelText: 'DISTÂNCIA EM KM',
                ),
              ),

              // Dados de Chegada
              const Padding(
                padding: EdgeInsets.only(top: 15, bottom: 5),
                child: Text(
                  'DADOS DE CHEGADA',
                  style: TextStyle(
                      fontFamily: 'Inter-Bold',
                      fontSize: 13,
                      color: Colors.grey),
                ),
              ),
              TextFormField(
                controller: controller.txtDateFinishedController,
                readOnly: true,
                decoration: const InputDecoration(
                  counterText: '',
                  prefixIcon: Icon(
                    Icons.calendar_today,
                    size: 25,
                  ),
                  labelText: 'DATA E HORA CHEGADA',
                ),
                onTap: () async {
                  await controller
                      .selectDateTime(controller.txtDateFinishedController);
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.txtKmFinalTrechoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  counterText: '',
                  prefixIcon: Icon(Icons.add_road_sharp),
                  labelText: 'KM FINAL DO VEÍCULO',
                ),
                onChanged: (value) {
                  FormattedInputers.formatAndUpdateText(
                      controller.txtKmFinalTrechoController);
                },
              ),
              const SizedBox(height: 10),

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
                  isUpdate && trip!.situacao!.toUpperCase() == "CLOSE"
                      ? const SizedBox.shrink()
                      : Obx(() {
                          return controller.isLoadingCRUD.value
                              ? const CircularProgressIndicator()
                              : CustomElevatedButton(
                                  onPressed: () async {
                                    if (controller.tripFormKey.currentState!
                                        .validate()) {
                                      Map<String, dynamic> retorno = isUpdate
                                          ? await controller
                                              .updateTrip(trip!.id!)
                                          : await controller.insertTrip();

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
