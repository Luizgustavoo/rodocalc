import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/comission_indicator_controller.dart';
import 'package:rodocalc/app/data/controllers/indicator_controller.dart';
import 'package:rodocalc/app/data/models/indication_model.dart';
import 'package:rodocalc/app/global/custom_app_bar.dart';
import 'package:rodocalc/app/modules/global/custom_search_field.dart';
import 'package:rodocalc/app/modules/indicator/widgets/custom_my_indications_card.dart';
import 'package:rodocalc/app/utils/service_storage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/user_model.dart';

class MyIndicationsView extends GetView<IndicationController> {
  MyIndicationsView({super.key});

  final comissionIndicatorController = Get.put(ComissionIndicatorController());

  @override
  Widget build(BuildContext context) {
    String cupom = ServiceStorage.getUserCupom().toString();
    return Scaffold(
      appBar: const CustomAppBar(title: 'ASSINANTES'),
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
                RefreshIndicator(
                  onRefresh: () async {
                    controller.searchIndicatorController.clear();
                    controller.listIndications.clear();
                    controller.getAll();
                  },
                  child: SizedBox(
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
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 5),
                            Card(
                              color: const Color(0xff4f555f),
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 12, right: 12, bottom: 15, top: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.grey[200],
                                          child: const Icon(Icons.qr_code,
                                              color: Colors.black),
                                        ),
                                        const SizedBox(width: 20),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Indicação por link',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                  fontFamily: 'Inter-Regular'),
                                            ),
                                            Text(
                                              cupom,
                                              style: const TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.orange,
                                                  fontFamily: 'Inter-Black'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 50,
                                      child: VerticalDivider(
                                        thickness: 3,
                                        color: Colors.white,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.share,
                                        color: Colors.white,
                                      ),
                                      onPressed: () async {
                                        String linkWhatsApp =
                                            "CÓDIGO DE CONVITE: $cupom . Link: https://painel.rodocalc.com.br/register/$cupom";

                                        var androidUrl =
                                            "whatsapp://send?text=$linkWhatsApp";
                                        var iosUrl =
                                            "https://api.whatsapp.com/send?text=$linkWhatsApp";

                                        try {
                                          if (Platform.isIOS) {
                                            await launchUrl(Uri.parse(iosUrl));
                                          } else {
                                            await launchUrl(
                                                Uri.parse(androidUrl));
                                          }
                                        } on Exception {
                                          Get.snackbar(
                                            'Falha',
                                            'Whatsapp não instalado!',
                                            backgroundColor:
                                                Colors.red.shade500,
                                            colorText: Colors.white,
                                            snackPosition: SnackPosition.BOTTOM,
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            CustomSearchField(
                              labelText: 'PESQUISAR ASSINANTE',
                              controller:
                                  controller.searchMyIndicatorController,
                              onChanged: (value) {
                                controller.filterMinhasIndications(value);
                              },
                            ),
                            const SizedBox(height: 16),
                            Obx(
                              () {
                                if (controller.isLoadingMyIndications.value) {
                                  return const Column(
                                    children: [
                                      Text('Carregando...'),
                                      SizedBox(height: 20.0),
                                      CircularProgressIndicator(),
                                    ],
                                  );
                                } else if (controller
                                            .isLoadingMyIndications.value ==
                                        false &&
                                    controller.listIndications.isNotEmpty) {
                                  return ListView.builder(
                                    padding: EdgeInsets.only(
                                        bottom:
                                            MediaQuery.of(context).size.height *
                                                .25),
                                    shrinkWrap: true,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    itemCount:
                                        controller.filteredMyIndications.length,
                                    itemBuilder: (context, index) {
                                      User user = controller
                                          .filteredMyIndications[index];

                                      return CustomMyIndicationsCard(
                                        user: user,
                                      );
                                    },
                                  );
                                } else {
                                  return const Center(
                                    child:
                                        Text("NENHUMA INDICAÇÃO CADASTRADA!"),
                                  );
                                }
                              },
                            ),
                          ],
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

void showDialog(
    context, Indication indication, IndicationController controller) {
  Get.defaultDialog(
    titlePadding: const EdgeInsets.all(16),
    contentPadding: const EdgeInsets.all(16),
    title: "Confirmação",
    content: const Text(
      textAlign: TextAlign.center,
      "Tem certeza que deseja excluir a indicação selecionada?",
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 18,
      ),
    ),
    actions: [
      ElevatedButton(
        onPressed: () async {
          Map<String, dynamic> retorno =
              await controller.deleteIndication(indication.id!);

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
          "CONFIRMAR",
          style: TextStyle(fontFamily: 'Poppinss', color: Colors.white),
        ),
      ),
      TextButton(
        onPressed: () {
          Get.back();
        },
        child: const Text(
          "CANCELAR",
          style: TextStyle(fontFamily: 'Poppinss'),
        ),
      ),
    ],
  );
}
