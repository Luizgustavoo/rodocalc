class UserPlanDropdown {
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
  String? dataAssinaturaPlano;
  String? dataVencimentoPlano;
  int? quantidadeLicencas;
  double? valorPlano;
  int? totalVeiculosAtivos;

  UserPlanDropdown({
    this.id,
    this.descricao,
    this.valor,
    this.quantidadeCadastrosPermitidos,
    this.duracaoPlanoDias,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.observacoes,
    this.gatewayPlanId,
    this.dataAssinaturaPlano,
    this.dataVencimentoPlano,
    this.quantidadeLicencas,
    this.valorPlano,
    this.totalVeiculosAtivos,
  });

  UserPlanDropdown.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    valor = _convertToDouble(json['valor']);
    quantidadeCadastrosPermitidos = json['quantidade_cadastros_permitidos'];
    duracaoPlanoDias = json['duracao_plano_dias'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    observacoes = json['observacoes'];
    gatewayPlanId = json['gateway_plan_id'];
    dataAssinaturaPlano = json['data_assinatura_plano'];
    dataVencimentoPlano = json['data_vencimento_plano'];
    quantidadeLicencas = json['quantidade_licencas'];
    valorPlano = _convertToDouble(json['valor_plano']);
    totalVeiculosAtivos = json['total_veiculos_ativos'];
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
    data['data_assinatura_plano'] = dataAssinaturaPlano;
    data['data_vencimento_plano'] = dataVencimentoPlano;
    data['quantidade_licencas'] = quantidadeLicencas;
    data['valor_plano'] = valorPlano;
    data['total_veiculos_ativos'] = totalVeiculosAtivos;
    return data;
  }

  // Helper method to convert values to double
  double? _convertToDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return null; // or throw an error, or handle unexpected types as needed
  }
}
