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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['classificados_id'] = this.classificadosId;
    data['arquivo'] = this.arquivo;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
