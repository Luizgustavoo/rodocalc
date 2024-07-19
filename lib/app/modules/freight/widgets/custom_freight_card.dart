import 'package:flutter/material.dart';

class CustomFreightCard extends StatelessWidget {
  final String origin;
  final String destination;
  final String distance;
  final String value;

  const CustomFreightCard({
    super.key,
    required this.origin,
    required this.destination,
    required this.distance,
    required this.value,
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
        leading: const Icon(
          Icons.pin_drop,
          size: 35,
        ),
        title: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontFamily: 'Inter-Regular',
            ),
            children: [
              const TextSpan(
                text: 'ORIGEM: ',
                style: TextStyle(
                  fontFamily: 'Inter-Bold',
                ),
              ),
              TextSpan(text: origin),
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
                    text: 'DESTINO: ',
                    style: TextStyle(
                      fontFamily: 'Inter-Bold',
                    ),
                  ),
                  TextSpan(text: destination),
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
                    text: 'DISTÂNCIA: ',
                    style: TextStyle(
                      fontFamily: 'Inter-Bold',
                    ),
                  ),
                  TextSpan(text: distance),
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
                  TextSpan(text: value),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
