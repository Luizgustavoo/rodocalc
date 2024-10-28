class SearchPlate {
  String? procedencia;
  String? municipio;
  String? uf;
  String? placa;
  String? chassi;
  Null situacaoDoChassi;
  String? marcaModelo;
  String? ano;
  Null capacidadeDeCarga;
  String? combustivel;
  String? cor;
  String? potencia;
  String? cilindradas;
  String? quantidadePassageiro;
  String? tipoMontagem;
  String? quantidadeDeEixos;
  String? pbt;
  String? cmt;
  String? tipoDeVeiculo;
  String? tipoCarroceria;
  String? nMotor;
  Null caixaCambio;
  Null eixoTraseiroDif;
  Null carroceria;

  SearchPlate(
      {this.procedencia,
      this.municipio,
      this.uf,
      this.placa,
      this.chassi,
      this.situacaoDoChassi,
      this.marcaModelo,
      this.ano,
      this.capacidadeDeCarga,
      this.combustivel,
      this.cor,
      this.potencia,
      this.cilindradas,
      this.quantidadePassageiro,
      this.tipoMontagem,
      this.quantidadeDeEixos,
      this.pbt,
      this.cmt,
      this.tipoDeVeiculo,
      this.tipoCarroceria,
      this.nMotor,
      this.caixaCambio,
      this.eixoTraseiroDif,
      this.carroceria});

  SearchPlate.fromJson(Map<String, dynamic> json) {
    procedencia = json['procedencia'];
    municipio = json['municipio'];
    uf = json['uf'];
    placa = json['placa'];
    chassi = json['chassi'];
    situacaoDoChassi = json['situacao_do_chassi'];
    marcaModelo = json['marca_modelo'];
    ano = json['ano'];
    capacidadeDeCarga = json['capacidade_de_carga'];
    combustivel = json['combustivel'];
    cor = json['cor'];
    potencia = json['potencia'];
    cilindradas = json['cilindradas'];
    quantidadePassageiro = json['quantidade_passageiro'];
    tipoMontagem = json['tipo_montagem'];
    quantidadeDeEixos = json['quantidade_de_eixos'];
    pbt = json['pbt'];
    cmt = json['cmt'];
    tipoDeVeiculo = json['tipo_de_veiculo'];
    tipoCarroceria = json['tipo_carroceria'];
    nMotor = json['n_motor'];
    caixaCambio = json['caixa_cambio'];
    eixoTraseiroDif = json['eixo_traseiro_dif'];
    carroceria = json['carroceria'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['procedencia'] = procedencia;
    data['municipio'] = municipio;
    data['uf'] = uf;
    data['placa'] = placa;
    data['chassi'] = chassi;
    data['situacao_do_chassi'] = situacaoDoChassi;
    data['marca_modelo'] = marcaModelo;
    data['ano'] = ano;
    data['capacidade_de_carga'] = capacidadeDeCarga;
    data['combustivel'] = combustivel;
    data['cor'] = cor;
    data['potencia'] = potencia;
    data['cilindradas'] = cilindradas;
    data['quantidade_passageiro'] = quantidadePassageiro;
    data['tipo_montagem'] = tipoMontagem;
    data['quantidade_de_eixos'] = quantidadeDeEixos;
    data['pbt'] = pbt;
    data['cmt'] = cmt;
    data['tipo_de_veiculo'] = tipoDeVeiculo;
    data['tipo_carroceria'] = tipoCarroceria;
    data['n_motor'] = nMotor;
    data['caixa_cambio'] = caixaCambio;
    data['eixo_traseiro_dif'] = eixoTraseiroDif;
    data['carroceria'] = carroceria;
    return data;
  }
}
