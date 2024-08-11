import 'supabaseHandler.dart';

class DataFetcher {
  Future<Map<String, dynamic>> fetchData() async {
    try {
      final totalUsers = await DatabaseService.fetchTotalUsers();
      final totalChargers = await DatabaseService.fetchTotalChargers();
      final totalProfit = await DatabaseService.fetchTotalProfit();
      final sessionsToday = await DatabaseService.fetchSessionsToday();
      final availableChargers = await DatabaseService.fetchAvailableChargers();
      final users = await DatabaseService.fetchTotalUsers();
      return {
        'totalUsers': totalUsers.length,
        'totalChargers': totalChargers.length,
        'totalProfit': totalProfit,
        'sessionsToday': sessionsToday.length,
        'availableChargers': availableChargers.length,
        'unavailableChargers': totalChargers.length - availableChargers.length,
        'users' : users,
      };
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}
