class People {
  int? id;
  String? nome;
  String? foto;
  String? ddd;
  String? telefone;
  String? cpf;
  String? apelido;
  String? cidade;
  String? uf;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? cupomParaIndicar;

  String? endereco;
  String? bairro;
  String? numeroCasa;
  String? cep;

  People({
    this.id,
    this.nome,
    this.foto,
    this.ddd,
    this.telefone,
    this.cpf,
    this.apelido,
    this.cidade,
    this.uf,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.cupomParaIndicar,
    this.endereco,
    this.bairro,
    this.numeroCasa,
    this.cep,
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
    uf = json['uf'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    cupomParaIndicar = json['cupom_para_indicar'];
    endereco = json['endereco'];
    bairro = json['bairro'];
    numeroCasa = json['numero_casa'];
    cep = json['cep'];
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
    data['uf'] = uf;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['cupom_para_indicar'] = cupomParaIndicar;
    data['endereco'] = endereco;
    data['bairro'] = bairro;
    data['numero_casa'] = numeroCasa;
    data['cep'] = cep;

    return data;
  }
}
