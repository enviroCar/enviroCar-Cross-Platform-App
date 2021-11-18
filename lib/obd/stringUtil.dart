List<int> stringToIntList(String stringData) {
  return stringData.codeUnits;
}

String intListToString(List<int> listIntData) {
  return String.fromCharCodes(listIntData);
}

List<String> intListToStringList(List<int> listIntData, String splitSymbol) {
  final String stringValue = String.fromCharCodes(listIntData);
  final List<String> stringList = stringValue.split(splitSymbol);
  return stringList;
}
