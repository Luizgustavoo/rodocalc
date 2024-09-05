import 'package:flutter/material.dart';
import 'package:rodocalc/app/data/models/trip_model.dart';
import 'package:rodocalc/app/utils/formatter.dart';

class CustomTripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback functionEdit;

  const CustomTripCard({
    super.key,
    required this.trip,
    required this.functionEdit,
  });

  @override
  Widget build(BuildContext context) {
    String titulo =
        "${trip.tipoSaidaChegada!.toUpperCase()}: ${trip.origem!.toUpperCase()}-${trip.ufOrigem!.toUpperCase()} / ${trip.destino!.toUpperCase()}-${trip.ufDestino!.toUpperCase()}";

    return Card(
      color: trip.tipoSaidaChegada!.toUpperCase() == "SAÍDA"
          ? Colors.red.shade200
          : Colors.green.shade200,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        trailing: IconButton(
          onPressed: functionEdit,
          icon: const Icon(Icons.edit),
        ),
        title: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontFamily: 'Inter-Regular',
            ),
            children: [
              TextSpan(
                text: titulo,
                style: const TextStyle(
                  fontFamily: 'Inter-Bold',
                ),
              ),
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
                  fontSize: 14,
                  color: Colors.black,
                  fontFamily: 'Inter-Regular',
                ),
                children: [
                  const TextSpan(
                    text: 'DISTÂNCIA: ',
                    style: TextStyle(
                      fontFamily: 'Inter-Bold',
                    ),
                  ),
                  TextSpan(text: "${trip.distancia} km"),
                ],
              ),
            ),
            const SizedBox(height: 5),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontFamily: 'Inter-Regular',
                ),
                children: [
                  const TextSpan(
                    text: 'TOTAL DESPESA: ',
                    style: TextStyle(
                      fontFamily: 'Inter-Bold',
                    ),
                  ),
                  TextSpan(
                      text:
                          'R\$ ${FormattedInputers.formatValuePTBR((trip.totalDespesas / 100).toString())}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
