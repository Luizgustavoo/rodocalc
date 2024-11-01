class LastExpenseTrip {
  int? id;
  String? dataHora;
  int? trechopercorridoId;
  String? descricao;
  int? valorDespesa;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? origem;
  String? destino;

  LastExpenseTrip(
      {this.id,
      this.dataHora,
      this.trechopercorridoId,
      this.descricao,
      this.valorDespesa,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.origem,
      this.destino});

  LastExpenseTrip.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dataHora = json['data_hora'];
    trechopercorridoId = json['trechopercorrido_id'];
    descricao = json['descricao'];
    valorDespesa = json['valor_despesa'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    origem = json['origem'];
    destino = json['destino'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['data_hora'] = dataHora;
    data['trechopercorrido_id'] = trechopercorridoId;
    data['descricao'] = descricao;
    data['valor_despesa'] = valorDespesa;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['origem'] = origem;
    data['destino'] = destino;
    return data;
  }
}
