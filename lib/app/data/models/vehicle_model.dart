class Vehicle {
  int? id;
  int? pessoaId;
  String? marca;
  String? ano;
  String? modelo;
  String? placa;
  String? fipe;
  String? reboque;
  String? foto;
  String? createdAt;
  String? updatedAt;
  int? status;

  Vehicle({
    this.id,
    this.pessoaId,
    this.marca,
    this.ano,
    this.modelo,
    this.placa,
    this.fipe,
    this.reboque,
    this.foto,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pessoaId = json['pessoa_id'];
    marca = json['marca'];
    ano = json['ano'];
    modelo = json['modelo'];
    placa = json['placa'];
    fipe = json['fipe'];
    reboque = json['reboque'];
    foto = json['foto'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['id'] = pessoaId;
    data['marca'] = marca;
    data['ano'] = ano;
    data['modelo'] = modelo;
    data['placa'] = placa;
    data['fipe'] = fipe;
    data['reboque'] = reboque;
    data['foto'] = foto;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['status'] = status;
    return data;
  }

  bool isEmpty() {
    return id == null && marca == null && modelo == null;
  }
}
