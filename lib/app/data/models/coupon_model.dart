class Coupon {
  int? id;
  String? titulo;
  String? codigo;
  String? tipo;
  int? status;
  double? percentualDesconto;
  String? createdAt;
  String? updatedAt;
  String? disabledAt;

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

    // Tratar o campo percentualDesconto para aceitar int ou double
    percentualDesconto = json['percentual_desconto'] != null
        ? (json['percentual_desconto'] is int
            ? (json['percentual_desconto'] as int).toDouble()
            : json['percentual_desconto'] as double)
        : null;

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
