import 'package:flutter/material.dart';
import 'package:frontend/screens/Admin/AdminDashboardPage.dart';
import 'package:frontend/screens/AuthManager.dart';
import 'package:frontend/screens/RepresentativeDashboard.dart';
import 'package:frontend/screens/login.dart';
import 'package:provider/provider.dart';
import 'screens/home.dart';
import 'screens/team_list_screen.dart';
import 'screens/player_list_screen.dart';
import 'screens/event_list_screen.dart';
import 'screens/match_details_screen.dart';
import 'screens/TournamentWinners_Page_Screen.dart';
import 'screens/result_list_screen.dart';
import 'screens/standing_list_screen.dart';
import 'screens/notice_list_screen.dart';
import 'screens/representative_list.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthManager(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NSTU Sportify',
      theme: ThemeData(
        primarySwatch: Colors.blue,  // Olympics-style blue
        scaffoldBackgroundColor: Colors.white,  // Clean white background
        fontFamily: 'Roboto',  // Custom font (Roboto or any other)
        textTheme: TextTheme(
          displayLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.black),  // Replaces headline1
          headlineMedium: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.blue),  // Replaces headline6
          bodyLarge: TextStyle(fontSize: 16.0, color: Colors.grey[800]),  // Replaces bodyText1
        ),
      ),
      home: HomeScreen(),  // Set HomeScreen from home.dart
      routes: {
        '/teams': (context) => TeamListScreen(),
        '/players': (context) => PlayerListScreen(),
        '/events': (context) => EventListScreen(),
        '/schedule': (context) => MatchDetailsScreen(),
        '/winners': (context) => TournamentWinnersPage(),
        '/results': (context) => ResultListScreen(),
        '/standings': (context) => StandingListScreen(),
        '/notices': (context) => NoticeListScreen(),
        '/representatives': (context) => RepresentativeList(),
        '/login':(context) => LoginPage(),
        '/admin-dashboard': (context) {
          final authManager = Provider.of<AuthManager>(context, listen: false);
          return AdminDashboardPage(username: authManager.username,token: authManager.token);
        },
        '/representativesdashboard': (context){
          final authManager = Provider.of<AuthManager>(context, listen: false);
          return TestRepresentative(username: authManager.username,token: authManager.token);
        },
      },
    );
  }
}
