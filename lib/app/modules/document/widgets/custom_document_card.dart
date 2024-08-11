import 'package:flutter/material.dart';
import 'package:rodocalc/app/data/models/document_model.dart';

class CustomDocumentCard extends StatelessWidget {
  final DocumentModel? document;
  final VoidCallback? editDocument;
  final VoidCallback? onTap; // Novo parâmetro para visualizar o documento

  const CustomDocumentCard({
    super.key,
    this.document,
    this.editDocument,
    required this.onTap, // Exige o onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Chama a função de visualização ao clicar no card
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        margin: const EdgeInsets.only(bottom: 10),
        child: ListTile(
          trailing: IconButton(
            onPressed: editDocument,
            icon: const Icon(Icons.edit),
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
                  text: 'DESCRIÇÃO: ',
                  style: TextStyle(
                    fontFamily: 'Inter-Bold',
                  ),
                ),
                TextSpan(text: document!.descricao!.toUpperCase()),
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
                      text: 'TIPO DE DOCUMENTO: ',
                      style: TextStyle(
                        fontFamily: 'Inter-Bold',
                      ),
                    ),
                    TextSpan(
                        text: document!.documentType!.descricao!.toUpperCase()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
