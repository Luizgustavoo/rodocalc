import 'package:flutter/material.dart';
import 'package:rodocalc/app/data/models/trip_model.dart';
import 'package:rodocalc/app/utils/formatter.dart';

class CustomTripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback functionEdit;
  final VoidCallback functionRemove;
  final VoidCallback functionClose;

  const CustomTripCard({
    super.key,
    required this.trip,
    required this.functionEdit,
    required this.functionRemove,
    required this.functionClose,
  });

  @override
  Widget build(BuildContext context) {
    String trecho =
        "${trip.origem?.toUpperCase() ?? 'N/D'}-${trip.ufOrigem?.toUpperCase() ?? 'N/D'} / "
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

    // Cálculo de tempo de viagem
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          // Adicionado para permitir rolagem
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      "Viagem: ${trip.numeroViagem ?? 'S/N'}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: functionEdit,
                    icon: const Icon(Icons.edit, color: Colors.blueAccent),
                  ),
                  IconButton(
                    onPressed: functionRemove,
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                  ),
                  closedTrip
                      ? const SizedBox.shrink()
                      : IconButton(
                          onPressed: functionClose,
                          icon:
                              const Icon(Icons.close, color: Colors.redAccent),
                        ),
                ],
              ),
              const SizedBox(height: 12),
              _buildInfoRow("Motorista", motorista),
              _buildInfoRow("KM Veículo", trip.km ?? "N/D"),
              _buildInfoRow("Trecho", trecho),
              _buildInfoRow("Saída", dataSaida),
              _buildInfoRow("Chegada", dataChegada),
              _buildInfoRow("Distância", "${trip.distancia ?? 0} km"),
              if (tempoGasto.isNotEmpty)
                _buildInfoRow("Tempo Gasto", tempoGasto),
              if (despesasFormatadas.isNotEmpty)
                _buildInfoRow("Despesas", "R\$ $despesasFormatadas"),
              _buildInfoRow("Situação", closedTrip ? "FECHADO" : "ABERTO"),
            ],
          ),
        ),
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
