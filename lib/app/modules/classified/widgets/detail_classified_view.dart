import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/models/classifieds_model.dart';
import 'package:rodocalc/app/global/custom_app_bar.dart';
import 'package:rodocalc/app/utils/custom_elevated_button.dart';
import 'package:rodocalc/app/utils/formatter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/base_url.dart';
import '../../../data/controllers/classified_controller.dart';
import '../../../utils/service_storage.dart';

class DetailClassifiedView extends StatelessWidget {
  const DetailClassifiedView({
    super.key,
    required this.classified,
    required this.fnEdit,
  });

  final Classifieds classified;
  final Function() fnEdit;

  @override
  Widget build(BuildContext context) {
    // Extraindo o ID do vídeo do link do vídeo
    String url = "";
    if (classified!.fotosclassificados!.isNotEmpty) {
      url =
          "$urlImagem/storage/fotos/classificados/${classified!.fotosclassificados!.first.arquivo}";
    }

    return Scaffold(
      appBar: CustomAppBar(title: classified.descricao!.toUpperCase()),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
                tag:
                    'classified_image_${classified.fotosclassificados!.first.id}',
                child: Container()),
            const SizedBox(height: 10),
            classified!.fotosclassificados!.length == 1
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 200.0,
                    child: Image.network(
                      '$urlImagem/storage/fotos/classificados/${classified!.fotosclassificados!.first.arquivo}',
                      fit: BoxFit.cover,
                    ),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: classified!.fotosclassificados!.map((photo) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          width: 350.0,
                          height: 200.0,
                          child: Image.network(
                            '$urlImagem/storage/fotos/classificados/${photo.arquivo}',
                            fit: BoxFit.fill,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
            const SizedBox(height: 15),
            CustomElevatedButton(
              onPressed: () async {
                if (ServiceStorage.getUserId() != classified!.user!.id) {
                  String phone = classified!.user!.people!.telefone!
                      .replaceAll('(', '')
                      .replaceAll(')', '')
                      .replaceAll('-', '')
                      .replaceAll(' ', '');

                  var contact = phone;
                  var androidUrl =
                      "whatsapp://send?phone=+55$contact&text=Olá, vi seu anuncio no app da Rodocalc. Tenho interesse no item ${classified.descricao}.";
                  var iosUrl =
                      "https://wa.me/+55$contact&text=Olá, vi seu anuncio no app da Rodocalc. Tenho interesse no item ${classified.descricao}.";

                  try {
                    if (Platform.isIOS) {
                      await launchUrl(Uri.parse(iosUrl));
                    } else {
                      await launchUrl(Uri.parse(androidUrl));
                    }
                  } on Exception {
                    Get.snackbar('Falha', 'Whatsapp não instalado!',
                        backgroundColor: Colors.red.shade500,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM);
                  }
                }
              },
              child: const Text(
                'FALAR COM ANUNCIANTE',
                style: TextStyle(color: Colors.white, fontFamily: 'Inter-Bold'),
              ),
            ),
            if (ServiceStorage.getUserId() == classified!.user!.id) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        showDialog(context, classified);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      )),
                  IconButton(
                      onPressed: fnEdit,
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      )),
                ],
              )
            ],
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'DESCRIÇÃO DO CLASSIFICADO:',
                        style: TextStyle(fontFamily: 'Inter-Black'),
                      ),
                      const Divider(color: Colors.orange),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: Get.height * .34,
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            Text(
                              classified.descricao!,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(fontFamily: 'Inter-Bold'),
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                      Text(
                        "R\$${FormattedInputers.formatValuePTBR(classified!.valor.toString())}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.deepOrange,
                            fontSize: 20,
                            fontWeight: FontWeight.w900),
                      ),
                      ServiceStorage.getUserId() == classified.user!.id
                          ? Text(
                              "RECUSADO: ${(classified!.observacoes.toString())}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showDialog(context, Classifieds classificado) {
  ClassifiedController controller = Get.put(ClassifiedController());
  Get.defaultDialog(
    titlePadding: const EdgeInsets.all(16),
    contentPadding: const EdgeInsets.all(16),
    title: "Confirmação",
    content: Text(
      textAlign: TextAlign.center,
      "Tem certeza que deseja excluir o anúncio ${classificado.descricao}?",
      style: const TextStyle(
        fontFamily: 'Inter-Regular',
        fontSize: 18,
      ),
    ),
    actions: [
      ElevatedButton(
        onPressed: () async {
          Map<String, dynamic> retorno =
              await controller.deleteClassificado(classificado.id!);

          if (retorno['success'] == true) {
            Get.back();
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
