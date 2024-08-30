

class UserType {
  int? id;
  String? descricao;
  int? status;
  String? createdAt;
  String? updatedAt;

  UserType({
    this.id,
    this.descricao,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  UserType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status =
        json['status'] != null ? int.tryParse(json['status'].toString()) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['descricao'] = descricao;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['status'] = status;
    return data;
  }
}
