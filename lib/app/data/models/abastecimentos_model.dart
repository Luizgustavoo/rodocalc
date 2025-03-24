import 'dart:convert';

class Abastecimento {
  final int? id;
  final DateTime dataAbastecimento;
  final int veiculoId;
  final double kmAnterior;
  final double kmAtual;
  final double? kmPercorrido;
  final double litros;
  final double consumo;
  final int userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final int? transacaoId;

  // Adicionando as novas propriedades
  final double mediaConsumoTotal; // Média de consumo de todos os abastecimentos
  final double
      somaKmPercorridos; // Soma dos km percorridos dos últimos 30 abastecimentos

  Abastecimento({
    this.id,
    required this.dataAbastecimento,
    required this.veiculoId,
    required this.kmAnterior,
    required this.kmAtual,
    this.kmPercorrido,
    required this.litros,
    required this.consumo,
    required this.userId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.transacaoId,
    this.mediaConsumoTotal = 0.0, // Inicialização com 0.0
    this.somaKmPercorridos = 0.0, // Inicialização com 0.0
  });

  factory Abastecimento.fromMap(Map<String, dynamic> map) {
    return Abastecimento(
      id: map['id'],
      dataAbastecimento: DateTime.parse(map['data_abastecimento']),
      veiculoId: map['veiculo_id'],
      kmAnterior: map['km_anterior'].toDouble(),
      kmAtual: map['km_atual'].toDouble(),
      kmPercorrido: map['km_percorrido']?.toDouble(),
      litros: map['litros'].toDouble(),
      consumo: map['consumo'].toDouble(),
      userId: map['user_id'],
      createdAt:
          map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt:
          map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
      deletedAt:
          map['deleted_at'] != null ? DateTime.parse(map['deleted_at']) : null,
      transacaoId: map['transacao_id'],
      // Adicionando o valor de mediaConsumoTotal e somaKmPercorridos
      mediaConsumoTotal: map['media_consumo_total']?.toDouble() ?? 0.0,
      somaKmPercorridos: map['soma_km_percorridos']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data_abastecimento': dataAbastecimento.toIso8601String(),
      'veiculo_id': veiculoId,
      'km_anterior': kmAnterior,
      'km_atual': kmAtual,
      'km_percorrido': kmPercorrido,
      'litros': litros,
      'consumo': consumo,
      'user_id': userId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'transacao_id': transacaoId,
      // Incluindo mediaConsumoTotal e somaKmPercorridos
      'media_consumo_total': mediaConsumoTotal,
      'soma_km_percorridos': somaKmPercorridos,
    };
  }

  String toJson() => json.encode(toMap());

  factory Abastecimento.fromJson(String source) =>
      Abastecimento.fromMap(json.decode(source));
}
