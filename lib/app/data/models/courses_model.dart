class Courses {
  int? id;
  String? descricao;
  String? link;
  String? duracao;
  double? valor;
  int? status;
  String? createdAt;
  String? updatedAt;

  Courses(
      {this.id,
      this.descricao,
      this.link,
      this.duracao,
      this.valor,
      this.status,
      this.createdAt,
      this.updatedAt});

  Courses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    link = json['link'];
    duracao = json['duracao'];
    valor = json['valor']?.toDouble();
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['descricao'] = descricao;
    data['link'] = link;
    data['duracao'] = duracao;
    data['valor'] = valor;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
