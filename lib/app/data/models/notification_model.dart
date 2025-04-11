class Notifications {
  int? id;
  String? titulo;
  String? descricao;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? userId;

  Notifications(
      {this.id,
      this.titulo,
      this.descricao,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.userId});

  Notifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titulo = json['titulo'];
    descricao = json['descricao'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['titulo'] = titulo;
    data['descricao'] = descricao;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['user_id'] = userId;
    return data;
  }
}
