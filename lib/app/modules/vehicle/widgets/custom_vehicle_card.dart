import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/models/vehicle_model.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class CustomVehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  final VoidCallback editVehicle;

  const CustomVehicleCard(
      {super.key, required this.vehicle, required this.editVehicle});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ServiceStorage.idSelectedVehicle() == vehicle.id!
          ? Colors.orange.shade300
          : Colors.orange.shade50,
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
        leading: Container(
          width: 60,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(5),
            image: DecorationImage(
              image: vehicle.foto!.isNotEmpty
                  ? CachedNetworkImageProvider(
                      "$urlImagem/storage/fotos/veiculos/${vehicle.foto}")
                  : const AssetImage('assets/images/logo.png') as ImageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        trailing: IconButton(
          onPressed: editVehicle,
          icon: const Icon(Icons.edit),
        ),
        title: RichText(
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
                    text: 'PLACA: ',
                    style: TextStyle(
                      fontFamily: 'Inter-Bold',
                    ),
                  ),
                  TextSpan(text: vehicle.placa),
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
                    text: 'ANO: ',
                    style: TextStyle(
                      fontFamily: 'Inter-Bold',
                    ),
                  ),
                  TextSpan(text: vehicle.ano),
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
                    text: 'FIPE: ',
                    style: TextStyle(
                      fontFamily: 'Inter-Bold',
                    ),
                  ),
                  TextSpan(text: vehicle.fipe),
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
                    text: 'MOTORISTA: ',
                    style: TextStyle(
                      fontFamily: 'Inter-Bold',
                    ),
                  ),
                  TextSpan(text: vehicle.motorista!.toUpperCase()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
