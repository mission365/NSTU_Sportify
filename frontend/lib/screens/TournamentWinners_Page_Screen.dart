import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TournamentWinnersPage extends StatefulWidget {
  @override
  _TournamentWinnersPageState createState() => _TournamentWinnersPageState();
}

class _TournamentWinnersPageState extends State<TournamentWinnersPage> {
  final _yearController = TextEditingController();
  List<dynamic> _winners = [];
  Map<String, dynamic>? _selectedTeamDetails;

  // Capitalize the first letter of a string
  String capitalize(String str) {
    if (str.isEmpty) return str;
    return '${str[0].toUpperCase()}${str.substring(1)}';
  }

  Future<void> _fetchWinners() async {
    final year = _yearController.text.trim();
    if (year.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a year')),
      );
      return;
    }

    // Clear previous results and team details
    setState(() {
      _winners = [];
      _selectedTeamDetails = null;
    });

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/tournament-winners/?year=$year'),
      );

      if (response.statusCode == 200) {
        List<dynamic> winners = json.decode(response.body);

        // Fetch and attach team name and capitalize sport
        for (var winner in winners) {
          winner['sport'] = capitalize(winner['sport']); // Capitalize sport name

          if (winner['team'] != null) {
            final teamResponse = await http.get(
              Uri.parse('http://127.0.0.1:8000/api/teams/${winner['team']}/'),
            );

            if (teamResponse.statusCode == 200) {
              final teamDetails = json.decode(teamResponse.body);
              winner['team_name'] = teamDetails['name'];
            } else {
              winner['team_name'] = 'Unknown Team';
            }
          } else {
            winner['team_name'] = 'No Team Assigned';
          }
        }

        setState(() {
          _winners = winners;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch winners for $year')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching winners: $e')),
      );
    }
  }

  Future<void> _fetchTeamDetails(int teamId) async {
    try {
      final teamResponse = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/teams/$teamId/'),
      );

      if (teamResponse.statusCode == 200) {
        final teamDetails = json.decode(teamResponse.body);

        final representativeId = teamDetails['representative_id'];
        final repResponse = await http.get(
          Uri.parse('http://127.0.0.1:8000/api/representatives/$representativeId/'),
        );

        String representativeName = 'Unknown';
        if (repResponse.statusCode == 200) {
          final repDetails = json.decode(repResponse.body);
          representativeName = repDetails['name'];
        }

        setState(() {
          _selectedTeamDetails = {
            ...teamDetails,
            'representative_name': representativeName,
          };
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch team details')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching team details: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tournament Winners', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 8.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Year Input
              Text(
                'Search Winners by Year',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.indigo),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _yearController,
                decoration: InputDecoration(
                  labelText: 'Enter Year',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: Icon(Icons.calendar_today, color: Colors.indigo),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _fetchWinners,
                icon: Icon(Icons.search, color: Colors.white),
                label: Text(
                  'Fetch Winners',
                  style: TextStyle(color: Colors.white),  // Set the text color to white
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Divider(height: 40, thickness: 2, color: Colors.grey[300]),

              // Display Winners
              Text(
                'Winners for Selected Year',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              if (_winners.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'No winners found for the selected year.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.redAccent),
                  ),
                ),
              ..._winners.map((winner) {
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                  child: ListTile(
                    title: Text(
                      '${winner['sport']}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Team: ${winner['team_name'] ?? 'Loading...'}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: ElevatedButton(
                      onPressed: winner['team'] != null
                          ? () => _fetchTeamDetails(winner['team'])
                          : null,
                      child: Text('View Details'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                );
              }).toList(),

              // Display Team Details
              if (_selectedTeamDetails != null) ...[
                Divider(height: 40, thickness: 2, color: Colors.grey[300]),
                Text(
                  'Team Details',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.indigo),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Team Name: ${_selectedTeamDetails!['name']}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                        Text('Sport: ${capitalize(_selectedTeamDetails!['sport'])}',
                            style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                        Text('Coach: ${_selectedTeamDetails!['coach']}',
                            style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                        Text('Representative: ${_selectedTeamDetails!['representative_name']}',
                            style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                        SizedBox(height: 10),
                        Text('Players:',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        ...(_selectedTeamDetails!['players'] as List<dynamic>)
                            .map((player) => Text(
                            '- ${player['name']} (Position: ${player['position']})',
                            style: TextStyle(fontSize: 16))),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
