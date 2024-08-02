class Financial {
  int? id;
  String? descricao;
  double? valor;
  String? tipo;
  String? data;
  String? empresa;
  String? cidade;
  String? uf;
  String? ddd;
  String? telefone;
  Null observacoes;
  int? veiculoId;

  Financial(
      {this.id,
      this.descricao,
      this.valor,
      this.tipo,
      this.data,
      this.empresa,
      this.cidade,
      this.uf,
      this.ddd,
      this.telefone,
      this.observacoes,
      this.veiculoId});

  Financial.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    valor = json['valor'];
    tipo = json['tipo'];
    data = json['data'];
    empresa = json['empresa'];
    cidade = json['cidade'];
    uf = json['uf'];
    ddd = json['ddd'];
    telefone = json['telefone'];
    observacoes = json['observacoes'];
    veiculoId = json['veiculo_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['descricao'] = descricao;
    data['valor'] = valor;
    data['tipo'] = tipo;
    data['data'] = this.data;
    data['empresa'] = empresa;
    data['cidade'] = cidade;
    data['uf'] = uf;
    data['ddd'] = ddd;
    data['telefone'] = telefone;
    data['observacoes'] = observacoes;
    data['veiculo_id'] = veiculoId;
    return data;
  }
}
