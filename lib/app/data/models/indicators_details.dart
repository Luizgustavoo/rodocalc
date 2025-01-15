class IndicacoesComDetalhes {
  int? id;
  String? nome;
  String? descricao;
  int? valorComissao;
  String? status;
  String? dataPagamento;

  IndicacoesComDetalhes(
      {this.id,
      this.nome,
      this.descricao,
      this.valorComissao,
      this.status,
      this.dataPagamento});

  IndicacoesComDetalhes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    descricao = json['descricao'];
    valorComissao = json['valor_comissao'];
    status = json['status'];
    dataPagamento = json['data_pagamento'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nome'] = nome;
    data['descricao'] = descricao;
    data['valor_comissao'] = valorComissao;
    data['status'] = status;
    data['data_pagamento'] = dataPagamento;
    return data;
  }
}
