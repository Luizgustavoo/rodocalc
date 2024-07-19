class User {
  int? id;
  String? name;
  String? email;
  Null emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  String? dataInicio;
  int? status;
  String? contato;

  User(
      {this.id,
      this.name,
      this.email,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt,
      this.dataInicio,
      this.status,
      this.contato});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    dataInicio = json['data_inicio'];
    status = json['status'];
    contato = json['contato'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['data_inicio'] = dataInicio;
    data['status'] = status;
    data['contato'] = contato;
    return data;
  }
}
