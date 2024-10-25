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
  int? minLicencas;
  int? posts;
  int? descontoMensal;
  int? descontoAnual;
  String? corTexto;
  String? corCard;

  Plan({
    this.id,
    this.descricao,
    this.valor,
    this.quantidadeCadastrosPermitidos,
    this.duracaoPlanoDias,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.gatewayPlanId,
    this.observacoes,
    this.minLicencas,
    this.corTexto,
    this.corCard,
    this.posts,
    this.descontoMensal,
    this.descontoAnual,
  });

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
    minLicencas = json['min_licencas'];
    corTexto = json['cor_texto'];
    corCard = json['cor_card'];
    posts = json['posts'];
    descontoMensal = json['desconto_mensal'];
    descontoAnual = json['desconto_anual'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['descricao'] = descricao;
    data['valor'] = valor;
    data['quantidade_cadastros_permitidos'] = quantidadeCadastrosPermitidos;
    data['duracao_plano_dias'] = duracaoPlanoDias;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['observacoes'] = observacoes;
    data['gateway_plan_id'] = gatewayPlanId;
    data['min_licencas'] = minLicencas;
    data['cor_texto'] = corTexto;
    data['cor_card'] = corCard;
    data['posts'] = posts;
    data['desconto_mensal'] = descontoMensal;
    data['desconto_anual'] = descontoAnual;
    return data;
  }
}
