import 'package:flutter/material.dart';
import 'package:rodocalc/app/data/models/user_model.dart';

class CustomFleetOwnerCard extends StatelessWidget {
  const CustomFleetOwnerCard(
      {super.key, required this.user, required this.fnEdit});

  final User user;

  final VoidCallback? fnEdit;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.orange.shade50,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        trailing:
            IconButton(onPressed: fnEdit, icon: const Icon(Icons.edit_rounded)),
        horizontalTitleGap: 10,
        dense: true,
        contentPadding:
            const EdgeInsets.only(bottom: 5, top: 5, left: 10, right: 10),
        title: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 12,
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
              TextSpan(text: user.people!.nome!.toUpperCase().toString()),
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
                  fontSize: 12,
                  color: Colors.black,
                  fontFamily: 'Inter-Regular',
                ),
                children: [
                  const TextSpan(
                    text: 'TELEFONE: ',
                    style: TextStyle(
                      fontFamily: 'Inter-Bold',
                    ),
                  ),
                  TextSpan(text: user.people!.telefone),
                ],
              ),
            ),
            const SizedBox(height: 5),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontFamily: 'Inter-Regular',
                ),
                children: [
                  const TextSpan(
                    text: 'CAMINHÃO: ',
                    style: TextStyle(
                      fontFamily: 'Inter-Bold',
                    ),
                  ),
                  TextSpan(
                      text: user.vehicles!.isNotEmpty
                          ? user.vehicles!
                              .map((e) => "${e.marca}/${e.modelo}")
                              .join(', ')
                              .toUpperCase()
                          : 'NENHUM VEÍCULO VINCULADO'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
