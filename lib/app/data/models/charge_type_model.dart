class ChargeType {
  int? id;
  String? descricao;
  int? status;
  String? createdAt;
  String? updatedAt;

  ChargeType({
    this.id,
    this.descricao,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  ChargeType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['descricao'] = descricao;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;

    return data;
  }
}
