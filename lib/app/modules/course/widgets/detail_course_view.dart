import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/global/custom_app_bar.dart';
import 'package:rodocalc/app/utils/custom_elevated_button.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailCourseView extends StatelessWidget {
  const DetailCourseView(
      {super.key,
      required this.titulo,
      required this.descricao,
      required this.linkVideo,
      required this.imagem,
      required this.link});

  final String titulo;
  final String descricao;
  final String linkVideo;
  final String imagem;
  final String link;

  @override
  Widget build(BuildContext context) {
    // final videoId = YoutubePlayer.convertUrlToId(linkVideo);
    // final controller = YoutubePlayerController(
    //     initialVideoId: videoId!,
    //     flags: const YoutubePlayerFlags(
    //       autoPlay: true,
    //       mute: false,
    //       showLiveFullscreenButton: true,
    //     ));
    return Scaffold(
      appBar: CustomAppBar(title: titulo.toUpperCase()),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(tag: 'course_image_$titulo', child: Container()),
            const SizedBox(height: 10),
            // YoutubePlayer(
            //   controller: controller,
            //   showVideoProgressIndicator: true,
            // ),
            const SizedBox(height: 15),
            CustomElevatedButton(
                onPressed: () async {
                  if (linkVideo.isEmpty) {
                    Get.snackbar(
                      'Atenção',
                      'Link do curso não disponível!',
                      backgroundColor: Colors.orange,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  } else {
                    await launchUrl(Uri.parse(link));
                  }
                },
                child: const Text(
                  'LINK PARA COMPRA',
                  style:
                      TextStyle(color: Colors.white, fontFamily: 'Inter-Bold'),
                )),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DESCRIÇÃO DO CURSO:',
                        style: TextStyle(fontFamily: 'Inter-Black'),
                      ),
                      const Divider(
                        color: Colors.orange,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: Get.height * .34,
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            Text(
                              descricao,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(fontFamily: 'Inter-Bold'),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      )
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
