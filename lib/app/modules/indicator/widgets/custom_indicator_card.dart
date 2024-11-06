import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/models/indication_model.dart';
import 'package:rodocalc/app/utils/service_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomIndicatorCard extends StatelessWidget {
  final VoidCallback functionUpdate;
  final Indication indication;

  const CustomIndicatorCard(
      {super.key, required this.functionUpdate, required this.indication});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: functionUpdate,
        horizontalTitleGap: 5,
        trailing: InkWell(
          onTap: () async {
            String phone = indication.telefone!
                .replaceAll('(', '')
                .replaceAll(')', '')
                .replaceAll('-', '')
                .replaceAll(' ', '');
            String cupom = ServiceStorage.getUserId().toString();
            String linkWhatsApp =
                "https://painel.rodocalc.com.br/register/$cupom";

            var contact = phone;
            var androidUrl =
                "whatsapp://send?phone=+55$contact&text=$linkWhatsApp";
            var iosUrl = "https://wa.me/+55$contact&text=$linkWhatsApp";

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
          },
          child: const Padding(
            padding: EdgeInsets.all(5), // Ajusta o espaçamento interno
            child: Icon(Icons.share, size: 20), // Reduz o tamanho do ícone
          ),
        ),
        leading: CircleAvatar(
          child: Text(
            indication.nome![0].toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        title: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black,
              fontFamily: 'Inter-Regular',
            ),
            children: [
              const TextSpan(
                text: 'NOME: ',
                style: TextStyle(
                  fontFamily: 'Inter-Bold',
                ),
              ),
              TextSpan(text: indication.nome!.toUpperCase()),
            ],
          ),
        ),
        subtitle: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black,
              fontFamily: 'Inter-Regular',
            ),
            children: [
              const TextSpan(
                text: 'TELEFONE: ',
                style: TextStyle(
                  fontFamily: 'Inter-Bold',
                ),
              ),
              TextSpan(text: indication.telefone!.toUpperCase()),
            ],
          ),
        ),
      ),
    );
  }
}
