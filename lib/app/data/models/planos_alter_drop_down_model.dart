class AlterPlanDropDown {
  int? id;
  int? planoId;
  String? plano;
  int? quantidadeLicencas;
  int? quantidadeVeiculos;

  AlterPlanDropDown(
      {this.planoId,
      this.id,
      this.plano,
      this.quantidadeLicencas,
      this.quantidadeVeiculos});

  AlterPlanDropDown.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    planoId = json['plano_id'];
    plano = json['plano'];
    quantidadeLicencas = json['quantidade_licencas'];
    quantidadeVeiculos = json['quantidade_veiculos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['plano_id'] = planoId;
    data['plano'] = plano;
    data['quantidade_licencas'] = quantidadeLicencas;
    data['quantidade_veiculos'] = quantidadeVeiculos;
    return data;
  }
}
