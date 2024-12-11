import 'package:flutter/material.dart';
import '../api_service.dart'; // Assume you have a service to fetch data

class FootballDetailScreen extends StatefulWidget {
  final int resultId;

  FootballDetailScreen({required this.resultId});

  @override
  _FootballDetailScreenState createState() => _FootballDetailScreenState();
}

class _FootballDetailScreenState extends State<FootballDetailScreen> {
  late Future<Map<String, dynamic>> matchDetails;

  @override
  void initState() {
    super.initState();
    matchDetails = fetchMatchDetails(widget.resultId); // Call to the API
  }

  Future<Map<String, dynamic>> fetchMatchDetails(int resultId) async {
    final response = await ApiService().fetchResultDetails(resultId);
    if (response == null) {
      throw Exception('Failed to load match details');
    }
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Football Match Details'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: matchDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            String winner = data['goals_team1'] > data['goals_team2']
                ? data['team1_name']
                : data['goals_team2'] > data['goals_team1']
                ? data['team2_name']
                : 'Draw';

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  SizedBox(height: 20),
                  _buildMatchSummary(),
                  SizedBox(height: 20),
                  Divider(color: Colors.grey),
                  SizedBox(height: 20),
                  _buildTeamDetails(
                    teamName: data['team1_name'],
                    goals: data['goals_team1'],
                    isHome: true,
                  ),
                  SizedBox(height: 12),
                  _buildTeamDetails(
                    teamName: data['team2_name'],
                    goals: data['goals_team2'],
                    isHome: false,
                  ),
                  SizedBox(height: 20),
                  _buildWinnerSection(winner),
                ],
              ),
            );
          }
          return Center(child: Text('No match details found.'));
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      'Match Result:',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.blueAccent,
      ),
    );
  }

  Widget _buildMatchSummary() {
    return Text(
      'Match Summary:',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }

  Widget _buildTeamDetails({required String teamName, required int goals, required bool isHome}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          teamName,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isHome ? Colors.green : Colors.blue,
          ),
        ),
        Text(
          '$goals Goals',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildWinnerSection(String winner) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        winner == 'Draw'
            ? 'The match ended in a Draw.'
            : '$winner won the match!',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: winner == 'Draw' ? Colors.grey : Colors.green,
        ),
      ),
    );
  }
}
