import 'ascii_util.dart';
import 'obdCommands.dart';
import 'string_util.dart';

class ObdResponseParseService {
  List<int> buffer;
  List<String> stringList;

  ObdResponseParseService({
    this.buffer,
  });

  double parseRPM() {
    stringList = intListToStringList(buffer, spaceSymbol);
    return hexadecimalToDecimal(stringList[2] + stringList[3]) / 4;
  }
  
  int parseSpeed() {
    stringList = intListToStringList(buffer, spaceSymbol);
    return hexadecimalToDecimal(stringList[2]);
  }

  double parseFuelLevel() {
    stringList = intListToStringList(buffer, spaceSymbol);
    return (hexadecimalToDecimal(stringList[2]) * 100.0) / 255.0;
  }

  int parseTemperature() {
    stringList = intListToStringList(buffer, spaceSymbol);
    return hexadecimalToDecimal(stringList[2]) - 40;
  }

  String parseVIN() {
    stringList = intListToStringList(buffer, colonSymbol);
    final List<String> stringDataList = [];
    final List<String> dataList2 = stringList[1].split(spaceSymbol).sublist(4, 7);
    stringDataList.addAll(dataList2);
    final List<String> dataList3 = stringList[2].split(spaceSymbol).sublist(1, 8);
    stringDataList.addAll(dataList3);
    final List<String> dataList4 = stringList[3].split(spaceSymbol).sublist(1, 8);
    stringDataList.addAll(dataList4);
    final List<int> intDataList = [];
    for(final String data in stringDataList) {
      intDataList.add(hexadecimalToDecimal(data));
    }
    return intListToString(intDataList);
  }

}