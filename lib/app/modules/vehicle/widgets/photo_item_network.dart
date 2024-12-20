import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rodocalc/app/data/base_url.dart';

import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

class PhotoItemNetwork extends StatelessWidget {
  final String photo;
  final VoidCallback onDelete;
  final String url;

  const PhotoItemNetwork(
      {required this.photo,
      required this.onDelete,
      super.key,
      required this.url});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 2, left: 2),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(0), // Torna o Dialog quadrado
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            15), // Borda arredondada do conteúdo
                      ),
                      padding: const EdgeInsets.all(16),
                      // Espaçamento interno
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.network(
                            "$urlImagem/storage/fotos/$url/$photo",
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                onPressed: () async {
                                  try {
                                    // URL da imagem
                                    final imageUrl =
                                        "$urlImagem/storage/fotos/$url/$photo";

                                    // Fazer o download da imagem
                                    final response =
                                        await http.get(Uri.parse(imageUrl));
                                    if (response.statusCode == 200) {
                                      // Diretório temporário para salvar a imagem
                                      final tempDir =
                                          await getTemporaryDirectory();
                                      final tempPath =
                                          '${tempDir.path}/${imageUrl.split('/').last}';

                                      // Salvar a imagem como arquivo
                                      final file = File(tempPath);
                                      await file
                                          .writeAsBytes(response.bodyBytes);

                                      // Compartilhar o arquivo
                                      await Share.shareFiles([file.path],
                                          text: 'Confira esta imagem!');
                                    } else {
                                      throw Exception(
                                          'Falha ao baixar a imagem. Código: ${response.statusCode}');
                                    }
                                  } catch (e) {
                                    // Tratar erro
                                    Get.snackbar('Erro',
                                        'Falha ao compartilhar a imagem: $e',
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white);
                                  }
                                },
                                child: const Text(
                                  'COMPARTILHAR',
                                  style: TextStyle(
                                    fontFamily: 'Inter-Bold',
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Get.back(),
                                child: const Text(
                                  'FECHAR',
                                  style: TextStyle(
                                    fontFamily: 'Inter-Bold',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        "$urlImagem/storage/fotos/$url/$photo",
                        maxWidth: 100,
                        maxHeight: 100,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: GestureDetector(
                onTap: onDelete,
                child: const Icon(
                  Icons.remove_circle,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
