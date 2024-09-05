import 'package:rodocalc/app/data/models/expense_trip_model.dart';

class Trip {
  int? id;
  int? userId;
  int? veiculoId;

  String? dataHora;
  String? tipoSaidaChegada;

  String? origem;
  String? ufOrigem;
  String? destino;
  String? ufDestino;

  double? distancia;
  int? status;
  String? createdAt;
  String? updatedAt;

  List<ExpenseTrip>? expenseTrip;

  Trip({
    this.id,
    this.userId,
    this.veiculoId,
    this.dataHora,
    this.tipoSaidaChegada,
    this.origem,
    this.ufOrigem,
    this.destino,
    this.ufDestino,
    this.distancia,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.expenseTrip,
  });

  Trip.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    veiculoId = json['veiculo_id'];
    dataHora = json['data_hora'];
    tipoSaidaChegada = json['tipo_saida_chegada'];
    origem = json['origem'];
    ufOrigem = json['uf_origem'];
    destino = json['destino'];
    ufDestino = json['uf_destino'];
    distancia = _toDouble(json['distancia']);
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['despesas'] != null) {
      expenseTrip = <ExpenseTrip>[];
      json['despesas'].forEach((v) {
        expenseTrip!.add(ExpenseTrip.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['veiculo_id'] = veiculoId;
    data['data_hora'] = dataHora;
    data['tipo_saida_chegada'] = tipoSaidaChegada;
    data['origem'] = origem;
    data['uf_origem'] = ufOrigem;
    data['destino'] = destino;
    data['uf_destino'] = ufDestino;
    data['distancia'] = distancia;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (expenseTrip != null) {
      data['despesas'] = expenseTrip!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  double? _toDouble(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is double) {
      return value;
    }
    if (value is int) {
      return value.toDouble();
    }
    return double.tryParse(value.toString()) ?? 0.0;
  }

  bool isEmpty() {
    return id == null && origem == null && destino == null;
  }

  // Método para somar as despesas
  double get totalDespesas {
    if (expenseTrip == null) return 0.0;
    return expenseTrip!
        .fold(0.0, (sum, item) => sum + (item.valorDespesa ?? 0.0));
  }
}
