class ObdResponseParseService {
  List<int> buffer;
  List<String> stringList;

  ObdResponseParseService({
    this.buffer,
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

}