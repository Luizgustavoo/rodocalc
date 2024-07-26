class SearchPlate {
  String? categoria;
  String? tipo;
  String? marca;
  String? modelo;
  int? anoModelo;
  String? combustivel;
  String? mesReferencia;
  String? codigoFipe;
  int? valor;
  Null chassi;
  Null renavam;
  bool? depreciado;
  String? categoriaVeiculoSGA;
  int? valorOriginal;
  int? mensalidade;
  int? cotaParticipativa;
  int? cotaMinima;
  int? valorProtegido;

  SearchPlate(
      {this.categoria,
      this.tipo,
      this.marca,
      this.modelo,
      this.anoModelo,
      this.combustivel,
      this.mesReferencia,
      this.codigoFipe,
      this.valor,
      this.chassi,
      this.renavam,
      this.depreciado,
      this.categoriaVeiculoSGA,
      this.valorOriginal,
      this.mensalidade,
      this.cotaParticipativa,
      this.cotaMinima,
      this.valorProtegido});

  SearchPlate.fromJson(Map<String, dynamic> json) {
    categoria = json['Categoria'];
    tipo = json['Tipo'];
    marca = json['Marca'];
    modelo = json['Modelo'];
    anoModelo = json['AnoModelo'];
    combustivel = json['Combustivel'];
    mesReferencia = json['MesReferencia'];
    codigoFipe = json['CodigoFipe'];
    valor = json['Valor'];
    chassi = json['Chassi'];
    renavam = json['Renavam'];
    depreciado = json['Depreciado'];
    categoriaVeiculoSGA = json['CategoriaVeiculoSGA'];
    valorOriginal = json['ValorOriginal'];
    mensalidade = json['Mensalidade'];
    cotaParticipativa = json['CotaParticipativa'];
    cotaMinima = json['CotaMinima'];
    valorProtegido = json['ValorProtegido'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Categoria'] = categoria;
    data['Tipo'] = tipo;
    data['Marca'] = marca;
    data['Modelo'] = modelo;
    data['AnoModelo'] = anoModelo;
    data['Combustivel'] = combustivel;
    data['MesReferencia'] = mesReferencia;
    data['CodigoFipe'] = codigoFipe;
    data['Valor'] = valor;
    data['Chassi'] = chassi;
    data['Renavam'] = renavam;
    data['Depreciado'] = depreciado;
    data['CategoriaVeiculoSGA'] = categoriaVeiculoSGA;
    data['ValorOriginal'] = valorOriginal;
    data['Mensalidade'] = mensalidade;
    data['CotaParticipativa'] = cotaParticipativa;
    data['CotaMinima'] = cotaMinima;
    data['ValorProtegido'] = valorProtegido;
    return data;
  }
}
