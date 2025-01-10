class Coupon {
  int? id;
  String? titulo;
  String? codigo;
  String? tipo;
  int? status;
  int? percentualDesconto;
  String? createdAt;
  String? updatedAt;
  Null disabledAt;

  Coupon(
      {this.id,
      this.titulo,
      this.codigo,
      this.tipo,
      this.status,
      this.percentualDesconto,
      this.createdAt,
      this.updatedAt,
      this.disabledAt});

  Coupon.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titulo = json['titulo'];
    codigo = json['codigo'];
    tipo = json['tipo'];
    status = json['status'];
    percentualDesconto = json['percentual_desconto'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    disabledAt = json['disabled_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['titulo'] = titulo;
    data['codigo'] = codigo;
    data['tipo'] = tipo;
    data['status'] = status;
    data['percentual_desconto'] = percentualDesconto;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['disabled_at'] = disabledAt;
    return data;
  }
}
