class LongTermFuelTrim {
  double value;
  int bank;

  LongTermFuelTrim({
    this.value,
    this.bank,
  });

  /// function to get [value]
  double get getLongTermFuelTrimValue => value;

  /// function to get [bank]
  int get getLongTermFuelTrimBank => bank;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['bank'] = bank;

    return data;
  }
}
