import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserTable extends StatefulWidget {
  final List<dynamic> users;

  UserTable({required this.users});

  @override
  _UserTableState createState() => _UserTableState();
}

class _UserTableState extends State<UserTable> {
  late TextEditingController _searchController;
  late List<dynamic> _filteredUsers;
  String _selectedStatus = 'All';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredUsers = [];

    // Initialize the search controller and add listener
    _searchController.addListener(_updateFilteredUsers);

    // Check for users data in the post frame callback to ensure data is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.users.isNotEmpty) {
        _updateFilteredUsers();
      }
    });
  }

  @override
  void didUpdateWidget(covariant UserTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the users data has changed
    if (widget.users != oldWidget.users) {
      _updateFilteredUsers();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateFilteredUsers() {
    final query = _searchController.text.toLowerCase();
    final selectedStatus = _selectedStatus;

    setState(() {
      _filteredUsers = widget.users.where((user) {
        final name = user['name'] ?? '';
        final expiryDate = user['expiry_date'];
        final status = _getStatus(expiryDate, DateTime.now());

        final matchesName = name.toLowerCase().contains(query);
        final matchesStatus =
            selectedStatus == 'All' || selectedStatus == status;

        return matchesName && matchesStatus;
      }).toList();
    });
  }

  void _updateStatusFilter(String? newValue) {
    setState(() {
      _selectedStatus = newValue ?? 'All';
      _updateFilteredUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final currentDate = DateTime.now();

    if (widget.users.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Container(
      margin: EdgeInsets.fromLTRB(24, 0, 0, 0),
      padding: EdgeInsets.all(8.0),
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        //border: Border.all(color: Colors.grey, width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search by Name',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!, width: 1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: DropdownButton<String>(
                  value: _selectedStatus,
                  items: <String>['All', 'Active', 'Expired']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: _updateStatusFilter,
                  underline: SizedBox(),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(
                        label: Text(
                      'Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                    DataColumn(
                        label: Text(
                      'Expiry Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                    DataColumn(
                        label: Text(
                      'Status',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                  ],
                  rows: _filteredUsers.map((user) {
                    final expiryDate = user['expiry_date'];
                    final formattedDate = _formatDate(expiryDate, dateFormat);
                    final status = _getStatus(expiryDate, currentDate);
                    return DataRow(
                      cells: [
                        DataCell(Text(user['name'] ?? '')),
                        DataCell(Text(formattedDate)),
                        DataCell(Text(status)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic expiryDate, DateFormat dateFormat) {
    if (expiryDate == null) return '';
    try {
      final dateTime = DateTime.parse(expiryDate);
      return dateFormat.format(dateTime);
    } catch (e) {
      print('Error parsing date: $e');
      return '';
    }
  }

  String _getStatus(dynamic expiryDate, DateTime currentDate) {
    if (expiryDate == null) return 'Expired';
    try {
      final dateTime = DateTime.parse(expiryDate);
      return dateTime.isBefore(currentDate) ? 'Expired' : 'Active';
    } catch (e) {
      print('Error parsing date for status: $e');
      return 'Expired';
    }
  }
}
