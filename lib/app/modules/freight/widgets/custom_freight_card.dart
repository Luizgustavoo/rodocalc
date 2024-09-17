import 'package:flutter/material.dart';
import 'package:rodocalc/app/utils/formatter.dart';

class CustomFreightCard extends StatelessWidget {
  final String origin;
  final String destination;
  final String distance;
  final String value;
  final VoidCallback functionEdit;

  const CustomFreightCard({
    super.key,
    required this.origin,
    required this.destination,
    required this.distance,
    required this.value,
    required this.functionEdit,
  });

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
                text: "${origin.toUpperCase()} / ${destination.toUpperCase()}",
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
                  TextSpan(text: "$distance KM"),
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
                    text: 'VALOR: ',
                    style: TextStyle(
                      fontFamily: 'Inter-Bold',
                    ),
                  ),
                  TextSpan(
                      text: 'R\$ ${FormattedInputers.formatValuePTBR(value)}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
