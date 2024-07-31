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
  Null? observacoes;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['descricao'] = this.descricao;
    data['valor'] = this.valor;
    data['tipo'] = this.tipo;
    data['data'] = this.data;
    data['empresa'] = this.empresa;
    data['cidade'] = this.cidade;
    data['uf'] = this.uf;
    data['ddd'] = this.ddd;
    data['telefone'] = this.telefone;
    data['observacoes'] = this.observacoes;
    data['veiculo_id'] = this.veiculoId;
    return data;
  }
}
