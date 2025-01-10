import 'package:flutter/material.dart';

import '../../../data/models/user_model.dart';
import '../../../utils/formatter.dart';

class CustomMyIndicationsCard extends StatelessWidget {
  final User user;

  const CustomMyIndicationsCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    double soma =
        user.planos!.map((p) => p.valorPlano).fold(0, (a, b) => a + b!);

    double valorComissao = soma * 0.2;

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
              user.people!.nome![0].toUpperCase(),
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
                TextSpan(text: user.people!.nome!.toUpperCase()),
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
                    TextSpan(
                        text: user.planos!.isNotEmpty
                            ? user.planos!.first.plano?.descricao!.toString()
                            : ''),
                  ],
                ),
              ),
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
                          ((valorComissao / 100).toString())),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontFamily: 'Inter-Regular',
                  ),
                  children: [
                    const TextSpan(
                      text: 'VENCIMENTO: ',
                      style: TextStyle(
                        fontFamily: 'Inter-Bold',
                      ),
                    ),
                    TextSpan(
                        text: user.planos!.isNotEmpty
                            ? FormattedInputers.formatApiDate(user
                                .planos!.first.dataVencimentoPlano!
                                .toString())
                            : ''),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
