import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddTournamentWinnerPage extends StatefulWidget {
  final String token; // Admin token for authorization

  const AddTournamentWinnerPage({Key? key, required this.token})
      : super(key: key);

  @override
  _AddTournamentWinnerPageState createState() => _AddTournamentWinnerPageState();
}

class _AddTournamentWinnerPageState extends State<AddTournamentWinnerPage> {
  final _yearController = TextEditingController(); // Input field for year
  String? _selectedSport; // Dropdown for sport
  String? _selectedTeam; // Dropdown for team
  List<dynamic> _teams = []; // List of teams fetched from the API

  @override
  void initState() {
    super.initState();
    _fetchTeams(); // Fetch the team list on page load
  }

  Future<void> _fetchTeams() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/teams/'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _teams = json.decode(response.body);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch teams.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching teams: $e')),
      );
    }
  }

  Future<void> _submitWinner() async {
    final year = _yearController.text.trim();
    if (year.isEmpty || _selectedSport == null || _selectedTeam == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields.')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/tournament-winners/'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'year': year,
          'sport': _selectedSport,
          'team_id': _selectedTeam,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Winner added successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add winner.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting winner: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Tournament Winner'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Year Input
              TextField(
                controller: _yearController,
                decoration: InputDecoration(
                  labelText: 'Enter Year',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: _selectedSport,
                onChanged: (value) {
                  setState(() {
                    _selectedSport = value;
                  });
                },
                items: [
                  DropdownMenuItem(value: 'football', child: Text('Football')),
                  DropdownMenuItem(value: 'cricket', child: Text('Cricket')),
                  DropdownMenuItem(value: 'chess', child: Text('Chess')),
                  DropdownMenuItem(value: 'handball', child: Text('Handball')),
                ],
                decoration: InputDecoration(
                  labelText: 'Select Sport',
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 20),

              // Team Dropdown
              DropdownButtonFormField<String>(
                value: _selectedTeam,
                onChanged: (value) {
                  setState(() {
                    _selectedTeam = value;
                  });
                },
                items: _teams
                    .map<DropdownMenuItem<String>>(
                      (team) => DropdownMenuItem<String>(
                    value: team['team_id'].toString(),
                    child: Text(team['name']),
                  ),
                )
                    .toList(),
                decoration: InputDecoration(
                  labelText: 'Select Team',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.group),
                ),
              ),
              SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: _submitWinner,
                child: Text('Submit Winner'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
