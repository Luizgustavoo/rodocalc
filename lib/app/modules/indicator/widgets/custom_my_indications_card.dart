import 'package:flutter/material.dart';

import '../../../data/models/user_model.dart';

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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
        subtitle: RichText(
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
      ),
    );
  }
}
