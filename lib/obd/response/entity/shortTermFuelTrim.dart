class ShortTermFuelTrim {
  double value;
  int bank;

  ShortTermFuelTrim({
    this.value,
    this.bank,
  });

  /// function to get [value]
  double get getShortTermFuelTrimValue => value;

  /// function to get [bank]
  int get getShortTermFuelTrimBank => bank;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['bank'] = bank;

    return data;
  }
}
