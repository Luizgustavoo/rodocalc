class CityState {
  int? codigoIbge;
  String? cidadeEstado;

  CityState({
    this.cidadeEstado,
    this.codigoIbge,
  });

  CityState.fromJson(Map<String, dynamic> json) {
    cidadeEstado = json['cidade_estado'];
    codigoIbge = json['codigo_ibge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cidade_estado'] = cidadeEstado;
    data['codigo_ibge'] = codigoIbge;
    return data;
  }

  bool isEmpty() {
    return cidadeEstado == null;
  }
}
