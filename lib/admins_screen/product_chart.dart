import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ProductChart extends StatelessWidget {
  const ProductChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              barGroups: [
                BarChartGroupData(
                    x: 1,
                    barRods: [BarChartRodData(toY: 10, color: Colors.blue)]),
                BarChartGroupData(
                    x: 2,
                    barRods: [BarChartRodData(toY: 15, color: Colors.green)]),
                BarChartGroupData(
                    x: 3,
                    barRods: [BarChartRodData(toY: 12, color: Colors.red)]),
                BarChartGroupData(
                    x: 4,
                    barRods: [BarChartRodData(toY: 18, color: Colors.orange)]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
