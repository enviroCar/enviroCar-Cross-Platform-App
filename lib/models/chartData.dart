import 'package:fl_chart/fl_chart.dart';

/// class to draw a graph on the screen
///
/// the data points is a list of (x,y) coordinates that make the graph
/// and the data interval shows the unit difference between two corresponding
/// points on the y-axis
class ChartData {
  List<FlSpot> dataPoints = [];
  double dataInterval;
}
