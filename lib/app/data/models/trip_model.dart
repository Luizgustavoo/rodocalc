import 'package:rodocalc/app/data/models/expense_trip_model.dart';
import 'package:rodocalc/app/data/models/transactions_model.dart';
import 'package:rodocalc/app/data/models/trip_photos.dart';
import 'package:rodocalc/app/data/models/user_model.dart';

class Trip {
  int? id;
  int? userId;
  int? veiculoId;

  String? dataHora;
  String? dataHoraChegada;
  String? tipoSaidaChegada;

  String? origem;
  String? ufOrigem;
  String? destino;
  String? ufDestino;

  double? distancia;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? km;
  String? kmFinal;
  String? numeroViagem;
  String? situacao;
  String? quantidadeTonelada;
  int? tipoCargaId;

  List<ExpenseTrip>? expenseTrip;
  List<Transacoes>? transactions;

  List<TripPhotos>? photos;

  User? user;

  Trip({
    this.id,
    this.userId,
    this.veiculoId,
    this.dataHora,
    this.dataHoraChegada,
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
    this.transactions,
    this.km,
    this.kmFinal,
    this.numeroViagem,
    this.situacao,
    this.user,
    this.quantidadeTonelada,
    this.tipoCargaId,
    this.photos,
  });

  Trip.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    veiculoId = json['veiculo_id'];
    dataHora = json['data_hora'];
    dataHoraChegada = json['data_hora_chegada'];
    tipoSaidaChegada = json['tipo_saida_chegada'];
    origem = json['origem'];
    ufOrigem = json['uf_origem'];
    destino = json['destino'];
    ufDestino = json['uf_destino'];
    distancia = _toDouble(json['distancia']);
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    km = json['km'];
    kmFinal = json['km_final'];
    numeroViagem = json['numero_viagem'];
    quantidadeTonelada = json['quantidade_tonelada'];
    tipoCargaId = json['tipocarga_id'];
    situacao = json['situacao'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['despesas'] != null) {
      expenseTrip = <ExpenseTrip>[];
      json['despesas'].forEach((v) {
        expenseTrip!.add(ExpenseTrip.fromJson(v));
      });
    }
    if (json['transacoes'] != null) {
      transactions = <Transacoes>[];
      json['transacoes'].forEach((v) {
        transactions!.add(Transacoes.fromJson(v));
      });
    }

    if (json['fotostrecho'] != null) {
      photos = <TripPhotos>[];
      json['fotostrecho'].forEach((v) {
        photos!.add(TripPhotos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['veiculo_id'] = veiculoId;
    data['data_hora'] = dataHora;
    data['data_hora_chegada'] = dataHoraChegada;
    data['tipo_saida_chegada'] = tipoSaidaChegada;
    data['origem'] = origem;
    data['uf_origem'] = ufOrigem;
    data['destino'] = destino;
    data['uf_destino'] = ufDestino;
    data['distancia'] = distancia;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['km'] = km;
    data['km_final'] = kmFinal;
    data['numero_viagem'] = numeroViagem;
    data['situacao'] = situacao;
    data['quantidade_tonelada'] = quantidadeTonelada;
    data['tipo_carga_id'] = tipoCargaId;
    if (expenseTrip != null) {
      data['despesas'] = expenseTrip!.map((v) => v.toJson()).toList();
    }
    if (transactions != null) {
      data['transacoes'] = transactions!.map((v) => v.toJson()).toList();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }

    if (photos != null) {
      data['fotostrecho'] = photos!.map((v) => v.toJson()).toList();
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
