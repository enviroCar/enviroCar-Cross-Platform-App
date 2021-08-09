// Expanded(
//               child: BarChart(
//                 BarChartData(
//                   alignment: BarChartAlignment.spaceAround,
//                   maxY: 20,
//                   barTouchData: BarTouchData(
//                     enabled: false,
//                     touchTooltipData: BarTouchTooltipData(
//                       tooltipBgColor: Colors.transparent,
//                       tooltipPadding: const EdgeInsets.all(0),
//                       tooltipMargin: 8,
//                     ),
//                   ),
//                   titlesData: FlTitlesData(
//                     show: true,
//                     bottomTitles: SideTitles(
//                       showTitles: true,
//                       getTextStyles: (value) => const TextStyle(
//                         color: Color(0xff7589a2),
//                         fontWeight: FontWeight.bold,
//                         fontSize: 14,
//                       ),
//                       getTitles: (double value) {
//                         switch (value.toInt()) {
//                           case 0:
//                             return 'Mn';
//                           case 1:
//                             return 'Te';
//                           case 2:
//                             return 'Wd';
//                           case 3:
//                             return 'Tu';
//                           case 4:
//                             return 'Fr';
//                           case 5:
//                             return 'St';
//                           case 6:
//                             return 'Sn';
//                           default:
//                             return '';
//                         }
//                       },
//                     ),
//                     leftTitles: SideTitles(showTitles: false),
//                   ),
//                   borderData: FlBorderData(
//                     show: false,
//                   ),
//                   barGroups: [
//                     BarChartGroupData(
//                       x: 0,
//                       barRods: [
//                         BarChartRodData(
//                           y: 8,
//                           colors: [Colors.lightBlueAccent, kSpringColor],
//                         )
//                       ],
//                       showingTooltipIndicators: [0],
//                     ),
//                     BarChartGroupData(
//                       x: 1,
//                       barRods: [
//                         BarChartRodData(y: 10, colors: [
//                           Colors.lightBlueAccent,
//                           Colors.greenAccent
//                         ])
//                       ],
//                       showingTooltipIndicators: [0],
//                     ),
//                     BarChartGroupData(
//                       x: 2,
//                       barRods: [
//                         BarChartRodData(y: 14, colors: [
//                           Colors.lightBlueAccent,
//                           Colors.greenAccent
//                         ])
//                       ],
//                       showingTooltipIndicators: [0],
//                     ),
//                     BarChartGroupData(
//                       x: 3,
//                       barRods: [
//                         BarChartRodData(y: 15, colors: [
//                           Colors.lightBlueAccent,
//                           Colors.greenAccent
//                         ])
//                       ],
//                       showingTooltipIndicators: [0],
//                     ),
//                     BarChartGroupData(
//                       x: 3,
//                       barRods: [
//                         BarChartRodData(y: 13, colors: [
//                           Colors.lightBlueAccent,
//                           Colors.greenAccent
//                         ])
//                       ],
//                       showingTooltipIndicators: [0],
//                     ),
//                     BarChartGroupData(
//                       x: 3,
//                       barRods: [
//                         BarChartRodData(y: 10, colors: [
//                           Colors.lightBlueAccent,
//                           Colors.greenAccent
//                         ])
//                       ],
//                       showingTooltipIndicators: [0],
//                     ),
//                   ],
//                 ),
//               ),
//             ),