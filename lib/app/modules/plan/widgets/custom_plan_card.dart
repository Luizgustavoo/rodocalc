import 'package:flutter/material.dart';
import 'package:rodocalc/app/utils/custom_elevated_button.dart';
import 'package:rodocalc/app/utils/formatter.dart';

class CustomPlanCard extends StatelessWidget {
  final String? name;
  final String? description;
  final double? price;
  final String? desconto;
  final int? minLicencas;

  final VoidCallback onPressedMonth;
  final VoidCallback onPressedYear;
  final String? corTexto;
  final String? corCard;

  const CustomPlanCard(
      {super.key,
      required this.name,
      required this.description,
      required this.price,
      required this.desconto,
      required this.onPressedMonth,
      required this.onPressedYear,
      required this.minLicencas,
      required this.corTexto,
      required this.corCard});

  @override
  Widget build(BuildContext context) {
    List<String> lines = description!.split('\n') ?? [];
    Color cardColor = Color(int.parse("0xFF$corCard"));
    Color colorText = Color(int.parse("0xFF$corTexto"));

    double precoDesconto = price!;

    if (double.parse(desconto!) > 0) {
      precoDesconto = (price! * (1 - (double.parse(desconto!) / 100)));
    }

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
            Divider(
              thickness: 2,
              color: Colors.grey.shade200,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Baseline(
                                  baseline: 10,
                                  baselineType: TextBaseline.alphabetic,
                                  child: Text(
                                    'R\$',
                                    style: TextStyle(
                                      fontFamily: 'Inter-Regular',
                                      fontSize: 10,
                                      color: colorText,
                                    ),
                                  ),
                                ),
                                Text(
                                  FormattedInputers.formatValuePTBR(
                                      price), // O preço maior
                                  style: TextStyle(
                                      fontFamily: 'Inter-Black',
                                      fontSize: 20,
                                      color: colorText),
                                ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Por placa / MENSAL',
                              style: TextStyle(
                                  fontFamily: 'Inter-Regular',
                                  fontSize: 10,
                                  color: colorText),
                            ),
                          ],
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Baseline(
                                  baseline: 10,
                                  baselineType: TextBaseline.alphabetic,
                                  child: Text(
                                    'R\$',
                                    style: TextStyle(
                                      fontFamily: 'Inter-Regular',
                                      fontSize: 10,
                                      color: colorText,
                                    ),
                                  ),
                                ),
                                Text(
                                  FormattedInputers.formatValuePTBR(
                                      precoDesconto * 12), // O preço maior
                                  style: TextStyle(
                                    fontFamily: 'Inter-Black',
                                    fontSize: 32,
                                    color: Colors.orange.shade900,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Por placa / ANUAL',
                              style: TextStyle(
                                  fontFamily: 'Inter-Regular',
                                  fontSize: 10,
                                  color: colorText),
                            ),
                            Text(
                              '$desconto% OFF',
                              style: TextStyle(
                                  fontFamily: 'Inter-Regular',
                                  fontSize: 14,
                                  color: colorText),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                // const SizedBox(height: 10.0),

                const SizedBox(height: 10.0),
              ],
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * .32,
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
                  gradient: const LinearGradient(colors: [
                    Color(0xFFFF6B00),
                    Colors.orange,
                  ]),
                  width: MediaQuery.of(context).size.width * .35,
                  onPressed: onPressedMonth,
                  child: const Text(
                    'CONTRATAR MENSAL',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Inter-Bold',
                        color: Colors.white),
                  ),
                ),
                CustomElevatedButton(
                  gradient: const LinearGradient(colors: [
                    Color(0xFFFF6B00),
                    Colors.orange,
                  ]),
                  width: MediaQuery.of(context).size.width * .35,
                  onPressed: onPressedYear,
                  child: const Text(
                    textAlign: TextAlign.center,
                    'CONTRATAR ANUAL',
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Inter-Bold',
                        color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
