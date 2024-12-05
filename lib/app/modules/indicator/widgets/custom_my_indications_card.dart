import 'package:flutter/material.dart';

import '../../../data/models/user_model.dart';
import '../../../utils/formatter.dart';

class CustomMyIndicationsCard extends StatelessWidget {
  final User user;

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
                      text: user.comissoesIndicador != null &&
                              user.comissoesIndicador!.isNotEmpty
                          ? user.comissoesIndicador!.map((comissao) {
                              return FormattedInputers.formatValuePTBR(
                                  ((comissao.valorComissao! / 100).toString()));
                            }).join(
                              ", ") // Junta todos os valores formatados em uma única string, separados por vírgulas
                          : '',
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
