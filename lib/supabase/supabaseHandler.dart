import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  static final SupabaseClient _client = Supabase.instance.client;

  static Future<List<dynamic>> fetchTotalUsers() async {
    final response = await _client.from('users').select('name, expiry_date');
    return response as List<dynamic>;
  }

  static Future<List<dynamic>> fetchTotalChargers() async {
    final response = await _client.from('charge_points').select('id');
    return response as List<dynamic>;
  }

  static Future<List<dynamic>> fetchTotalProfit() async {
    final response =
        await _client.from('transactions').select('amount, timestamp');
    // double totalProfit = 0.0;
    // for (var row in response) {
    //   totalProfit += (row['amount'] as num).toDouble();
    // }
    //return (totalProfit * 0.1);
    return response as List<Map<String, dynamic>>;
  }

  static Future<List<dynamic>> fetchSessionsToday() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final response = await _client
        .from('sessions')
        .select()
        .gte('end_time', startOfDay.toUtc().toIso8601String())
        .lte('end_time', endOfDay.toUtc().toIso8601String());
    return response as List<dynamic>;
  }

  static Future<List<dynamic>> fetchAvailableChargers() async {
    final response =
        await _client.from('charge_points').select().eq('status', 'Available');
    return response as List<dynamic>;
  }
}
