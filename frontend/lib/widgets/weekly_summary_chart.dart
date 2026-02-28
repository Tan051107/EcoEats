import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';

class WeeklySummaryChart extends StatelessWidget {
  const WeeklySummaryChart(
    {
      super.key,
      required this.summaryData
    }
  );

  final List<Map<String,dynamic>> summaryData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Column(
        children: [
          Expanded(
            child: BarChart(
              BarChartData(
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false
                    )
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false)
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false)
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value,meta){
                        int index = value.toInt();
                        final specificSummaryData = summaryData[index];
                        return Text(specificSummaryData["day"] ?? '');
                      }
                    )
                  )
                ),
                barGroups: List.generate(summaryData.length, (index){
                  final specificSummaryData = summaryData[index];
                  final double calories = (specificSummaryData["total_calories_kcal"] as num?)?.toDouble() ?? 0.0;
                  final bool isOverTarget = specificSummaryData["is_over_target"] ?? false;
                  return BarChartGroupData(
                    x: index,
                    barRods:[
                      BarChartRodData(
                        toY: calories,
                        width: 20.0 * (250 / summaryData.length).clamp(0.5, 1.0),
                        borderRadius: BorderRadius.circular(12.0),
                        color: isOverTarget
                              ?orange
                              :normalGreen
                      )
                    ]
                  );
                })
              )
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legendDot(normalGreen, "Under target"),
              SizedBox(width: 16),
              _legendDot(orange, "Over target"),
            ],
          )
        ],
      ),
    );
  }
}



Widget _legendDot(Color color, String text) {
  return Row(
    children: [
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      SizedBox(width: 6),
      Text(text),
    ],
  );
}