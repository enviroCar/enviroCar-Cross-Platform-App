final Map<String, List<int>> obdATCommand = {
  'ATZ': [0x41, 0x54, 0x5A, 0x0D],
  'ATE0': [0x41, 0x54, 0x45, 0x30, 0x0D],
  'ATE1': [0x41, 0x54, 0x45, 0x31, 0x0D],
  'ATH1': [0x41, 0x54, 0x48, 0x31, 0x0D],
  'ATL0': [0x41, 0x54, 0x4C, 0x30, 0x0D],
  'ATSP0': [0x41, 0x54, 0x53, 0x50, 0x30, 0x0D]
};

final Map<String, List<int>> obdDataCommand = {
  'RPM': [0x30, 0x31, 0x30, 0x43, 0x0D],
  'SPD': [0x30, 0x31, 0x30, 0x44, 0x0D],
  'TMP': [0x30, 0x31, 0x30, 0x35, 0x0D],
  'VIN': [0x30, 0x31, 0x30, 0x30, 0x0D],
  'GEN': [0x30, 0x31, 0x30, 0x30, 0x0D]
};

const String returnSymbol = '\r';
const String promptSymbol = '>';
const String spaceSymbol = ' ';
const String ATCommandSymbol = 'AT';
const String colonSymbol = ':';

final Map<String, String> elm327CommandSymbol = {
  'reset': 'Z',
  'echo OFF': 'E0',
  'echo ON': 'E1',
  'headers ON': 'H1',
  'linefeeds off': 'L0',
  'repeat': '\r',
  'version ID': 'I',
  'protocol AUTO': 'SP0'
};

final Map<String, String> obdRequestSymbol = {
  'RPM':'010C',
  'SPD': '010D',
  'TMP': '0105',
  'VIN': '0902',
  'GEN': '0100'
};

enum Pid {
  CALCULATED_ENGINE_LOAD,
  SHORT_TERM_FUEL_TRIM_BANK_1,
  LONG_TERM_FUEL_TRIM_BANK_1,
  FUEL_PRESSURE,
  INTAKE_MAP,
  RPM,
  ENGINE_FUEL_RATE,
  SPEED,
  INTAKE_AIR_TEMP,
  MAF,
  TPS,
  O2_LAMBDA_PROBE_1_VOLTAGE,
  O2_LAMBDA_PROBE_2_VOLTAGE,
  O2_LAMBDA_PROBE_3_VOLTAGE,
  O2_LAMBDA_PROBE_4_VOLTAGE,
  O2_LAMBDA_PROBE_5_VOLTAGE,
  O2_LAMBDA_PROBE_6_VOLTAGE,
  O2_LAMBDA_PROBE_7_VOLTAGE,
  O2_LAMBDA_PROBE_8_VOLTAGE,
  O2_LAMBDA_PROBE_1_CURRENT,
  O2_LAMBDA_PROBE_2_CURRENT,
  O2_LAMBDA_PROBE_3_CURRENT,
  O2_LAMBDA_PROBE_4_CURRENT,
  O2_LAMBDA_PROBE_5_CURRENT,
  O2_LAMBDA_PROBE_6_CURRENT,
  O2_LAMBDA_PROBE_7_CURRENT,
  O2_LAMBDA_PROBE_8_CURRENT
}

final Map<Pid, String> pid = {
  Pid.CALCULATED_ENGINE_LOAD: '04',
  Pid.SHORT_TERM_FUEL_TRIM_BANK_1: '06',
  Pid.LONG_TERM_FUEL_TRIM_BANK_1: '07',
  Pid.FUEL_PRESSURE: '0A',
  Pid.INTAKE_MAP: '0B',
  Pid.RPM: '0C',
  Pid.ENGINE_FUEL_RATE: '5E',
  Pid.SPEED: '0D',
  Pid.INTAKE_AIR_TEMP: '0F',
  Pid.MAF: '10',
  Pid.TPS: '11',
  Pid.O2_LAMBDA_PROBE_1_VOLTAGE: '24',
  Pid.O2_LAMBDA_PROBE_2_VOLTAGE: '25',
  Pid.O2_LAMBDA_PROBE_3_VOLTAGE: '26',
  Pid.O2_LAMBDA_PROBE_4_VOLTAGE: '27',
  Pid.O2_LAMBDA_PROBE_5_VOLTAGE: '28',
  Pid.O2_LAMBDA_PROBE_6_VOLTAGE: '29',
  Pid.O2_LAMBDA_PROBE_7_VOLTAGE: '2A',
  Pid.O2_LAMBDA_PROBE_8_VOLTAGE: '2B',
  Pid.O2_LAMBDA_PROBE_1_CURRENT: '34',
  Pid.O2_LAMBDA_PROBE_2_CURRENT: '35',
  Pid.O2_LAMBDA_PROBE_3_CURRENT: '36',
  Pid.O2_LAMBDA_PROBE_4_CURRENT: '37',
  Pid.O2_LAMBDA_PROBE_5_CURRENT: '38',
  Pid.O2_LAMBDA_PROBE_6_CURRENT: '39',
  Pid.O2_LAMBDA_PROBE_7_CURRENT: '3A',
  Pid.O2_LAMBDA_PROBE_8_CURRENT: '3B'
};