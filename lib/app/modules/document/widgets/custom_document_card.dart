import 'package:flutter/material.dart';
import 'package:rodocalc/app/data/models/document_model.dart';

class CustomDocumentCard extends StatelessWidget {
  // final String description;
  // final String documentType;
  // final String conductor;
  // final String vehicle;
  final DocumentModel? document;

  const CustomDocumentCard({
    super.key,
    this.document,
    // required this.description,
    // required this.documentType,
    // required this.conductor,
    // required this.vehicle,
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
                  TextSpan(text: document!.tipoDocumentoId!.toUpperCase()),
                ],
              ),
            ),
            const SizedBox(height: 5),
            // RichText(
            //   text: TextSpan(
            //     style: const TextStyle(
            //       fontSize: 14,
            //       color: Colors.black,
            //       fontFamily: 'Inter-Regular',
            //     ),
            //     children: [
            //       const TextSpan(
            //         text: 'CONDUTOR: ',
            //         style: TextStyle(
            //           fontFamily: 'Inter-Bold',
            //         ),
            //       ),
            //       TextSpan(text: conductor.toUpperCase()),
            //     ],
            //   ),
            // ),
            // const SizedBox(height: 5),
            // RichText(
            //   text: TextSpan(
            //     style: const TextStyle(
            //       fontSize: 14,
            //       color: Colors.black,
            //       fontFamily: 'Inter-Regular',
            //     ),
            //     children: [
            //       const TextSpan(
            //         text: 'VEÍCULO: ',
            //         style: TextStyle(
            //           fontFamily: 'Inter-Bold',
            //         ),
            //       ),
            //       TextSpan(text: vehicle.toUpperCase()),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
