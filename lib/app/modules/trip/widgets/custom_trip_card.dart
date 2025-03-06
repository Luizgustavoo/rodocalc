import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/controllers/trip_controller.dart';
import 'package:rodocalc/app/data/models/trip_model.dart';
import 'package:rodocalc/app/data/models/trip_photos.dart';
import 'package:rodocalc/app/utils/formatter.dart';

import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

class CustomTripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback functionEdit;
  final VoidCallback functionRemove;
  final VoidCallback functionPhoto;
  final VoidCallback functionClose;
  final VoidCallback functionExpense;

  const CustomTripCard({
    super.key,
    required this.trip,
    required this.functionEdit,
    required this.functionRemove,
    required this.functionPhoto,
    required this.functionClose,
    required this.functionExpense,
  });

  @override
  Widget build(BuildContext context) {
    String trecho =
        "${trip.origem?.toUpperCase() ?? 'N/D'}-${trip.ufOrigem?.toUpperCase() ?? 'N/D'}/${trip.destino?.toUpperCase() ?? 'N/D'}-${trip.ufDestino?.toUpperCase() ?? 'N/D'}";

    String origem =
        "${trip.origem?.toUpperCase() ?? 'N/D'}-${trip.ufOrigem?.toUpperCase() ?? 'N/D'}";

    String destino =
        "${trip.destino?.toUpperCase() ?? 'N/D'}-${trip.ufDestino?.toUpperCase() ?? 'N/D'}";

    double despesas = (trip.totalDespesas ?? 0);
    String despesasFormatadas =
        FormattedInputers.formatValuePTBR(despesas.toString());

    double recebimentos = (trip.totalRecebimentos ?? 0);
    String recebimentosFormatados =
        FormattedInputers.formatValuePTBR(recebimentos.toString());

    String dataSaida = trip.dataHora?.trim().isNotEmpty == true
        ? FormattedInputers.formatApiDateHour(trip.dataHora.toString())
        : "N/D";

    String dataChegada = trip.dataHoraChegada?.trim().isNotEmpty == true
        ? FormattedInputers.formatApiDateHour(trip.dataHoraChegada.toString())
        : "N/D";

    String tempoGasto = calcularTempoGasto(trip.dataHora, trip.dataHoraChegada);

    bool closedTrip = (trip.situacao?.toUpperCase() ?? "") == "CLOSE";

    String motorista = "S/M";
    if (trip.user != null && trip.user!.people != null) {
      motorista = trip.user!.people!.nome!;
    }

    return Card(
      color: closedTrip ? Colors.orange.shade50 : Colors.green.shade50,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: functionEdit,
                      icon: const Icon(Icons.edit, color: Colors.blueAccent),
                    ),
                    closedTrip
                        ? const SizedBox.shrink()
                        : IconButton(
                            onPressed: functionPhoto,
                            icon: const Icon(Icons.attach_file,
                                color: Color.fromARGB(255, 252, 181, 58)),
                          ),
                    IconButton(
                      onPressed: functionExpense,
                      icon: const Icon(Icons.payments_outlined,
                          size: 28, color: Color.fromARGB(255, 20, 174, 3)),
                    ),
                    closedTrip
                        ? const SizedBox.shrink()
                        : IconButton(
                            onPressed: functionClose,
                            icon: const Icon(Icons.lock_sharp,
                                color: Color.fromARGB(255, 135, 135, 135)),
                          ),
                    IconButton(
                      onPressed: functionRemove,
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                    ),
                  ],
                ),
                _buildInfoRow("Viagem", trip.numeroViagem ?? 'S/N'),
                _buildInfoRow("Motorista", motorista),
                _buildInfoRow("Trecho", trecho),
                _buildInfoRow("Saída", dataSaida),
              ],
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (trip.photos!.isNotEmpty) ...[
                  const Divider(),
                  _listImages(context),
                ],
                const Divider(),
                _buildInfoRow("Origem", "${origem ?? 0}"),
                _buildInfoRow("Destino", "${destino ?? 0} "),
                _buildInfoRow("Distância", "${trip.distancia ?? 0} km"),
                const Divider(),
                _buildInfoRow("Chegada", dataChegada),
                _buildInfoRow("KM Final Veículo", trip.kmFinal ?? "N/D"),
                _buildInfoRow(
                    "KM Rodado", calcularKmRodado(trip.km, trip.kmFinal)),
                if (tempoGasto.isNotEmpty)
                  _buildInfoRow("Tempo Gasto", tempoGasto),
                const Divider(),
                if (recebimentosFormatados.isNotEmpty)
                  _buildInfoRow("Entradas", "R\$ $recebimentosFormatados"),
                if (despesasFormatadas.isNotEmpty)
                  _buildInfoRow("Despesas", "R\$ $despesasFormatadas"),
                const Divider(),
                _buildInfoRow("Situação", closedTrip ? "FECHADO" : "ABERTO"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding _listImages(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Anexo(s):",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Align(
                alignment: Alignment.centerRight, // Alinha o ícone à direita
                child: IconButton(
                  icon: const Icon(
                    Icons.share,
                    color: Colors.blue,
                  ),
                  onPressed: () async {
                    try {
                      // Baixe todas as imagens
                      List<File> filesToShare = [];

                      for (var foto in trip.photos!) {
                        final imageUrl =
                            '$urlImagem/storage/fotos/trechopercorrido/trecho/${foto.arquivo}';
                        final response = await http.get(Uri.parse(imageUrl));

                        if (response.statusCode == 200) {
                          final tempDir = await getTemporaryDirectory();
                          final tempPath =
                              '${tempDir.path}/${foto.arquivo?.split('/').last}';
                          final file = File(tempPath);

                          await file.writeAsBytes(response.bodyBytes);
                          filesToShare.add(file);
                        } else {
                          throw Exception(
                              'Falha ao baixar a imagem. Código: ${response.statusCode}');
                        }
                      }

                      // Compartilhe as imagens
                      if (filesToShare.isNotEmpty) {
                        await Share.shareFiles(
                          filesToShare.map((file) => file.path).toList(),
                          text: 'Confira essas imagens!',
                        );
                      } else {
                        throw Exception(
                            'Nenhuma imagem encontrada para compartilhar.');
                      }
                    } catch (e) {
                      Get.snackbar(
                        'Erro',
                        'Falha ao compartilhar as imagens: $e',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                ),
              ),
            ],
          ),

          // Exibindo os arquivos em uma listagem vertical

          const SizedBox(
            height: 10,
          ),
          Column(
            children: trip.photos?.map((foto) {
                  String fileExtension =
                      foto.arquivo?.split('.').last.toLowerCase() ?? '';
                  bool isImage = ['jpg', 'jpeg', 'png'].contains(fileExtension);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: InkWell(
                      onTap: () {
                        _openImageModal(context, foto, isImage);
                      },
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow(isImage ? "Imagem" : "Arquivo",
                                foto.descricao ?? 'Sem descrição',
                                cor: Colors.blue),
                            // Não exibe nada se for imagem
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList() ??
                [],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value,
      {Color cor = Colors.black87}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: cor,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: cor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String calcularKmRodado(String? kmInicial, String? kmFinal) {
    if (kmInicial == null || kmFinal == null) {
      return "N/D";
    }

    try {
      double kmIni = double.tryParse(kmInicial.replaceAll('.', '')) ?? 0.0;
      double kmFin = double.tryParse(kmFinal.replaceAll('.', '')) ?? 0.0;

      if (kmIni == 0 || kmFin == 0) return "N/D";

      double kmRodado = (kmFin - kmIni) / 1000; // Conversão de metros para km
      return kmRodado >= 0
          ? "${kmRodado.toStringAsFixed(3)} km"
          : "Erro nos dados";
    } catch (e) {
      return "Dados inválidos";
    }
  }

  String calcularTempoGasto(String? dataSaida, String? dataChegada) {
    if (dataSaida == null || dataChegada == null) return "";

    try {
      DateTime saida = DateTime.parse(dataSaida);
      DateTime chegada = DateTime.parse(dataChegada);

      Duration diferenca = chegada.difference(saida);
      int dias = diferenca.inDays;
      int horas = diferenca.inHours.remainder(24);
      int minutos = diferenca.inMinutes.remainder(60);

      return "${dias > 0 ? '$dias dias, ' : ''}"
              "${horas > 0 ? '$horas horas, ' : ''}"
              "${minutos > 0 ? '$minutos minutos' : ''}"
          .trim();
    } catch (e) {
      return "Erro ao calcular";
    }
  }

  void _openImageModal(BuildContext context, TripPhotos foto, bool isImage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isImage
                  ? ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(
                        "$urlImagem/storage/fotos/trechopercorrido/trecho/${foto.arquivo}",
                        fit: BoxFit.cover,
                        height:
                            300, // Ajuste a altura da imagem conforme necessário
                        width: double.infinity,
                      ),
                    )
                  : const Icon(
                      Icons.insert_drive_file,
                      size: 100,
                      color: Colors.grey,
                    ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.share, color: Colors.blue),
                          onPressed: () async {
                            try {
                              // URL da imagem
                              final imageUrl =
                                  '$urlImagem/storage/fotos/trechopercorrido/trecho/${foto.arquivo}';

                              // Fazer o download da imagem
                              final response =
                                  await http.get(Uri.parse(imageUrl));
                              if (response.statusCode == 200) {
                                // Diretório temporário para salvar a imagem
                                final tempDir = await getTemporaryDirectory();
                                final tempPath =
                                    '${tempDir.path}/${foto.arquivo?.split('/').last}';

                                // Salvar a imagem como arquivo
                                final file = File(tempPath);
                                await file.writeAsBytes(response.bodyBytes);

                                // Compartilhar o arquivo
                                await Share.shareFiles([file.path],
                                    text: 'Confira esta imagem!');
                              } else {
                                throw Exception(
                                    'Falha ao baixar a imagem. Código: ${response.statusCode}');
                              }
                            } catch (e) {
                              // Tratar erro
                              Get.snackbar(
                                  'Erro', 'Falha ao compartilhar a imagem: $e',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white);
                            }
                          },
                        ),
                        const Text("Compartilhar"),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            TripController controller =
                                Get.put(TripController());
                            controller.isDialogOpen.value = false;
                            showDialogDeleteTripPhoto(
                                context, foto.id!, controller);
                          },
                        ),
                        const Text("Excluir"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showDialogDeleteTripPhoto(context, int id, TripController controller) {
    if (controller.isDialogOpen.value) return;

    controller.isDialogOpen.value = true;
    Get.defaultDialog(
      titlePadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.all(16),
      title: "REMOVER FOTO DO TRECHO",
      content: const Text(
        textAlign: TextAlign.center,
        "Tem certeza que deseja excluir a foto selecionada?",
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            Get.back(); // Fecha o diálogo atual de confirmação
            Navigator.of(context).pop(); // Fecha o modal com a imagem maior
            await Future.delayed(const Duration(milliseconds: 500));
            Map<String, dynamic> retorno = await controller.deletePhotoTrip(id);

            if (retorno['success'] == true) {
              Get.snackbar('Sucesso!', retorno['message'].join('\n'),
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 1),
                  snackPosition: SnackPosition.BOTTOM);
            } else {
              Get.snackbar('Falha!', retorno['message'].join('\n'),
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 1),
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
}
