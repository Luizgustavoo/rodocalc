import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rodocalc/app/data/base_url.dart';

class PhotoItem extends StatelessWidget {
  final String photo;
  final bool isUpdate;
  final VoidCallback onDelete;

  const PhotoItem(
      {required this.photo,
      required this.onDelete,
      required this.isUpdate,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 2, left: 2),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: isUpdate
                  ? Image.network(
                      '$urlImagem/storage/fotos/transacoes/${photo}',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(photo),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
            ),
            Positioned(
              right: 0,
              child: GestureDetector(
                onTap: onDelete,
                child: const Icon(
                  Icons.remove_circle,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
