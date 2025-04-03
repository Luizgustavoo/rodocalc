import 'package:rodocalc/app/data/models/trip_model.dart';
import 'package:rodocalc/app/data/models/user_model.dart';

class Viagens {
  int? id;
  String? titulo;
  String? situacao;
  String? numeroViagem;
  int? motoristaId;
  int? veiculoId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  User? motorista;
  List<Trip>? trechos;

  Viagens(
      {this.id,
      this.titulo,
      this.situacao,
      this.numeroViagem,
      this.motoristaId,
      this.veiculoId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.motorista,
      this.trechos});

  Viagens.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titulo = json['titulo'];
    situacao = json['situacao'];
    numeroViagem = json['numero_viagem'];
    motoristaId = json['motorista_id'];
    veiculoId = json['veiculo_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    motorista =
        json['motorista'] != null ? User.fromJson(json['motorista']) : null;
    if (json['trechos'] != null) {
      trechos = <Trip>[];
      json['trechos'].forEach((v) {
        trechos!.add(Trip.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['titulo'] = titulo;
    data['situacao'] = situacao;
    data['numero_viagem'] = numeroViagem;
    data['motorista_id'] = motoristaId;
    data['veiculo_id'] = veiculoId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (motorista != null) {
      data['motorista'] = motorista!.toJson();
    }
    if (trechos != null) {
      data['trechos'] = trechos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
