class ExpenseCategory {
  int? id;
  String? descricao;
  int? status;
  int? userId;
  String? createdAt;
  String? updatedAt;

  ExpenseCategory({
    this.id,
    this.descricao,
    this.status,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  ExpenseCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    status = json['status'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['descricao'] = descricao;
    data['status'] = status;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
