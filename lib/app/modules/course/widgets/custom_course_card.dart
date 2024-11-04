import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/modules/course/widgets/detail_course_view.dart';

import '../../../data/base_url.dart';

class CustomCourseCard extends StatelessWidget {
  const CustomCourseCard({
    super.key,
    required this.titulo,
    required this.descricao,
    required this.imagem,
    required this.duracao,
    required this.valor,
    required this.link,
    required this.linkVideo,
  });

  final String titulo;
  final String descricao;
  final String imagem;
  final String valor;
  final String duracao;
  final String link;
  final String linkVideo;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.orange.shade50,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {
          // Navega para a tela de detalhes do curso com o Hero
          Get.to(
            () => DetailCourseView(
              titulo: titulo,
              descricao: descricao,
              linkVideo: linkVideo,
              imagem: imagem,
              link: link,
            ),
            transition: Transition.fadeIn,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Hero(
              tag: 'course_image_$titulo', // Tag do Hero para a imagem
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                child: CachedNetworkImage(
                  imageUrl: "$urlImagem/storage/fotos/cursos/$imagem",
                  placeholder: (context, url) => const Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    titulo.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 14, fontFamily: 'Inter-Black'),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Duração: $duracao horas',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'apenas',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$valor',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
