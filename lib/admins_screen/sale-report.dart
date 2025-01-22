import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SaleReport extends StatefulWidget {
  const SaleReport({super.key});

  @override
  _SaleReportState createState() => _SaleReportState();
}

class _SaleReportState extends State<SaleReport> {
  String selectedPeriod = 'weekly';
  final List<double> dailySales = [10, 20, 30, 40, 50, 60, 70]; // Example data
  final List<double> weeklySales = [
    60,
    80,
    100,
    70,
    90,
    60,
    80
  ]; // Example data
  final List<double> monthlySales = [30, 50, 75, 55, 70, 35]; // Example data

  final List<String> days = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
  final List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];

  final Map<String, double> customerData = {
    "Income": 72,
    "Outcome": 28,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sales Reports"),
        backgroundColor: Colors.yellow[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Sales Report",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedPeriod,
              items: ['daily', 'weekly', 'monthly']
                  .map((period) => DropdownMenuItem(
                        value: period,
                        child: Text(period),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedPeriod = value!;
                });
              },
            ),
            const SizedBox(height: 10),
            _buildBarChart(),
            const SizedBox(height: 20),
            const Text(
              "Income and Outcome",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Information about the total income and outcome",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            _buildPieChart(),
            const SizedBox(height: 10),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  // Bar Chart Widget
  Widget _buildBarChart() {
    List<double> salesData;
    List<String> labels;

    switch (selectedPeriod) {
      case 'daily':
        salesData = dailySales;
        labels = days;
        break;
      case 'monthly':
        salesData = monthlySales;
        labels = months;
        break;
      case 'weekly':
      default:
        salesData = weeklySales;
        labels = days;
        break;
    }

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          barGroups: salesData
              .asMap()
              .entries
              .map(
                (entry) => BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value,
                      color: Colors.blueAccent,
                      width: 15,
                    )
                  ],
                ),
              )
              .toList(),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false), // Hide the grid lines
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      labels[value.toInt()],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false, // Hide the right side Y-axis
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles:
                    false, // Hide the top titles (outer numbers on the bar)
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true, // Show the left side Y-axis
                reservedSize: 30,
                interval: 20,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: customerData.entries.map((entry) {
            final index = customerData.keys.toList().indexOf(entry.key);
            final color = Colors.primaries[index % Colors.primaries.length];
            return PieChartSectionData(
              value: entry.value,
              title: "${entry.value.toInt()}%",
              color: color,
              radius: 50,
              titleStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          }).toList(),
          centerSpaceRadius: 40,
          sectionsSpace: 4,
        ),
      ),
    );
  }

  // Legend for the Donut Chart
  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: customerData.entries.map((entry) {
        final index = customerData.keys.toList().indexOf(entry.key);
        final color = Colors.primaries[index % Colors.primaries.length];
        return Row(
          children: [
            Container(
              width: 12,
              height: 12,
              color: color,
            ),
            const SizedBox(width: 4),
            Text(entry.key),
          ],
        );
      }).toList(),
    );
  }
}
