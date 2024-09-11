// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/city_state_controller.dart';
import 'package:rodocalc/app/data/controllers/freight_controller.dart';
import 'package:rodocalc/app/data/models/freight_model.dart';
import 'package:rodocalc/app/utils/custom_elevated_button.dart';
import 'package:rodocalc/app/utils/formatter.dart';
import 'package:searchfield/searchfield.dart';

class CreateFreightModal extends GetView<FreightController> {
  CreateFreightModal({super.key, required this.isUpdate, this.freight});

  final bool isUpdate;
  final Freight? freight;

  final cityController = Get.put(CityStateController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Form(
          key: controller.freightKey,
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
                    'CALCULADORA DE FRETE',
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
                  controller: controller.valueReceiveController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.paid,
                    ),
                    labelText: 'VALOR A RECEBER',
                  ),
                  onChanged: (value) {
                    FormattedInputers.onformatValueChanged(
                        value, controller.valueReceiveController);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o valor';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Obx(
                  () => SearchField<String>(
                    controller: controller.originController,
                    suggestions: cityController.listCities
                        .map((city) =>
                            SearchFieldListItem<String>(city.cidadeEstado!))
                        .toList(),
                    searchInputDecoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      labelText: cityController.isLoading.value
                          ? "CARREGANDO"
                          : "ORIGEM",
                      hintText: "Digite o nome da cidade de origem",
                    ),
                    onSuggestionTap: (suggestion) {
                      controller.originController.text = suggestion.searchKey;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, selecione a origem';
                      }
                      // Verifica se a cidade está na lista de sugestões
                      bool isValidCity = cityController.listCities
                          .any((city) => city.cidadeEstado == value);
                      if (!isValidCity) {
                        return 'Cidade não encontrada na lista';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => SearchField<String>(
                    controller: controller.destinyController,
                    suggestions: cityController.listCities
                        .map((city) =>
                            SearchFieldListItem<String>(city.cidadeEstado!))
                        .toList(),
                    searchInputDecoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      labelText: cityController.isLoading.value
                          ? "CARREGANDO"
                          : "DESTINO",
                      hintText: "Digite o nome da cidade de destino",
                    ),
                    onSuggestionTap: (suggestion) {
                      controller.destinyController.text = suggestion.searchKey;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, selecione o destino';
                      }
                      // Verifica se a cidade está na lista de sugestões
                      bool isValidCity = cityController.listCities
                          .any((city) => city.cidadeEstado == value);
                      if (!isValidCity) {
                        return 'Cidade não encontrada na lista';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: controller.priceTollsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.money_off,
                    ),
                    labelText: 'VALOR DE PEDÁGIOS',
                  ),
                  onChanged: (value) {
                    FormattedInputers.onformatValueChanged(
                        value, controller.priceTollsController);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o preço de todos os pedagios';
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a distância';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                    controller: controller.averageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.straighten_rounded,
                      ),
                      labelText: 'MÉDIA KM/L DO CAMINHÃO',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a média km/l';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      FormattedInputers.onformatValueChangedDecimal(
                          value, controller.averageController);
                    }),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.priceDieselController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.local_gas_station_rounded,
                    ),
                    labelText: 'PREÇO/LITRO DIESEL',
                  ),
                  onChanged: (value) {
                    FormattedInputers.onformatValueChanged(
                        value, controller.priceDieselController);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o preço/l';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.totalTiresController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.tire_repair_rounded,
                    ),
                    labelText: 'TOTAL PNEUS (CAVALO + REBOQUE)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o total de pneus';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.priceTiresController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.paid,
                    ),
                    labelText: 'PREÇO PAGO NOS PNEUS',
                  ),
                  onChanged: (value) {
                    FormattedInputers.onformatValueChanged(
                        value, controller.priceTiresController);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o preço';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.othersExpensesController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.paid,
                    ),
                    labelText: 'OUTROS GASTOS',
                  ),
                  onChanged: (value) {
                    FormattedInputers.onformatValueChanged(
                        value, controller.othersExpensesController);
                  },
                ),
                const SizedBox(height: 16),
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
                    CustomElevatedButton(
                      onPressed: () async {
                        if (controller.freightKey.currentState!.validate()) {
                          Map<String, dynamic> retorno = isUpdate
                              ? await controller
                                  .calculateFreightUpdate(freight!)
                              : await controller.calculateFreight();

                          if (retorno['success'] == true) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Resultado do cálculo:'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: [
                                        Text(
                                          "Você irá lucrar: R\$${FormattedInputers.formatValuePTBR(retorno['lucro'])}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.green.shade900),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('OK'),
                                      onPressed: () {
                                        controller.clearAllFields();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            Get.snackbar(
                                'Falha!', retorno['message'].join('\n'),
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 2),
                                snackPosition: SnackPosition.BOTTOM);
                          }
                        }
                      },
                      child: const Text(
                        'CALCULAR',
                        style: TextStyle(
                            fontFamily: 'Inter-Bold', color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
