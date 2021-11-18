import 'longTermFuelTrim.dart';
import 'shortTermFuelTrim.dart';
import 'lambdaVoltageProbe.dart';
import 'lambdaCurrentProbe.dart';

class Properties {
  double engineLoad;
  int fuelPressure;
  int intakeManifoldAbsolutePressure;
  int engineRPM;
  int speed;
  int intakeAirTemperature;
  double maf;
  int throttlePosition;
  LongTermFuelTrim longTermFuelTrim;
  ShortTermFuelTrim shortTermFuelTrim;
  LambdaProbeCurrent lambdaProbeCurrent;
  LambdaProbeVoltage lambdaProbeVoltage;

  /// function to set [engineLoad]
  set engineLoadResponse(double value) {
    engineLoad = value;
  }

  /// function to set [fuelPressure]
  set fuelPressureResponse(int value) {
    fuelPressure = value;
  }

  /// function to set [intakeManifoldAbsolutePressure]
  set intakeManifoldAbsolutePressureResponse(int intakeMap) {
    intakeManifoldAbsolutePressure = intakeMap;
  }

  /// function to set [engineRPM]
  set engineRpmResponse(int rpm) {
    engineRPM = rpm;
  }

  /// function to set [speed]
  set speedResponse(int v) {
    speed = v;
  }

  /// function to set [intakeAirTemperature]
  set intakeAirTemperatureResponse(int airTemp) {
    intakeAirTemperature = airTemp;
  }

  /// function to set [maf]
  set mafResponse(double mafValue) {
    maf = mafValue;
  }

  /// function to set [throttlePosition]
  set throttlePositionResponse(int position) {
    throttlePosition = position;
  }

  /// function to get [engineLoad]
  double get getEngineLoad => engineLoad;

  /// function to get [fuelPressure]
  int get getFuelPressure => fuelPressure;

  /// function to get [intakeManifoldAbsolutePressure]
  int get getIntakeMap => intakeManifoldAbsolutePressure;

  /// function to get [engineRPM]
  int get getEngineRpm => engineRPM;

  /// function to get [speed]
  int get getSpeed => speed;

  /// function to get [intakeAirTemperature]
  int get getIntakeAirTemperature => intakeAirTemperature;

  /// function to get [maf]
  double get getMaf => maf;

  /// function to get [throttlePosition]
  int get getThrottlePosition => throttlePosition;
}
