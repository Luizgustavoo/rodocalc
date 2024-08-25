class ComissionIndicator {
  int? id;
  int? indicadorId;
  int? indicadoId;
  int? valorPlano;
  int? porcentagemComissao;
  int? valorComissao;
  String? status;
  String? dataPagamento;
  String? createdAt;
  String? updatedAt;

  ComissionIndicator(
      {this.id,
      this.indicadorId,
      this.indicadoId,
      this.valorPlano,
      this.porcentagemComissao,
      this.valorComissao,
      this.status,
      this.dataPagamento,
      this.createdAt,
      this.updatedAt});

  ComissionIndicator.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    indicadorId = json['indicador_id'];
    indicadoId = json['indicado_id'];
    valorPlano = json['valor_plano'];
    porcentagemComissao = json['porcentagem_comissao'];
    valorComissao = json['valor_comissao'];
    status = json['status'];
    dataPagamento = json['data_pagamento'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['indicador_id'] = this.indicadorId;
    data['indicado_id'] = this.indicadoId;
    data['valor_plano'] = this.valorPlano;
    data['porcentagem_comissao'] = this.porcentagemComissao;
    data['valor_comissao'] = this.valorComissao;
    data['status'] = this.status;
    data['data_pagamento'] = this.dataPagamento;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
