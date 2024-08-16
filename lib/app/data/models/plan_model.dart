class Plan {
  int? id;
  String? descricao;
  double? valor;
  int? quantidadeCadastrosPermitidos;
  int? duracaoPlanoDias;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? observacoes;
  String? gatewayPlanId;

  Plan(
      {this.id,
      this.descricao,
      this.valor,
      this.quantidadeCadastrosPermitidos,
      this.duracaoPlanoDias,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.gatewayPlanId,
      this.observacoes});

  Plan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    valor = (json['valor'] as num?)?.toDouble();
    quantidadeCadastrosPermitidos = json['quantidade_cadastros_permitidos'];
    duracaoPlanoDias = json['duracao_plano_dias'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    observacoes = json['observacoes'];
    gatewayPlanId = json['gateway_plan_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['descricao'] = this.descricao;
    data['valor'] = this.valor;
    data['quantidade_cadastros_permitidos'] =
        this.quantidadeCadastrosPermitidos;
    data['duracao_plano_dias'] = this.duracaoPlanoDias;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['observacoes'] = this.observacoes;
    data['gateway_plan_id'] = this.gatewayPlanId;
    return data;
  }
}
