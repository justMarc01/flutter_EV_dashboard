import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class pieChartData extends StatelessWidget {
  final List<PieChartSectionData> Function() showingSections;
  final Function(FlTouchEvent, PieTouchResponse?) touchCallback;
  final int totalChargers;
  
  const pieChartData({
    Key? key,
    required this.showingSections,
    required this.touchCallback,
    required this.totalChargers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      
      width: 300,
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              pieTouchData: PieTouchData(touchCallback: touchCallback),
              sections: showingSections(),
              centerSpaceRadius: 60,
              sectionsSpace: 8,
              startDegreeOffset: 270,
              centerSpaceColor: Colors.grey[200],
            ),
          ),
          Center(
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$totalChargers',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Chargers',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
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