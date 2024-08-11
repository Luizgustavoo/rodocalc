import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/models/indication_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/formatter.dart';

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
        trailing: IconButton(
          onPressed: functionUpdate,
          icon: const Icon(Icons.edit),
        ),
        leading: IconButton(
          onPressed: () async {
            String phone = indication.telefone!
                .replaceAll('(', '')
                .replaceAll(')', '')
                .replaceAll('-', '')
                .replaceAll(' ', '');
            String linkWhatsApp =
                "https://meusite.com.br?codigo=EDVFERgvcdfgrth342re";

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

            //Share.share(linkWhatsApp);
          },
          icon: const Icon(Icons.share),
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
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            RichText(
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
            const SizedBox(height: 5),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontFamily: 'Inter-Regular',
                ),
                children: [
                  const TextSpan(
                    text: 'STATUS: ',
                    style: TextStyle(
                      fontFamily: 'Inter-Bold',
                    ),
                  ),
                  TextSpan(text: indication.status!.toUpperCase()),
                ],
              ),
            ),
            const SizedBox(height: 5),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontFamily: 'Inter-Regular',
                ),
                children: [
                  const TextSpan(
                    text: 'DATA: ',
                    style: TextStyle(
                      fontFamily: 'Inter-Bold',
                    ),
                  ),
                  TextSpan(
                      text: FormattedInputers.formatApiDate(
                          indication.createdAt!)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
