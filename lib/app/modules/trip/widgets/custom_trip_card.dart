import 'package:flutter/material.dart';
import 'package:rodocalc/app/data/models/trip_model.dart';
import 'package:rodocalc/app/utils/formatter.dart';

class CustomTripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback functionEdit;
  final VoidCallback functionRemove;
  final VoidCallback functionClose;
  final VoidCallback functionExpense;

  const CustomTripCard({
    super.key,
    required this.trip,
    required this.functionEdit,
    required this.functionRemove,
    required this.functionClose,
    required this.functionExpense,
  });

  @override
  Widget build(BuildContext context) {
    String trecho =
        "${trip.origem?.toUpperCase() ?? 'N/D'}-${trip.ufOrigem?.toUpperCase() ?? 'N/D'}/${trip.destino?.toUpperCase() ?? 'N/D'}-${trip.ufDestino?.toUpperCase() ?? 'N/D'}";

    String origem =
        "${trip.origem?.toUpperCase() ?? 'N/D'}-${trip.ufOrigem?.toUpperCase() ?? 'N/D'}";

    String destino =
        "${trip.destino?.toUpperCase() ?? 'N/D'}-${trip.ufDestino?.toUpperCase() ?? 'N/D'}";

    double despesas = (trip.totalDespesas ?? 0) / 100;
    String despesasFormatadas =
        FormattedInputers.formatValuePTBR(despesas.toString());

    String dataSaida = trip.dataHora?.trim().isNotEmpty == true
        ? FormattedInputers.formatApiDateHour(trip.dataHora.toString())
        : "N/D";

    String dataChegada = trip.dataHoraChegada?.trim().isNotEmpty == true
        ? FormattedInputers.formatApiDateHour(trip.dataHoraChegada.toString())
        : "N/D";

    String tempoGasto = calcularTempoGasto(trip.dataHora, trip.dataHoraChegada);

    bool closedTrip = (trip.situacao?.toUpperCase() ?? "") == "CLOSE";

    String motorista = "S/M";
    if (trip.user != null && trip.user!.people != null) {
      motorista = trip.user!.people!.nome!;
    }

    return Card(
      color: closedTrip ? Colors.orange.shade50 : Colors.green.shade50,
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
                    IconButton(
                      onPressed: functionEdit,
                      icon: const Icon(Icons.edit, color: Colors.blueAccent),
                    ),
                    IconButton(
                      onPressed: functionRemove,
                      icon: const Icon(Icons.photo_camera,
                          color: Color.fromARGB(255, 252, 181, 58)),
                    ),
                    IconButton(
                      onPressed: functionExpense,
                      icon: const Icon(Icons.attach_money_sharp,
                          color: Color.fromARGB(255, 20, 174, 3)),
                    ),
                    closedTrip
                        ? const SizedBox.shrink()
                        : IconButton(
                            onPressed: functionClose,
                            icon: const Icon(Icons.lock_sharp,
                                color: Color.fromARGB(255, 135, 135, 135)),
                          ),
                    IconButton(
                      onPressed: functionRemove,
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                    ),
                  ],
                ),
                _buildInfoRow("Viagem", trip.numeroViagem ?? 'S/N'),
                _buildInfoRow("Motorista", motorista),
                _buildInfoRow("Trecho", trecho),
                _buildInfoRow("Saída", dataSaida),
              ],
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                _buildInfoRow("Origem", "${origem ?? 0}"),
                _buildInfoRow("Destino", "${destino ?? 0} "),
                _buildInfoRow("Distância", "${trip.distancia ?? 0} km"),
                const Divider(),
                _buildInfoRow("Chegada", dataChegada),
                _buildInfoRow("KM Final Veículo", trip.kmFinal ?? "N/D"),
                _buildInfoRow(
                    "KM Rodado", calcularKmRodado(trip.km, trip.kmFinal)),
                if (tempoGasto.isNotEmpty)
                  _buildInfoRow("Tempo Gasto", tempoGasto),
                const Divider(),
                if (despesasFormatadas.isNotEmpty)
                  _buildInfoRow("Despesas", "R\$ $despesasFormatadas"),
                const Divider(),
                _buildInfoRow("Situação", closedTrip ? "FECHADO" : "ABERTO"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String calcularKmRodado(String? kmInicial, String? kmFinal) {
    if (kmInicial == null || kmFinal == null) {
      return "N/D";
    }

    try {
      double kmIni = double.tryParse(kmInicial.replaceAll('.', '')) ?? 0.0;
      double kmFin = double.tryParse(kmFinal.replaceAll('.', '')) ?? 0.0;

      if (kmIni == 0 || kmFin == 0) return "N/D";

      double kmRodado = (kmFin - kmIni) / 1000; // Conversão de metros para km
      return kmRodado >= 0
          ? "${kmRodado.toStringAsFixed(3)} km"
          : "Erro nos dados";
    } catch (e) {
      return "Dados inválidos";
    }
  }

  String calcularTempoGasto(String? dataSaida, String? dataChegada) {
    if (dataSaida == null || dataChegada == null) return "";

    try {
      DateTime saida = DateTime.parse(dataSaida);
      DateTime chegada = DateTime.parse(dataChegada);

      Duration diferenca = chegada.difference(saida);
      int dias = diferenca.inDays;
      int horas = diferenca.inHours.remainder(24);
      int minutos = diferenca.inMinutes.remainder(60);

      return "${dias > 0 ? '$dias dias, ' : ''}"
              "${horas > 0 ? '$horas horas, ' : ''}"
              "${minutos > 0 ? '$minutos minutos' : ''}"
          .trim();
    } catch (e) {
      return "Erro ao calcular";
    }
  }
}
