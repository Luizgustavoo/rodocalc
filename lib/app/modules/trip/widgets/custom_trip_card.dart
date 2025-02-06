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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: functionEdit,
                    icon: const Icon(Icons.edit, color: Colors.blueAccent),
                  ),
                  closedTrip
                      ? const SizedBox.shrink()
                      : IconButton(
                          onPressed: functionClose,
                          icon: Icon(Icons.lock_sharp,
                              color: Colors.grey.shade700),
                        ),
                  IconButton(
                    onPressed: functionExpense,
                    icon: const Icon(Icons.monetization_on_outlined,
                        color: Colors.orange),
                  ),
                  IconButton(
                    onPressed: functionRemove,
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildInfoRow("Viagem", trip.numeroViagem ?? 'S/N'),
              _buildInfoRow("Motorista", motorista),
              _buildInfoRow("Saída", dataSaida),
              _buildInfoRow("KM Inicial Veículo", trip.km ?? "N/D"),
              Divider(
                endIndent: 10,
                indent: 10,
                height: 5,
                thickness: 1,
                color:
                    closedTrip ? Colors.orange.shade100 : Colors.green.shade100,
              ),
              _buildInfoRow("Trecho", trecho),
              _buildInfoRow("Distância", "${trip.distancia ?? 0} km"),
              Divider(
                endIndent: 10,
                indent: 10,
                height: 5,
                thickness: 1,
                color:
                    closedTrip ? Colors.orange.shade100 : Colors.green.shade100,
              ),
              _buildInfoRow("Chegada", dataChegada),
              _buildInfoRow("KM Final Veículo", trip.kmFinal ?? "N/D"),
              _buildInfoRow(
                  "KM Rodado", calcularKmRodado(trip.km, trip.kmFinal)),
              if (tempoGasto.isNotEmpty)
                _buildInfoRow("Tempo Gasto", tempoGasto),
              Divider(
                endIndent: 10,
                indent: 10,
                height: 5,
                thickness: 1,
                color:
                    closedTrip ? Colors.orange.shade100 : Colors.green.shade100,
              ),
              if (despesasFormatadas.isNotEmpty)
                _buildInfoRow("Despesas", "R\$ $despesasFormatadas"),
              Divider(
                endIndent: 10,
                indent: 10,
                height: 5,
                thickness: 1,
                color:
                    closedTrip ? Colors.orange.shade100 : Colors.green.shade100,
              ),
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
