import 'package:flutter/material.dart';
import 'package:rodocalc/app/utils/custom_elevated_button.dart';

class CustomPlanCard extends StatelessWidget {
  final String? name;
  final String? description;
  final String? price;
  final int? minLicencas;

  final VoidCallback onPressed;
  final String? corTexto;
  final String? corCard;

  const CustomPlanCard(
      {super.key,
      required this.name,
      required this.description,
      required this.price,
      required this.onPressed,
      required this.minLicencas,
      required this.corTexto,
      required this.corCard});

  @override
  Widget build(BuildContext context) {
    List<String> lines = description!.split('\n') ?? [];
    Color cardColor = Color(int.parse("0xFF$corCard"));
    Color colorText = Color(int.parse("0xFF$corTexto"));
    return Card(
      color: cardColor,
      margin: const EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
            right: 16.0, left: 16.0, bottom: 16.0, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name!,
              style: TextStyle(
                  fontFamily: 'Inter-Black', fontSize: 18.0, color: colorText),
            ),
            const Divider(
              thickness: 4,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Baseline(
                      baseline: 15.0,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        'R\$',
                        style: TextStyle(
                          fontFamily: 'Inter-Regular',
                          fontSize: 15.0,
                          color: colorText,
                        ),
                      ),
                    ),
                    Text(
                      price!, // O preço maior
                      style: TextStyle(
                          fontFamily: 'Inter-Black',
                          fontSize: 32.0,
                          color: colorText),
                    ),
                    const SizedBox(width: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Por placa\nVALOR MENSAL',
                          style: TextStyle(
                              fontFamily: 'Inter-Regular',
                              fontSize: 12.0,
                              color: colorText),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Contratação mínima $minLicencas placa(s)',
                  style: TextStyle(
                    fontFamily: 'Inter-Regular',
                    fontSize: 12.0,
                    color: colorText,
                  ),
                  textAlign: TextAlign
                      .center, // Centralizar o texto de contratação mínima
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 250,
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: lines.map((line) {
                  List<String> parts = line.split(':');
                  String firstPart = parts[0];
                  String secondPart = parts.length > 1 ? parts[1].trim() : '';

                  Color secondPartColor = secondPart.toLowerCase() == 'não'
                      ? Colors.redAccent.shade400
                      : Colors.green.shade300;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            '$firstPart:',
                            style: TextStyle(
                                fontFamily: 'Inter-Regular', color: colorText),
                            textAlign: TextAlign.left,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            secondPart,
                            style: TextStyle(
                              fontFamily: 'Inter-Bold',
                              color: secondPartColor,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomElevatedButton(
                  width: 200,
                  onPressed: onPressed,
                  child: const Text(
                    'SELECIONAR',
                    style: TextStyle(
                        fontFamily: 'Inter-Bold', color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
