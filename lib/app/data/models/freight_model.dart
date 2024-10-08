class Freight {
  int? id;
  String? origem;
  String? ufOrigem;
  String? destino;
  String? ufDestino;
  double? valorPedagio;
  double? distanciaKm;
  double? mediaKmL;
  double? precoCombustivel;
  double? valorRecebido;
  double? totalGastos;
  double? lucro;
  int? quantidadePneus;
  double? valorPneu;
  double? outrosGastos;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? userId;

  Freight({
    this.id,
    this.origem,
    this.ufOrigem,
    this.destino,
    this.ufDestino,
    this.valorPedagio,
    this.distanciaKm,
    this.mediaKmL,
    this.valorRecebido,
    this.precoCombustivel,
    this.quantidadePneus,
    this.valorPneu,
    this.outrosGastos,
    this.totalGastos,
    this.lucro,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.userId,
  });

  Freight.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    origem = json['origem'];
    ufOrigem = json['uf_origem'];
    destino = json['destino'];
    ufDestino = json['uf_destino'];
    valorPedagio = _toDouble(json['valor_pedagio']);
    distanciaKm = _toDouble(json['distancia_km']);
    mediaKmL = _toDouble(json['media_km_l']);
    precoCombustivel = _toDouble(json['preco_combustivel']);
    valorRecebido = _toDouble(json['valor_recebido']);
    quantidadePneus = json['quantidade_pneus'];
    valorPneu = _toDouble(json['valor_pneu']);
    outrosGastos = _toDouble(json['outros_gastos']);
    totalGastos = _toDouble(json['total_gastos']);
    lucro = _toDouble(json['lucro']);
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['origem'] = origem;
    data['uf_origem'] = ufOrigem;
    data['destino'] = destino;
    data['uf_destino'] = ufDestino;
    data['valor_pedagio'] = valorPedagio;
    data['distancia_km'] = distanciaKm;
    data['media_km_l'] = mediaKmL;
    data['preco_combustivel'] = precoCombustivel;
    data['quantidade_pneus'] = quantidadePneus;
    data['valor_pneu'] = valorPneu;
    data['valor_recebido'] = valorRecebido;
    data['outros_gastos'] = outrosGastos;
    data['total_gastos'] = totalGastos;
    data['lucro'] = lucro;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['user_id'] = userId;
    return data;
  }

  bool isEmpty() {
    return id == null && origem == null && destino == null;
  }

  double? _toDouble(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is double) {
      return value;
    }
    if (value is int) {
      return value.toDouble();
    }
    return double.tryParse(value.toString()) ?? 0.0;
  }
}
