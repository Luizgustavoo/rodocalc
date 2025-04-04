// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/city_state_controller.dart';
import 'package:rodocalc/app/data/controllers/trip_controller.dart';
import 'package:rodocalc/app/data/models/charge_type_model.dart';
import 'package:rodocalc/app/data/models/trip_model.dart';
import 'package:rodocalc/app/data/models/viagens_model.dart';
import 'package:rodocalc/app/utils/custom_elevated_button.dart';
import 'package:rodocalc/app/utils/formatter.dart';
import 'package:rodocalc/app/utils/services.dart';
import 'package:searchfield/searchfield.dart';

class CreateTripModal extends GetView<TripController> {
  CreateTripModal(
      {super.key, required this.isUpdate, this.trip, required this.travel});

  final cityController = Get.put(CityStateController());

  final bool isUpdate;
  final Trip? trip;

  final Viagens travel;

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

              const SizedBox(height: 15),
              // Dados do Trecho

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
              const SizedBox(height: 15),
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
              const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 5),
                child: Text(
                  'DADOS DO VEÍCULO',
                  style: TextStyle(
                      fontFamily: 'Inter-Bold',
                      fontSize: 13,
                      color: Colors.grey),
                ),
              ),

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
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: controller.txtToneladasTrechoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  counterText: '',
                  prefixIcon: Icon(Icons.add_road_sharp),
                  labelText: 'TONELADAS',
                ),
                onChanged: (value) {
                  FormattedInputers.formatAndUpdateText(
                      controller.txtToneladasTrechoController);
                },
              ),
              const SizedBox(height: 15),
              Obx(() {
                if (controller.isLoadingChargeTypes.value) {
                  return DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.sort_by_alpha_rounded,
                      ),
                      labelText: 'TIPO DE CARGA',
                    ),
                    items: const [
                      DropdownMenuItem<int>(
                        value: null,
                        child: Text('Carregando...'),
                      ),
                    ],
                    onChanged: null, // Desabilitar mudanças enquanto carrega
                  );
                } else if (controller.listChargeTypes.isNotEmpty) {
                  return DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.search_rounded,
                      ),
                      labelText: 'TIPO DE CARGA',
                    ),
                    items: [
                      DropdownMenuItem<int>(
                        value: null,
                        child: SizedBox(
                          width: Get.width * 0.7,
                          child: const Text(
                            'SELECIONE OU CADASTRE UM TIPO',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Color(0xFFFF6B00)),
                          ),
                        ),
                      ),
                      ...controller.listChargeTypes.map((ChargeType charge) {
                        return DropdownMenuItem<int>(
                          value: charge.id,
                          child: Text(
                            Services.capitalizeWords(charge.descricao!),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontFamily: 'Inter-Bold',
                                color: Colors.black54),
                          ),
                        );
                      }),
                      DropdownMenuItem<int>(
                        value: 0,
                        child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            child: TextButton(
                              onPressed: () {
                                controller.selectedCategory.value = null;
                                controller.clearDescriptionModal();
                                Get.back();
                                showSpecificTypeModal(context);
                              },
                              child: const Text(
                                "CADASTRAR NOVO TIPO...",
                                style: TextStyle(
                                    color: Color(0xFFFF6B00),
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    onChanged: (newValue) {
                      controller.selectedCargoType.value = newValue;
                    },
                    value: controller.selectedCargoType.value,
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor, selecione o tipo de carga';
                      }
                      return null;
                    },
                  );
                } else {
                  return DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.sort_by_alpha_rounded,
                      ),
                      labelText: 'TIPO DE CARGA',
                    ),
                    items: const [
                      DropdownMenuItem<int>(
                        value: null,
                        child: Text('Nenhum tipo encontrado!'),
                      ),
                    ],
                    onChanged:
                        null, // Desabilitar mudanças se nenhum tipo estiver disponível
                  );
                }
              }),
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
              const SizedBox(height: 15),
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
                                          ? await controller.updateTrip(
                                              trip!.id!, travel.id!)
                                          : await controller
                                              .insertTrip(travel.id!);

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

  void showSpecificTypeModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                8.0), // Aqui você pode ajustar o valor para o raio desejado
          ),
          title: const Column(
            children: [
              Text(
                'CADASTRAR TIPO DE CARGA',
                style: TextStyle(
                  fontFamily: 'Inter-bold',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF6B00),
                ),
              ),
              Divider(
                endIndent: 10,
                indent: 10,
                height: 5,
                thickness: 2,
                color: Colors.black45,
              ),
              SizedBox(height: 10),
            ],
          ),
          content: Form(
            key: controller.formkeyChargeType,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormField(
              controller: controller.txtChargeTypeController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.message_outlined),
                labelText: 'DESCRIÇÃO',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira a descrição';
                }
                return null;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CANCELAR'),
            ),
            CustomElevatedButton(
              onPressed: () async {
                Map<String, dynamic> retorno =
                    await controller.insertChargeType();

                if (retorno['success'] == true) {
                  Get.back();
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
                'SALVAR',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
