class CityState {
  String? cidadeEstado;

  CityState({
    this.cidadeEstado,
  });

  CityState.fromJson(Map<String, dynamic> json) {
    cidadeEstado = json['cidade_estado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cidade_estado'] = cidadeEstado;
    return data;
  }

  bool isEmpty() {
    return cidadeEstado == null;
  }
}
