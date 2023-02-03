import '../ascii_util.dart';
import '../string_util.dart';
import '../obdCommands.dart';
import 'entity/longTermFuelTrim.dart';
import 'entity/shortTermFuelTrim.dart';
import 'entity/lambdaProbeCurrent.dart';
import 'entity/lambdaProbeVoltage.dart';

class ObdResponseParseService {
  late List<int> buffer;
  List<String> stringList = [];

  ObdResponseParseService({
    required this.buffer,
  });

  double parseEngineLoad() {
    return (buffer[2] * 100.0) / 255.0;
  }

  int parseFuelPressure() {
    return buffer[2] * 3;
  }

  int parseIntakeMap() {
    return buffer[2];
  }

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

  int parseIntakeAirTemperature() {
    return buffer[2] - 40;
  }

  double parseMaf() {
    return (buffer[2] * 256 + buffer[3]) / 100.0;
  }

  int parseThrottlePosition() {
    return (buffer[2] * 100) / 255 as int;
  }

  ShortTermFuelTrim parseShortTermFuelTrim() {
    return ShortTermFuelTrim(value: (buffer[2] - 128) * (100 / 128), bank: 1);
  }

  LongTermFuelTrim parseLongTermFuelTrim() {
    return LongTermFuelTrim(value: (buffer[2] - 128) * (100 / 128), bank: 1);
  }

  LambdaProbeVoltage parseLambdaProbeVoltage() {
    return LambdaProbeVoltage(
      voltage: ((buffer[4] * 256) + buffer[5]) / 8192,
      equivalenceRatio: ((buffer[2] * 256) + buffer[3]) / 32768,
    );
  }

  LambdaProbeCurrent parseLambdaProbeCurrent() {
    return LambdaProbeCurrent(
      current: ((buffer[4] * 256) + buffer[5]) / 256 - 128,
      equivalenceRatio: ((buffer[2] * 256) + buffer[3]) / 32768,
    );
  }

  String parseVIN() {
    stringList = intListToStringList(buffer, colonSymbol);
    final List<String> stringDataList = [];
    final List<String> dataList2 =
        stringList[1].split(spaceSymbol).sublist(4, 7);
    stringDataList.addAll(dataList2);
    final List<String> dataList3 =
        stringList[2].split(spaceSymbol).sublist(1, 8);
    stringDataList.addAll(dataList3);
    final List<String> dataList4 =
        stringList[3].split(spaceSymbol).sublist(1, 8);
    stringDataList.addAll(dataList4);
    final List<int> intDataList = [];
    for (final String data in stringDataList) {
      intDataList.add(hexadecimalToDecimal(data));
    }
    return intListToString(intDataList);
  }
}
