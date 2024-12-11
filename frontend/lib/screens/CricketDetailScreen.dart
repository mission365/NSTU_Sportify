import 'package:flutter/material.dart';
import '../api_service.dart';

class CricketDetailScreen extends StatefulWidget {
  final int resultId;

  CricketDetailScreen({required this.resultId});

  @override
  _CricketDetailScreenState createState() => _CricketDetailScreenState();
}

class _CricketDetailScreenState extends State<CricketDetailScreen> {
  late Future<Map<String, dynamic>> matchDetails;

  @override
  void initState() {
    super.initState();
    matchDetails = fetchMatchDetails(widget.resultId);
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
        title: Text('Cricket Match Details'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
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
            int runsTeam1 = data['runs_team1'];
            int runsTeam2 = data['runs_team2'];
            int wicketsTeam1 = data['wickets_team1'];
            int wicketsTeam2 = data['wickets_team2'];

            // Logic to determine the winner and how they won
            String winner = '';
            String margin = '';

            if (runsTeam1 > runsTeam2) {
              winner = data['team1_name'];
              margin = 'by ${runsTeam1 - runsTeam2} runs';
            } else if (runsTeam2 > runsTeam1) {
              winner = data['team2_name'];
              margin = 'by ${runsTeam2 - runsTeam1} runs';
            } else {
              // If runs are equal, check wickets
              if (wicketsTeam1 < wicketsTeam2) {
                winner = data['team1_name'];
                margin = 'by ${wicketsTeam2 - wicketsTeam1} wickets';
              } else if (wicketsTeam2 < wicketsTeam1) {
                winner = data['team2_name'];
                margin = 'by ${wicketsTeam1 - wicketsTeam2} wickets';
              } else {
                winner = 'Match Tied';
                margin = '';
              }
            }

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Winner Section
                    Text(
                      'Winner: $winner',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    if (margin.isNotEmpty)
                      Text(
                        'Won $margin',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                        ),
                      ),
                    SizedBox(height: 20),

                    // Teams Section
                    Text(
                      'Teams',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.greenAccent.shade100,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Team 1: ${data['team1_name']}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Runs: ${data['runs_team1']}',
                                  style: TextStyle(fontSize: 16, color: Colors.black),
                                ),
                                Text(
                                  'Wickets: ${data['wickets_team1']}',
                                  style: TextStyle(fontSize: 16, color: Colors.black),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Team 2: ${data['team2_name']}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Runs: ${data['runs_team2']}',
                                  style: TextStyle(fontSize: 16, color: Colors.black),
                                ),
                                Text(
                                  'Wickets: ${data['wickets_team2']}',
                                  style: TextStyle(fontSize: 16, color: Colors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(child: Text('No match details found.'));
        },
      ),
    );
  }
}
