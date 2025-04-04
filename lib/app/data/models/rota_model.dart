class Rota {
  int? id;
  String? rota;
  int? planoId;
  String? createdAt;
  String? updatedAt;

  Rota({this.id, this.rota, this.planoId, this.createdAt, this.updatedAt});

  Rota.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rota = json['rota'];
    planoId = json['plano_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['rota'] = rota;
    data['plano_id'] = planoId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
