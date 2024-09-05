class ExpenseTrip {
  int? id;
  int? trechoPercorridoId;
  String? dataHora;
  String? descricao;
  int? valorDespesa;
  int? status;
  String? createdAt;
  String? updatedAt;

  ExpenseTrip({
    this.id,
    this.trechoPercorridoId,
    this.dataHora,
    this.descricao,
    this.valorDespesa,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  ExpenseTrip.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dataHora = json['data_hora'];
    trechoPercorridoId = json['rechopercorrido_id'];
    descricao = json['descricao'];
    valorDespesa = json['valor_despesa'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['data_hora'] = dataHora;
    data['trechopercorrido_id'] = trechoPercorridoId;
    data['descricao'] = descricao;
    data['valor_despesa'] = valorDespesa;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }

  bool isEmpty() {
    return id == null;
  }
}
