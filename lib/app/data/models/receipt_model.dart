import 'package:rodocalc/app/data/models/charge_type_model.dart';
import 'package:rodocalc/app/data/models/expense_category_model.dart';
import 'package:rodocalc/app/data/models/expense_photos_model.dart';
import 'package:rodocalc/app/data/models/receipt_photos_model.dart';
import 'package:rodocalc/app/data/models/specific_type_expense_model.dart';

class Receipt {
  int? id;
  String? descricao;
  String? origem;
  String? destino;
  double? valor;
  double? quantidadeTonelada;
  int? veiculoId;
  int? tipoCargaId;
  String? createdAt;
  String? updatedAt;
  String? receiptDate;
  ChargeType? chargeType;
  List<ReceiptPhotos>? photos;

  Receipt({
    this.id,
    this.descricao,
    this.origem,
    this.destino,
    this.valor,
    this.quantidadeTonelada,
    this.veiculoId,
    this.createdAt,
    this.updatedAt,
    this.receiptDate,
    this.tipoCargaId,
    this.chargeType,
    this.photos,
  });

  Receipt.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    origem = json['origem'];
    destino = json['destino'];
    quantidadeTonelada = json['quantidade_tonelada'];
    valor = json['valor'];
    veiculoId = json['veiculo_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    receiptDate = json['data_receita'];
    tipoCargaId = json['tipocarga_id'];
    chargeType = json['tipocarga'] != null
        ? ChargeType.fromJson(json['tipocarga'])
        : null;
    if (json['fotos'] != null) {
      photos = <ReceiptPhotos>[];
      json['fotos'].forEach((v) {
        photos!.add(ReceiptPhotos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['descricao'] = descricao;
    data['origem'] = origem;
    data['destino'] = destino;
    data['quantidade_tonelada'] = quantidadeTonelada;
    data['valor'] = valor;
    data['veiculo_id'] = veiculoId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['data_receita'] = receiptDate;
    data['tipocarga_id'] = tipoCargaId;
    if (photos != null) {
      data['fotos'] = photos!.map((v) => v.toJson()).toList();
    }
    if (chargeType != null) {
      data['tipocarga'] = chargeType!.toJson();
    }
    return data;
  }
}
