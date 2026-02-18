import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';

class WeeklySummaryChart extends StatelessWidget {
  WeeklySummaryChart({super.key});

  final List<double> values = [70, 65, 85, 60, 75, 90, 68];

  final List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

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
                    sideTitles: SideTitles(showTitles: false)
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
                        return Text(days[value.toInt()]);
                      }
                    )
                  )
                ),
                barGroups: List.generate(values.length, (index){
                  return BarChartGroupData(
                    x: index,
                    barRods:[
                      BarChartRodData(
                        toY: values[index],
                        width: 20,
                        borderRadius: BorderRadius.circular(12.0),
                        color: (values[index] > 80)
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