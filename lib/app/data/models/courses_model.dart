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
    valor = json['valor'] != null ? json['valor'].toDouble() : null;
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['descricao'] = this.descricao;
    data['link'] = this.link;
    data['duracao'] = this.duracao;
    data['valor'] = this.valor;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
