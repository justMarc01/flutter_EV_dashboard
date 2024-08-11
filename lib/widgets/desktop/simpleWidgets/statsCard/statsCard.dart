import 'package:flutter/material.dart';

class StatsCard extends StatefulWidget {
  final int totalUsers;
  final int totalChargers;
  final List<Map<String, dynamic>> totalProfit; // Updated type
  final int sessionsToday;

  StatsCard({
    required this.totalUsers,
    required this.totalChargers,
    required this.totalProfit, // List of transactions with amounts and timestamps
    required this.sessionsToday,
  });

  @override
  _StatsCardState createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCard> {
  DateTime _selectedMonth = DateTime.now();
  double _monthlyProfit = 0.0;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
    // Calculate profit for the current month on initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.totalProfit.isNotEmpty) {
        _updateMonthlyProfit();
      } else {
        print("Total Profit Data is not available at initState.");
      }
    });
  }

  @override
  void didUpdateWidget(covariant StatsCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the totalProfit data updates, recalculate the monthly profit
    if (oldWidget.totalProfit != widget.totalProfit) {
      _updateMonthlyProfit();
    }
  }

  Future<void> _updateMonthlyProfit() async {
    // Filter transactions based on the selected month
    final filteredTransactions = widget.totalProfit.where((transaction) {
      final timestamp = DateTime.parse(transaction['timestamp']);
      final isSameMonth = timestamp.year == _selectedMonth.year &&
          timestamp.month == _selectedMonth.month;

      return isSameMonth;
    }).toList();

    // Calculate profit for the selected month
    double monthlyProfit = 0.0;
    for (var transaction in filteredTransactions) {
      monthlyProfit += (transaction['amount'] as num).toDouble();
    }

    setState(() {
      _monthlyProfit =
          monthlyProfit * 0.1; // Apply your profit calculation logic
    });
  }

  void _pickMonth() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            hintColor: Colors.blue,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      setState(() {
        _selectedMonth = DateTime(selectedDate.year, selectedDate.month);
        _updateMonthlyProfit(); // Update profit after selecting a new month
      });
    }
  }

  Widget _buildStatCard({
    required IconData icon,
    required String count,
    required String percentage,
    required Color percentageColor,
    required String label,
    required Color iconBgColor,
    required Color borderColor,
    required bool isTrendingUp,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: borderColor, width: 1),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(8),
                  child: Icon(icon, color: Colors.black, size: 20),
                ),
                SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        isTrendingUp
                            ? Icons.trending_up_outlined
                            : Icons.trending_down_outlined,
                        size: 16,
                        color: percentageColor,
                      ),
                      SizedBox(width: 4),
                      Text(
                        percentage,
                        style: TextStyle(color: percentageColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  count,
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 15),
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfitStatCard({
    required IconData icon,
    required String count,
    required String percentage,
    required Color percentageColor,
    required String label,
    required Color iconBgColor,
    required Color borderColor,
    required bool isTrendingUp,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: borderColor, width: 1),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(8),
                  child: Icon(icon, color: Colors.black, size: 20),
                ),
                Spacer(),
                // Calendar Button with Circular Grey Background
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color set to white
                    borderRadius:
                        BorderRadius.circular(15), // Circular border radius
                    border: Border.all(
                        color: Colors.grey[400]!,
                        width: 1), // Grey border with specified width
                  ),
                  padding: EdgeInsets.fromLTRB(8, 4, 0, 4),
                  child: Row(
                    children: [
                      Text(
                        'Month',
                        style: TextStyle(
                          fontSize: 12, // Adjust font size as needed
                          fontWeight:
                              FontWeight.bold, // Optionally adjust font weight
                        ),
                      ),
                      //SizedBox(width: 3), // Space between the text and the icon
                      IconButton(
                        icon: Icon(Icons.calendar_today, color: Colors.black),
                        iconSize: 12,
                        onPressed: _pickMonth, // Call the _pickMonth function
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Container(
              width: 100,
              decoration: BoxDecoration(
                color: Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  Icon(
                    isTrendingUp
                        ? Icons.trending_up_outlined
                        : Icons.trending_down_outlined,
                    size: 16,
                    color: percentageColor,
                  ),
                  SizedBox(width: 4),
                  Text(
                    percentage,
                    style: TextStyle(color: percentageColor),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Text(
                  count,
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int profitInt = _monthlyProfit.toInt();
    return Container(
      margin:
          EdgeInsets.fromLTRB(0, 0, 0, 24), // Margin for the outer container
      decoration: BoxDecoration(
        color: Colors.white, // Background color of the outer container
        borderRadius: BorderRadius.circular(
            25), // Rounded corners for the outer container
      ),
      child: Container(
        margin: EdgeInsets.all(24),
        width: 600,
        height: 400,
        decoration: BoxDecoration(
          color: Colors.white, // Background color set to white
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  _buildStatCard(
                    icon: Icons.people_outline_outlined,
                    count: '${widget.totalUsers}',
                    percentage: '+25.5%',
                    percentageColor: Colors.green,
                    label: 'Users',
                    iconBgColor: Color(0xFFF8F8F8),
                    borderColor: Colors.grey,
                    isTrendingUp: true,
                  ),
                  _buildStatCard(
                    icon: Icons.charging_station_outlined,
                    count: '${widget.totalChargers}',
                    percentage: '+4.10%',
                    percentageColor: Colors.green,
                    label: 'Chargers',
                    iconBgColor: Color(0xFFF8F8F8),
                    borderColor: Colors.white,
                    isTrendingUp: true,
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: Colors.grey),
            Expanded(
              child: Row(
                children: [
                  _buildProfitStatCard(
                    icon: Icons.money_outlined,
                    count: "$profitInt \$",
                    percentage: '+5.1%',
                    percentageColor: Colors.green,
                    label: 'Monthly Profit',
                    iconBgColor: Color(0xFFF8F8F8),
                    borderColor: Colors.grey,
                    isTrendingUp: true,
                  ),
                  _buildStatCard(
                    icon: Icons.battery_charging_full_outlined,
                    count: '${widget.sessionsToday}',
                    percentage: '+2.3%',
                    percentageColor: Colors.green,
                    label: 'Sessions today',
                    iconBgColor: Color(0xFFF8F8F8),
                    borderColor: Colors.white,
                    isTrendingUp: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
