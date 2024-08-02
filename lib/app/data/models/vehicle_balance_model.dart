class VehicleBalance {
  double? saldoTotal;
  dynamic entradasMesAtual;
  dynamic saidasMesAtual;

  dynamic entradasMesAnterior;
  dynamic saidasMesAnterior;

  String? variacaoEntradas;
  String? variacaoSaidas;

  VehicleBalance({
    this.saldoTotal,
    this.entradasMesAtual,
    this.saidasMesAtual,
    this.entradasMesAnterior,
    this.saidasMesAnterior,
    this.variacaoEntradas,
    this.variacaoSaidas,
  });

  VehicleBalance.fromJson(Map<String, dynamic> json) {
    // Converta saldo_total para double se for int
    saldoTotal = (json['saldo_total'] is int
        ? (json['saldo_total'] as int).toDouble()
        : json['saldo_total'] as double?);

    entradasMesAtual = (json['entradas_mes_atual'] is int
        ? (json['entradas_mes_atual'] as int).toDouble()
        : json['entradas_mes_atual'] as double?);

    saidasMesAtual = (json['saidas_mes_atual'] is int
        ? (json['saidas_mes_atual'] as int).toDouble()
        : json['saidas_mes_atual'] as double?);

    entradasMesAnterior = (json['entradas_mes_anterior'] is int
        ? (json['entradas_mes_anterior'] as int).toDouble()
        : json['entradas_mes_anterior'] as double?);

    saidasMesAnterior = (json['saidas_mes_anterior'] is int
        ? (json['saidas_mes_anterior'] as int).toDouble()
        : json['saidas_mes_anterior'] as double?);

    variacaoEntradas = json['variacao_entradas'];
    variacaoSaidas = json['variacao_saidas'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['saldo_total'] = saldoTotal;

    data['entradas_mes_atual'] = entradasMesAtual;
    data['saidas_mes_atual'] = saidasMesAtual;
    data['entradas_mes_anterior'] = entradasMesAnterior;
    data['saidas_mes_anterior'] = saidasMesAnterior;
    data['variacao_entradas'] = variacaoEntradas;
    data['variacao_saidas'] = variacaoSaidas;
    return data;
  }
}
