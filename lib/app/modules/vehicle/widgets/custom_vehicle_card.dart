import 'package:flutter/material.dart';

class CustomVehicleCard extends StatelessWidget {
  final String modelo;
  final String placa;
  final String ano;
  final String fipe;

  const CustomVehicleCard({
    super.key,
    required this.modelo,
    required this.placa,
    required this.ano,
    required this.fipe,
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
        horizontalTitleGap: 10,
        dense: true,
        contentPadding: const EdgeInsets.all(10),
        leading: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            image: const DecorationImage(
              image: NetworkImage(
                  'https://www.scania.com/content/dam/www/market/master/products/trucks/20012-005.jpg.transform/Rend_1200X630/image.jpg'),
              fit: BoxFit.cover,
            ),
          ),
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
                text: 'MODELO: ',
                style: TextStyle(
                  fontFamily: 'Inter-Bold',
                ),
              ),
              TextSpan(text: modelo),
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
                    text: 'PLACA: ',
                    style: TextStyle(
                      fontFamily: 'Inter-Bold',
                    ),
                  ),
                  TextSpan(text: placa),
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
                    text: 'ANO: ',
                    style: TextStyle(
                      fontFamily: 'Inter-Bold',
                    ),
                  ),
                  TextSpan(text: ano),
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
                    text: 'FIPE: ',
                    style: TextStyle(
                      fontFamily: 'Inter-Bold',
                    ),
                  ),
                  TextSpan(text: fipe),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
