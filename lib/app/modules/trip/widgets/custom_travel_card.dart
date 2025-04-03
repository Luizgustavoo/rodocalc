import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/controllers/trip_controller.dart';
import 'package:rodocalc/app/data/models/trip_model.dart';
import 'package:rodocalc/app/data/models/trip_photos.dart';
import 'package:rodocalc/app/data/models/viagens_model.dart';
import 'package:rodocalc/app/utils/formatter.dart';
import 'package:share_plus/share_plus.dart';

class CustomTravelCard extends StatelessWidget {
  final Viagens travel;
  final VoidCallback functionEdit;
  final VoidCallback functionRemove;
  final VoidCallback functionClose;

  const CustomTravelCard({
    super.key,
    required this.travel,
    required this.functionEdit,
    required this.functionRemove,
    required this.functionClose,
  });

  @override
  Widget build(BuildContext context) {
    bool closedTravel = (travel.situacao?.toUpperCase() ?? "") == "CLOSED";

    String motorista = "S/M";
    if (travel.motorista != null && travel.motorista!.people != null) {
      motorista = travel.motorista!.people!.nome!;
    }

    String situacao = travel.situacao == 'OPENED' ? "ABERTA" : "FECHADA";

    return Card(
      color: closedTravel ? Colors.orange.shade50 : Colors.green.shade50,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    closedTravel
                        ? const SizedBox.shrink()
                        : IconButton(
                            onPressed: functionEdit,
                            icon: const Icon(Icons.edit,
                                color: Colors.blueAccent),
                          ),
                    closedTravel
                        ? const SizedBox.shrink()
                        : IconButton(
                            onPressed: functionClose,
                            icon: const Icon(Icons.lock_open_sharp,
                                color: Color.fromARGB(255, 2, 97, 51)),
                          ),
                    closedTravel
                        ? const SizedBox.shrink()
                        : IconButton(
                            onPressed: functionRemove,
                            icon: const Icon(Icons.delete,
                                color: Colors.redAccent),
                          ),
                  ],
                ),
                _buildInfoRow("Viagem", travel.numeroViagem ?? 'S/N'),
                _buildInfoRow("Título", travel.titulo ?? ''),
                _buildInfoRow("Motorista", motorista),
                _buildInfoRow("Situação", situacao),
              ],
            ),
          ],
        ),
        children: const [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("TExt"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value,
      {Color cor = Colors.black87}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: cor,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: cor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
