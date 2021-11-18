/// function to format date from String value
DateTime formatDate(String date) {
  final DateTime dateTime = DateTime(
    int.parse(date.substring(0, 4)), // year
    int.parse(date.substring(5, 7)), // month
    int.parse(date.substring(8, 10)), // day
    int.parse(date.substring(11, 13)), // hour
    int.parse(date.substring(14, 16)), // minute
    int.parse(date.substring(17, 19)), // second
  );
  return dateTime;
}
