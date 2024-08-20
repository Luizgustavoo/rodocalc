import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/models/classifieds_model.dart';
import 'package:rodocalc/app/utils/formatter.dart';
import 'package:rodocalc/app/utils/service_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomClassifiedCard extends StatelessWidget {
  CustomClassifiedCard({
    super.key,
    required this.classificado,
    required this.fnEdit,
  });

  final Classifieds? classificado;
  final Function() fnEdit;

  @override
  Widget build(BuildContext context) {
    String url = "";
    if (classificado!.fotosclassificados!.isNotEmpty) {
      url =
          "$urlImagem/storage/fotos/classificados/${classificado!.fotosclassificados!.first.arquivo}";
    }

    return Card(
      color: Colors.orange.shade50,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        horizontalTitleGap: 10,
        dense: true,
        contentPadding:
            const EdgeInsets.only(bottom: 5, top: 5, left: 10, right: 10),
        leading: InkWell(
          onTap: () {
            print('aquiii');
          },
          child: Container(
            width: 60,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: CachedNetworkImageProvider(url),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        trailing: ServiceStorage.getUserId() != classificado!.user!.id
            ? IconButton(
                onPressed: () async {
                  if (ServiceStorage.getUserId() != classificado!.user!.id) {
                    String phone = classificado!.user!.people!.telefone!
                        .replaceAll('(', '')
                        .replaceAll(')', '')
                        .replaceAll('-', '')
                        .replaceAll(' ', '');

                    var contact = phone;
                    var androidUrl =
                        "whatsapp://send?phone=+55$contact&text=Olá, vi seu anuncio no app da Rodocalc. Tenho interesse no item.";
                    var iosUrl =
                        "https://wa.me/+55$contact&text=Olá, vi seu anuncio no app da Rodocalc. Tenho interesse no item.";

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
                icon: const Icon(
                  FontAwesomeIcons.whatsapp,
                  color: Colors.green,
                ),
              )
            : IconButton(onPressed: fnEdit, icon: Icon(Icons.edit)),
        title: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontFamily: 'Inter-Regular',
            ),
            children: [
              const TextSpan(
                text: 'DESCRIÇÃO: ',
                style: TextStyle(
                  fontFamily: 'Inter-Bold',
                ),
              ),
              TextSpan(text: classificado!.descricao!),
            ],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontFamily: 'Inter-Regular',
                ),
                children: [
                  const TextSpan(
                    text: 'VALOR: ',
                    style: TextStyle(
                      fontFamily: 'Inter-Bold',
                    ),
                  ),
                  TextSpan(
                      text:
                          "R\$${FormattedInputers.formatValuePTBR(classificado!.valor.toString())}"),
                ],
              ),
            ),
            const SizedBox(height: 5),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontFamily: 'Inter-Regular',
                ),
                children: [
                  const TextSpan(
                    text: 'ANUNCIANTE: ',
                    style: TextStyle(
                      fontFamily: 'Inter-Bold',
                    ),
                  ),
                  TextSpan(text: classificado!.user!.people!.nome),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
