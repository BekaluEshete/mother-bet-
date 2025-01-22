import 'package:flutter/material.dart';
import 'package:mother/admins_screen/current_order.dart';
import 'package:mother/admins_screen/overview_card.dart';
import 'package:mother/admins_screen/popular_product_list.dart';
import 'package:mother/admins_screen/product_chart.dart';
import 'package:mother/admins_screen/sidebar.dart';
import 'package:mother/admins_screen/top_navbar.dart';
import 'package:mother/navigation/summary.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TopNavBar(),
      drawer: Sidebar(),
      body: Row(
        children: [
          // Expanded(
          //   flex: 2,
          //   child: Sidebar(),
          // ),
          Expanded(
            flex: 8,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OverviewSection(),
                    SizedBox(height: 20),

                    ///ProductChart(),
                    SummaryScreen(),
                    SizedBox(height: 20),
                    PopularProductsList(),
                    SizedBox(height: 20),
                    CurrentOrdersSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OverviewSection extends StatelessWidget {
  const OverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Section Header
            const Text(
              'Overview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Overview Cards (Responsive using Wrap)
            Wrap(
              spacing: 40,
              runSpacing: 22,
              alignment: WrapAlignment.spaceEvenly,
              children: [
                _buildOverviewColumn(
                  title: 'Active Users',
                  value: '420',
                  percentage: '22%',
                  percentageColor: Colors.green,
                ),
                const OverviewCard(
                  label: 'Customers',
                  value: '1,024',
                  change: '+3.2%',
                ),
                const OverviewCard(
                  label: 'Income',
                  value: '\$256K',
                  change: '+7.1%',
                ),
                const OverviewCard(
                  label: 'Orders',
                  value: '512',
                  change: '-1.8%',
                  changeColor: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build the first column
  Widget _buildOverviewColumn({
    required String title,
    required String value,
    required String percentage,
    Color percentageColor = Colors.black,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          percentage,
          style: TextStyle(fontSize: 16, color: percentageColor),
        ),
      ],
    );
  }
}

class CurrentOrdersSection extends StatelessWidget {
  const CurrentOrdersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final double paddingValue =
        MediaQuery.of(context).size.width > 600 ? 32.0 : 16.0;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.orangeAccent, Colors.deepOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(paddingValue),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Orders',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: const CurrentOrders(),
            ),
          ],
        ),
      ),
    );
  }
}
