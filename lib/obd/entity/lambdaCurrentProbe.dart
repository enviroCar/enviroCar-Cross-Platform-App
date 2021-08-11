class LambdaProbeCurrent {
  double current;
  double equivalenceRatio;

  LambdaProbeCurrent({
    this.current,
    this.equivalenceRatio
  });

  /// function to get [current]
  double get getLongTermFuelTrimValue => current;

  /// function to get [equivalenceRatio]
  double get getLongTermFuelTrimBank => equivalenceRatio;

  Map<String, double> toJson() {
    final Map<String, double> data = <String, double>{};
    data['current'] = current;
    data['equivalenceRatio'] = equivalenceRatio;

    return data;
  }
}