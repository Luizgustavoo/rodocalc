class Courses {
  int? id;
  String? titulo;
  String? descricao;
  String? imagem;
  String? link;
  String? duracao;
  double? valor;
  int? status;
  String? createdAt;
  String? updatedAt;

  Courses(
      {this.id,
      this.titulo,
      this.descricao,
      this.imagem,
      this.link,
      this.duracao,
      this.valor,
      this.status,
      this.createdAt,
      this.updatedAt});

  Courses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titulo = json['titulo'];
    descricao = json['descricao'];
    imagem = json['imagem'];
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
    data['titulo'] = titulo;
    data['descricao'] = descricao;
    data['imagem'] = imagem;
    data['link'] = link;
    data['duracao'] = duracao;
    data['valor'] = valor;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
