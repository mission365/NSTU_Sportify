import 'package:flutter/material.dart';

import 'ManageDepartmentPage.dart';
import 'ManageEventPage.dart';
import 'ManageMatchDetails.dart';
import 'ManageNotice.dart';
import 'ManageResults.dart';
import 'ViewRequestPage.dart';
import 'AddTournamentWinnerPage.dart';

class AdminDashboardPage extends StatefulWidget {
  final String token;
  final String username;

  AdminDashboardPage({Key? key, required this.username, required this.token})
      : super(key: key);

  @override
  _AdminDashboardPageState createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();

    _pages.addAll([
      ViewRequestsPage(token: widget.token),
      ManageDepartmentsPage(token: widget.token),
      ManageNoticesPage(token: widget.token),
      ManageEventsPage(token: widget.token),
      MatchDetailsPage(token: widget.token),
      ManageResultsPage(token: widget.token),
      AddTournamentWinnerPage(token: widget.token), // Add Tournament Winner Page
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard - ${widget.username}'),
        backgroundColor: Colors.indigo,
        actions: [
          PopupMenuButton<int>(
            onSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: Text('View Requests'),
              ),
              PopupMenuItem(
                value: 1,
                child: Text('Manage Departments'),
              ),
              PopupMenuItem(
                value: 2,
                child: Text('Manage Notices'),
              ),
              PopupMenuItem(
                value: 3,
                child: Text('Manage Events'),
              ),
              PopupMenuItem(
                value: 4,
                child: Text('Manage Matches'),
              ),
              PopupMenuItem(
                value: 5,
                child: Text('Manage Results'),
              ),
              PopupMenuItem(
                value: 6,
                child: Text('Add Tournament Winner'), // Add menu item for Tournament Winner
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigo,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.admin_panel_settings,
                      size: 40,
                      color: Colors.indigo,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Welcome, ${widget.username}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            ..._buildDrawerItems(),
          ],
        ),
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: _pages[_currentIndex],
      ),
    );
  }

  List<Widget> _buildDrawerItems() {
    final titles = [
      'View Requests',
      'Manage Departments',
      'Manage Notices',
      'Manage Events',
      'Manage Matches',
      'Manage Results',
      'Add Tournament Winner', // Add drawer item for Tournament Winner
    ];
    final icons = [
      Icons.view_list,
      Icons.apartment,
      Icons.notifications,
      Icons.event,
      Icons.sports,
      Icons.score,
      Icons.emoji_events, // Icon for Tournament Winner
    ];

    return List.generate(titles.length, (index) {
      return ListTile(
        leading: Icon(icons[index], color: Colors.indigo),
        title: Text(titles[index]),
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
          Navigator.pop(context); // Close the drawer
        },
      );
    });
  }
}
