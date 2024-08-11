import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Import this if you are using PieChartData

import '../statsCard/statsCard.dart'; // Make sure this file contains your StatsCard widget
import '../pieChart/pieChartWidget.dart'; // Make sure this file contains your PieChartData widget
import '../table/tableData.dart';

class BigDashboardView extends StatelessWidget {
  final int totalUsers;
  final int totalChargers;
  final List<Map<String, dynamic>> totalProfit;
  final int sessionsToday;
  final int availableChargers;
  final int unavailableChargers;
  final int touchIndex;
  final Function(FlTouchEvent, PieTouchResponse?) touchCallback;
  final List<dynamic> users;

  BigDashboardView({
    required this.totalUsers,
    required this.totalChargers,
    required this.totalProfit,
    required this.sessionsToday,
    required this.availableChargers,
    required this.unavailableChargers,
    required this.touchIndex,
    required this.touchCallback,
    required this.users,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        StatsCard(
          totalUsers: totalUsers,
          totalChargers: totalChargers,
          totalProfit: totalProfit,
          sessionsToday: sessionsToday,
        ),
        //SizedBox(height: 24), // Adds space between the StatsCard and the row
        Row(
          children: [
            Expanded(
              child: Container(
                //margin: EdgeInsets.symmetric(horizontal: 8.0),
                //padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: PieChartDataa(
                  totalChargers: totalChargers,
                  availableChargers: availableChargers,
                  unavailableChargers: unavailableChargers,
                  touchIndex: touchIndex,
                  touchCallback: touchCallback,
                ),
              ),
            ),
            //SizedBox(width: 16), // Adds space between the PieChart and the table
            Expanded(
              child: UserTable(users: users),
            ),
          ],
        ),
      ],
    );
  }
}
