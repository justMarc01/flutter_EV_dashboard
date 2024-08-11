import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase/data_fetcher.dart';
import 'widgets/desktop/simpleWidgets/screens/desktopMediumDashboard.dart';
import 'widgets/desktop/simpleWidgets/screens/desktopBigDashboard.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';

const supabaseUrl = 'https://gjiuhpvnfbpjjjglgzib.supabase.co';
const supabaseKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdqaXVocHZuZmJwampqZ2xnemliIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjIwMDg5NDEsImV4cCI6MjAzNzU4NDk0MX0.B2CDr48yxglPKG6uEfAt9OPj2K-ZmqVHSeW6Bb_SW70';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int totalUsers = 0;
  int totalChargers = 0;
  List<Map<String, dynamic>> totalProfit = [];
  int sessionsToday = 0;
  int availableChargers = 0;
  int unavailableChargers = 0;
  List<dynamic> users = [];
  int touchIndex = -1;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final dataFetcher = DataFetcher();
      final data = await dataFetcher.fetchData();

      setState(() {
        totalUsers = data['totalUsers'];
        totalChargers = data['totalChargers'];
        totalProfit = data['totalProfit'];
        sessionsToday = data['sessionsToday'];
        availableChargers = data['availableChargers'];
        unavailableChargers = data['unavailableChargers'];
        users = data['users'];
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdaptiveScaffold(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        body: (context) => Container(
          color: Colors.grey[300],
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Adjust padding as needed
            child: DashboardView(
              users: users,
              totalUsers: totalUsers,
              totalChargers: totalChargers,
              totalProfit: totalProfit,
              sessionsToday: sessionsToday,
              availableChargers: availableChargers,
              unavailableChargers: unavailableChargers,
              touchIndex: touchIndex,
              touchCallback:
                  (FlTouchEvent event, PieTouchResponse? pieTouchResponse) {
                setState(() {
                  if (!event.isInterestedForInteractions ||
                      pieTouchResponse == null ||
                      pieTouchResponse.touchedSection == null) {
                    touchIndex = -1;
                    return;
                  }
                  touchIndex =
                      pieTouchResponse.touchedSection!.touchedSectionIndex;
                });
              },
            ),
          ),
        ),
        smallBody: (context) => Container(
          color: Colors.grey[300],
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Adjust padding as needed
            child: DashboardView(
              users: users,
              totalUsers: totalUsers,
              totalChargers: totalChargers,
              totalProfit: totalProfit,
              sessionsToday: sessionsToday,
              availableChargers: availableChargers,
              unavailableChargers: unavailableChargers,
              touchIndex: touchIndex,
              touchCallback:
                  (FlTouchEvent event, PieTouchResponse? pieTouchResponse) {
                setState(() {
                  if (!event.isInterestedForInteractions ||
                      pieTouchResponse == null ||
                      pieTouchResponse.touchedSection == null) {
                    touchIndex = -1;
                    return;
                  }
                  touchIndex =
                      pieTouchResponse.touchedSection!.touchedSectionIndex;
                });
              },
            ),
          ),
        ),
        largeBody: (context) => Row(
          children: [
            Expanded(
              child: Container(
                color: Colors.grey[300],
                child: Padding(
                  padding:
                      const EdgeInsets.all(16.0), // Adjust padding as needed
                  child: BigDashboardView(
                    users: users,
                    totalUsers: totalUsers,
                    totalChargers: totalChargers,
                    totalProfit: totalProfit,
                    sessionsToday: sessionsToday,
                    availableChargers: availableChargers,
                    unavailableChargers: unavailableChargers,
                    touchIndex: touchIndex,
                    touchCallback: (FlTouchEvent event,
                        PieTouchResponse? pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchIndex = -1;
                          return;
                        }
                        touchIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
