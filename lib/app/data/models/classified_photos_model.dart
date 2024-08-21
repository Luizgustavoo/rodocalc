class ClassifiedsPhotos {
  int? id;
  int? classificadosId;
  String? arquivo;
  String? createdAt;
  String? updatedAt;

  ClassifiedsPhotos(
      {this.id,
      this.classificadosId,
      this.arquivo,
      this.createdAt,
      this.updatedAt});

  ClassifiedsPhotos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    classificadosId = json['classificados_id'];
    arquivo = json['arquivo'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['classificados_id'] = classificadosId;
    data['arquivo'] = arquivo;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
