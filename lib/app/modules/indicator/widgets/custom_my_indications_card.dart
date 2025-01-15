import 'package:flutter/material.dart';
import 'package:rodocalc/app/data/models/indicators_details.dart';

import '../../../utils/formatter.dart';

class CustomMyIndicationsCard extends StatelessWidget {
  final IndicacoesComDetalhes user;

  const CustomMyIndicationsCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
          horizontalTitleGap: 5,
          leading: CircleAvatar(
            child: Text(
              user.nome![0].toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          title: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black,
                fontFamily: 'Inter-Regular',
              ),
              children: [
                const TextSpan(
                  text: 'NOME: ',
                  style: TextStyle(
                    fontFamily: 'Inter-Bold',
                  ),
                ),
                TextSpan(text: user.nome!.toUpperCase()),
              ],
            ),
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontFamily: 'Inter-Regular',
                  ),
                  children: [
                    const TextSpan(
                      text: 'PLANO: ',
                      style: TextStyle(
                        fontFamily: 'Inter-Bold',
                      ),
                    ),
                    TextSpan(text: user.descricao!),
                  ],
                ),
              ),
              const SizedBox(height: 3),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontFamily: 'Inter-Regular',
                  ),
                  children: [
                    const TextSpan(
                      text: 'COMISSÃO: ',
                      style: TextStyle(
                        fontFamily: 'Inter-Bold',
                      ),
                    ),
                    TextSpan(
                      text: FormattedInputers.formatValuePTBR(
                          (user.valorComissao! / 100)),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
