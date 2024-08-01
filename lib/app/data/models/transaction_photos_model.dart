import 'package:rodocalc/app/data/models/transactions_model.dart';

class TransactionsPhotos {
  int? id;
  int? transacaoId;
  Transacoes? transacoes;
  String? arquivo;
  String? createdAt;
  String? updatedAt;

  TransactionsPhotos({
    this.id,
    this.transacaoId,
    this.transacoes,
    this.arquivo,
    this.createdAt,
    this.updatedAt,
  });

  TransactionsPhotos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transacaoId = json['transacao_id'];
    transacoes = json['transacoes'] != null
        ? Transacoes.fromJson(json['transacoes'])
        : null;
    arquivo = json['arquivo'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['transacao_id'] = transacaoId;
    if (transacoes != null) {
      data['despesa'] = transacoes!.toJson();
    }
    data['arquivo'] = arquivo;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
