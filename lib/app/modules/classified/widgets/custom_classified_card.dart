// ignore_for_file: unused_local_variable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/models/classifieds_model.dart';

import 'detail_classified_view.dart';

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
      status = "EM ANÁLISE";
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          InkWell(
            onTap: () {
              Get.to(
                () => DetailClassifiedView(
                  fnEdit: fnEdit,
                  classified: classificado!,
                ),
                transition: Transition.fadeIn,
              );
            },
            child: Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(url),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Details Section
          InkWell(
            onTap: () {
              Get.to(
                () => DetailClassifiedView(
                  fnEdit: fnEdit,
                  classified: classificado!,
                ),
                transition: Transition.fadeIn,
              );
            },
            child: Container(
              height: Get.height * .1,
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    constraints: const BoxConstraints(
                      maxHeight:
                          100, // Set a maximum height for the scrollable area
                    ),
                    child: Text(
                      '${classificado!.descricao!.toUpperCase()}',
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontFamily: 'Inter-Regular', fontSize: 12),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
