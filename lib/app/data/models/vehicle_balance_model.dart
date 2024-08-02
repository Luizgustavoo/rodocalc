class VehicleBalance {
  double? saldoTotal;

  VehicleBalance({this.saldoTotal});

  VehicleBalance.fromJson(Map<String, dynamic> json) {
    // Converta saldo_total para double se for int
    saldoTotal = (json['saldo_total'] is int
        ? (json['saldo_total'] as int).toDouble()
        : json['saldo_total'] as double?);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['saldo_total'] = saldoTotal;
    return data;
  }
}
