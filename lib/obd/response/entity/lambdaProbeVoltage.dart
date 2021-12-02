class LambdaProbeVoltage {
  double voltage;
  double equivalenceRatio;

  LambdaProbeVoltage({
    this.voltage,
    this.equivalenceRatio,
  });

  /// function to get [voltage]
  double get getLongTermFuelTrimValue => voltage;

  /// function to get [equivalenceRatio]
  double get getLongTermFuelTrimBank => equivalenceRatio;

  Map<String, double> toJson() {
    final Map<String, double> data = <String, double>{};
    data['voltage'] = voltage;
    data['equivalenceRatio'] = equivalenceRatio;

    return data;
  }
}
