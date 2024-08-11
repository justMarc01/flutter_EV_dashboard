import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'pieChartData.dart';

class PieChartDataa extends StatelessWidget {
  final int totalChargers;
  final int availableChargers;
  final int unavailableChargers;
  final int touchIndex;
  final Function(FlTouchEvent, PieTouchResponse?) touchCallback;

  PieChartDataa({
    required this.totalChargers,
    required this.availableChargers,
    required this.unavailableChargers,
    required this.touchCallback,
    required this.touchIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 24, 0),
      padding: EdgeInsets.all(16),
      width: 400,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white, // Background color set to white
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Total Chargers',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 0),
          pieChartData(
            showingSections: () => showingSections(
                availableChargers: availableChargers,
                unavailableChargers: unavailableChargers,
                touchedIndex: touchIndex),
            touchCallback: touchCallback,
            totalChargers: totalChargers,
          ),
          Spacer(),
          Container(
            child: Column(
              children: [
                _buildLegendItem(
                  color: Colors.black,
                  label: 'Total',
                  value: totalChargers,
                ),
                SizedBox(height: 10),
                _buildLegendItem(
                  color: Color.fromRGBO(255, 208, 35, 1),
                  label: 'Available',
                  value: availableChargers,
                ),
                SizedBox(height: 10),
                _buildLegendItem(
                  color: Color.fromRGBO(47, 120, 238, 1),
                  label: 'Unavailable',
                  value: unavailableChargers,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections({
    required int availableChargers,
    required int unavailableChargers,
    required int touchedIndex,
  }) {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 18.0 : 16.0;
      final double radius = isTouched ? 30.0 : 20.0;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue,
            value: availableChargers.toDouble(),
            showTitle: false,
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Color.fromRGBO(255, 208, 35, 1),
            value: unavailableChargers.toDouble(),
            showTitle: false,
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        default:
          throw Exception('Invalid Index');
      }
    });
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required int value,
  }) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Text(
                '$value',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
