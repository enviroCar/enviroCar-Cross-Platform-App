import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';

import '../../constants.dart';
import '../titleWidget.dart';
import '../../models/chartData.dart';

class ChartWidget extends StatelessWidget {
  final String chartTitle;
  final double xInterval;
  final ChartData chartData;

  const ChartWidget(
      {@required this.chartTitle,
      @required this.xInterval,
      @required this.chartData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleWidget(title: chartTitle),
        SizedBox(
          height: 250,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 800,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: 20,
                  minY: 0,
                  maxY: 10,
                  titlesData: FlTitlesData(
                    // x-axis titles
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTitles: (value) {
                        if (value == 0.0) {
                          return '';
                        }
                        if (value == 20) {
                          return '';
                        }
                        return (xInterval * value).toStringAsFixed(1);
                      },
                    ),

                    // y-axis titles
                    leftTitles: SideTitles(
                      showTitles: true,
                      getTitles: (value) {
                        if (value == 10) {
                          return '';
                        }
                        return (chartData.dataInterval * value).toStringAsFixed(
                            chartData.dataInterval < 1 ? 3 : 1);
                      },
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      dotData: FlDotData(
                        show: false,
                      ),
                      show: true,
                      spots: chartData.dataPoints,
                      colors: [kSpringColor],
                      belowBarData: BarAreaData(
                        show: true,
                        colors: [kSpringColor.withOpacity(0.2)],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
