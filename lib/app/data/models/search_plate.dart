class SearchPlate {
  String? procedencia;
  String? municipio;
  String? uf;
  String? placa;
  String? chassi;
  Null? situacaoDoChassi;
  String? marcaModelo;
  String? ano;
  Null? capacidadeDeCarga;
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
  Null? caixaCambio;
  Null? eixoTraseiroDif;
  Null? carroceria;

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['procedencia'] = this.procedencia;
    data['municipio'] = this.municipio;
    data['uf'] = this.uf;
    data['placa'] = this.placa;
    data['chassi'] = this.chassi;
    data['situacao_do_chassi'] = this.situacaoDoChassi;
    data['marca_modelo'] = this.marcaModelo;
    data['ano'] = this.ano;
    data['capacidade_de_carga'] = this.capacidadeDeCarga;
    data['combustivel'] = this.combustivel;
    data['cor'] = this.cor;
    data['potencia'] = this.potencia;
    data['cilindradas'] = this.cilindradas;
    data['quantidade_passageiro'] = this.quantidadePassageiro;
    data['tipo_montagem'] = this.tipoMontagem;
    data['quantidade_de_eixos'] = this.quantidadeDeEixos;
    data['pbt'] = this.pbt;
    data['cmt'] = this.cmt;
    data['tipo_de_veiculo'] = this.tipoDeVeiculo;
    data['tipo_carroceria'] = this.tipoCarroceria;
    data['n_motor'] = this.nMotor;
    data['caixa_cambio'] = this.caixaCambio;
    data['eixo_traseiro_dif'] = this.eixoTraseiroDif;
    data['carroceria'] = this.carroceria;
    return data;
  }
}
