import 'package:flutter/material.dart';
import 'package:rodocalc/app/data/models/document_model.dart';

class CustomDocumentCard extends StatelessWidget {
  final DocumentModel? document;
  final VoidCallback? editDocument;
  final VoidCallback? removeDocument;
  final VoidCallback? onTap; // Novo parâmetro para visualizar o documento

  const CustomDocumentCard({
    super.key,
    this.document,
    this.editDocument,
    this.removeDocument,
    required this.onTap, // Exige o onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        margin: const EdgeInsets.only(bottom: 10),
        child: ListTile(
          leading: IconButton(
            onPressed: removeDocument,
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
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
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontFamily: 'Inter-Regular',
                  ),
                  children: [
                    const TextSpan(
                      text: 'MOTORISTA: ',
                      style: TextStyle(
                        fontFamily: 'Inter-Bold',
                      ),
                    ),
                    TextSpan(text: document!.people!.nome!.toUpperCase()),
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
