List<int> stringToIntList(String data) {
  return data.codeUnits;
}

String intListToString(List<int> data) {
  return String.fromCharCodes(data);
}

List<String> intListToStringList(List<int> intListData, String splitSymbol) {
  final String value = String.fromCharCodes(intListData);
  final List<String> stringList = value.split(splitSymbol);
  return stringList;
}
