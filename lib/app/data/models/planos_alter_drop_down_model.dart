class AlterPlanDropDown {
  int? planoId;
  String? plano;
  int? quantidadeLicencas;
  int? quantidadeVeiculos;

  AlterPlanDropDown(
      {this.planoId,
      this.plano,
      this.quantidadeLicencas,
      this.quantidadeVeiculos});

  AlterPlanDropDown.fromJson(Map<String, dynamic> json) {
    planoId = json['plano_id'];
    plano = json['plano'];
    quantidadeLicencas = json['quantidade_licencas'];
    quantidadeVeiculos = json['quantidade_veiculos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plano_id'] = this.planoId;
    data['plano'] = this.plano;
    data['quantidade_licencas'] = this.quantidadeLicencas;
    data['quantidade_veiculos'] = this.quantidadeVeiculos;
    return data;
  }
}
