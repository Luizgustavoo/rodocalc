class Indication {
  int? id;
  int? pessoaId;
  String? nome;
  String? telefone;
  String? codigo;
  String? status;
  String? createdAt;
  String? updatedAt;

  Indication({
    this.id,
    this.pessoaId,
    this.nome,
    this.telefone,
    this.codigo,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  Indication.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pessoaId = json['pessoa_id'];
    nome = json['nome'];
    telefone = json['telefone'];
    codigo = json['codigo'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['pessoa_id'] = pessoaId;
    data['nome'] = nome;
    data['telefone'] = telefone;
    data['codigo'] = codigo;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['status'] = status;
    return data;
  }

  bool isEmpty() {
    return id == null && nome == null && telefone == null;
  }
}
