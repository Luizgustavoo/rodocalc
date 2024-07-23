class People {
  int? id;
  String? nome;
  String? foto;
  String? ddd;
  String? telefone;
  String? cpf;
  String? apelido;
  String? cidade;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? cupomParaIndicar;

  People({
    this.id,
    this.nome,
    this.foto,
    this.ddd,
    this.telefone,
    this.cpf,
    this.apelido,
    this.cidade,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.cupomParaIndicar,
  });

  People.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    foto = json['foto'];
    ddd = json['ddd'];
    telefone = json['telefone'];
    cpf = json['cpf'];
    apelido = json['apelido'];
    cidade = json['cidade'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    cupomParaIndicar = json['cupom_para_indicar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nome'] = nome;
    data['foto'] = foto;
    data['ddd'] = ddd;
    data['telefone'] = telefone;
    data['cpf'] = cpf;
    data['apelido'] = apelido;
    data['cidade'] = cidade;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['cupom_para_indicar'] = cupomParaIndicar;

    return data;
  }
}
