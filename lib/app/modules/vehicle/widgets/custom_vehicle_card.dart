import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/models/vehicle_model.dart';

import '../../../utils/formatter.dart';
import '../../../utils/service_storage.dart';

class CustomVehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  final VoidCallback editVehicle;

  const CustomVehicleCard(
      {super.key, required this.vehicle, required this.editVehicle});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(5),
      child: Container(
        height: Get.height * .14,
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          Expanded(
            flex: 6,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  image: vehicle.foto!.isNotEmpty
                      ? CachedNetworkImageProvider(
                          "$urlImagem/storage/fotos/veiculos/${vehicle.foto}")
                      : const AssetImage('assets/images/logo.png')
                          as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const Spacer(
            flex: 1,
          ),
          Expanded(
            flex: 14,
            child: Container(
              padding: const EdgeInsets.only(top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Ajusta o espaçamento para evitar overflow
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
                          text: 'MODELO: ',
                          style: TextStyle(
                            fontFamily: 'Inter-Bold',
                          ),
                        ),
                        TextSpan(text: vehicle.modelo),
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
                          text: 'PLACA: ',
                          style: TextStyle(
                            fontFamily: 'Inter-Bold',
                          ),
                        ),
                        TextSpan(text: vehicle.placa),
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
                          text: 'ANO: ',
                          style: TextStyle(
                            fontFamily: 'Inter-Bold',
                          ),
                        ),
                        TextSpan(text: vehicle.ano),
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
                          text: 'CODIGO FIPE: ',
                          style: TextStyle(
                            fontFamily: 'Inter-Bold',
                          ),
                        ),
                        TextSpan(text: vehicle.fipe),
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
                          text: 'VALOR FIPE: ',
                          style: TextStyle(
                            fontFamily: 'Inter-Bold',
                          ),
                        ),
                        TextSpan(
                            text:
                                "R\$${FormattedInputers.formatValuePTBR((vehicle.valorFipe! / 100).toString())}"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  // RichText(
                  //   text: TextSpan(
                  //     style: const TextStyle(
                  //       fontSize: 12,
                  //       color: Colors.black,
                  //       fontFamily: 'Inter-Regular',
                  //     ),
                  //     children: [
                  //       const TextSpan(
                  //         text: 'MOTORISTA: ',
                  //         style: TextStyle(
                  //           fontFamily: 'Inter-Bold',
                  //         ),
                  //       ),
                  //       TextSpan(text: vehicle.motorista!.toUpperCase()),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: ServiceStorage.getUserTypeId() == 4 ? null : editVehicle,
            child: Padding(
              padding: const EdgeInsets.all(5), // Ajusta o espaçamento interno
              child: ServiceStorage.getUserTypeId() == 4
                  ? const Icon(Icons.block, size: 20)
                  : const Icon(Icons.edit,
                      size: 20), // Reduz o tamanho do ícone
            ),
          ),
        ]),
      ),
    );
  }
}
