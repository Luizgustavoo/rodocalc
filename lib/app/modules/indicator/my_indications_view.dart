import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rodocalc/app/data/controllers/comission_indicator_controller.dart';
import 'package:rodocalc/app/data/controllers/indicator_controller.dart';
import 'package:rodocalc/app/data/models/indication_model.dart';
import 'package:rodocalc/app/data/models/indicators_details.dart';
import 'package:rodocalc/app/global/custom_app_bar.dart';
import 'package:rodocalc/app/modules/global/custom_search_field.dart';
import 'package:rodocalc/app/modules/indicator/widgets/custom_my_indications_card.dart';
import 'package:rodocalc/app/utils/service_storage.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/user_model.dart';

import 'package:http/http.dart' as http;

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
                                            Text(
                                              'Indicação por link',
                                              style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.03,
                                                  color: Colors.white,
                                                  fontFamily: 'Inter-Regular'),
                                            ),
                                            Text(
                                              cupom,
                                              style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.05,
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
                                        const String imageUrl =
                                            'https://painel.rodocalc.com.br/share.jpeg';

                                        String linkWhatsApp =
                                            "Vou te ajudar nessa missão!\nSegue seu código de convite para testar gratuitamente  RODO CALC e manter seu financeiro organizado 🚛 📱 👉\nLink: https://painel.rodocalc.com.br/register/$cupom";

                                        var androidUrl =
                                            "whatsapp://send?text=$linkWhatsApp";
                                        var iosUrl =
                                            "https://api.whatsapp.com/send?text=$linkWhatsApp";

                                        try {
                                          // Baixar a imagem da web
                                          final response = await http
                                              .get(Uri.parse(imageUrl));

                                          if (response.statusCode == 200) {
                                            // Obter os bytes da imagem
                                            final Uint8List bytes =
                                                response.bodyBytes;

                                            // Obter o diretório temporário para armazenar a imagem
                                            final tempDir =
                                                await getTemporaryDirectory();
                                            final tempFile = File(
                                                '${tempDir.path}/downloaded_image.jpeg');

                                            // Salvar a imagem no diretório temporário
                                            await tempFile.writeAsBytes(bytes);

                                            // Compartilhar a imagem com o texto
                                            await Share.shareFiles(
                                                [tempFile.path],
                                                text: linkWhatsApp);
                                          } else {
                                            throw Exception(
                                                'Falha ao baixar a imagem');
                                          }
                                        } catch (e) {
                                          // Exibir o erro no snackbar
                                          Get.snackbar(
                                            'Falha',
                                            'Erro: $e',
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
                                    controller
                                        .listMyIndicationsDetails.isNotEmpty) {
                                  return Expanded(
                                    child: ListView.builder(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .25),
                                      shrinkWrap: true,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      itemCount: controller
                                          .filteredMyIndicationsDetails.length,
                                      itemBuilder: (context, index) {
                                        IndicacoesComDetalhes user = controller
                                                .filteredMyIndicationsDetails[
                                            index];

                                        return CustomMyIndicationsCard(
                                          user: user,
                                        );
                                      },
                                    ),
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
