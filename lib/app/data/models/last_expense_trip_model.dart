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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['data_hora'] = this.dataHora;
    data['trechopercorrido_id'] = this.trechopercorridoId;
    data['descricao'] = this.descricao;
    data['valor_despesa'] = this.valorDespesa;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['origem'] = this.origem;
    data['destino'] = this.destino;
    return data;
  }
}
