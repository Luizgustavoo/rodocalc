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
  const CustomClassifiedCard({
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

    Color corCard;
    String? observacoes = "";
    String status = "";

    if (classificado!.status == 1) {
      corCard = Colors.green.shade100;
      status = "ATIVO";
    } else if (classificado!.status == 2) {
      corCard = Colors.orange.shade100;
      status = "EM ANALISE";
    } else {
      corCard = Colors.red.shade100;
      status = "NEGADO";
      observacoes = classificado!.observacoes;
    }

    return Card(
      color: corCard,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        expandedAlignment: Alignment.centerLeft,
        childrenPadding: const EdgeInsets.all(16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        dense: true,
        leading: InkWell(
          onTap: () {
            if (classificado!.fotosclassificados!.isNotEmpty) {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          classificado!.fotosclassificados!.length == 1
                              ? SizedBox(
                                  width: MediaQuery.of(context)
                                      .size
                                      .width, // Defina a largura desejada
                                  height: 200.0,
                                  child: Image.network(
                                    '$urlImagem/storage/fotos/classificados/${classificado!.fotosclassificados!.first.arquivo}',
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: classificado!.fotosclassificados!
                                        .map((photo) {
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        width: 250.0,
                                        height: 200.0,
                                        child: Image.network(
                                          '$urlImagem/storage/fotos/classificados/${photo.arquivo}',
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              onPressed: () => Get.back(),
                              child: const Text(
                                'FECHAR',
                                style: TextStyle(
                                  fontFamily: 'Inter-Bold',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
          child: Container(
            width: 60,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5),
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
            : IconButton(onPressed: fnEdit, icon: const Icon(Icons.edit)),
        title: Text(
          'DESCRIÇÃO: ${classificado!.descricao!.toUpperCase()}',
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontFamily: 'Inter-Bold'),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  TextSpan(
                      text: classificado!.user!.people!.nome!.toUpperCase()),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 12,
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
                  TextSpan(text: status.toUpperCase()),
                ],
              ),
            ),
          ],
        ),
        children: [
          const Divider(),
          RichText(
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
                TextSpan(text: classificado!.descricao!.toUpperCase()),
              ],
            ),
          ),
          if (classificado!.status == 0) ...[
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontFamily: 'Inter-Regular',
                ),
                children: [
                  const TextSpan(
                    text: 'MOTIVO NEGADO: ',
                    style: TextStyle(
                      fontFamily: 'Inter-Bold',
                    ),
                  ),
                  TextSpan(text: classificado!.observacoes!.toUpperCase()),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }
}
