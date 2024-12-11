import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MatchDetailsPage extends StatefulWidget {
  final String token;

  const MatchDetailsPage({Key? key, required this.token}) : super(key: key);

  @override
  _MatchDetailsPageState createState() => _MatchDetailsPageState();
}

class _MatchDetailsPageState extends State<MatchDetailsPage> {
  List<dynamic> teams = [];
  List<dynamic> events = [];
  String? selectedTeam1;
  String? selectedTeam2;
  String? selectedEvent;
  String selectedSport = '';
  final TextEditingController locationController = TextEditingController();
  final TextEditingController dateController = TextEditingController(); // Controller for the date
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    fetchTeams();
    fetchEvents();
  }

  Future<void> fetchTeams() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/teams/'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );
      if (response.statusCode == 200) {
        setState(() {
          teams = json.decode(response.body);
        });
      }
    } catch (e) {
      print("Error fetching teams: $e");
    }
  }

  Future<void> fetchEvents() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/events/'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );
      if (response.statusCode == 200) {
        setState(() {
          events = json.decode(response.body);
        });
      }
    } catch (e) {
      print("Error fetching events: $e");
    }
  }

  Future<void> createMatch() async {
    final data = {
      "date": selectedDate?.toIso8601String().split('T')[0],
      "location": locationController.text,
      "event": int.tryParse(selectedEvent ?? ""),
      "team1": int.tryParse(selectedTeam1 ?? ""),
      "team2": int.tryParse(selectedTeam2 ?? ""),
      "sport": selectedSport,
    };

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/matchdetails/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Match created successfully!')),
        );
      } else {
        print("Response: ${response.statusCode} ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create match')),
        );
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = "${picked.toLocal()}".split(' ')[0]; // Update the text field
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Match'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Match Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(),
                    // Date Field with Controller
                    TextField(
                      controller: dateController,
                      readOnly: true, // Make it read-only
                      decoration: InputDecoration(
                        labelText: 'Date',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () => selectDate(context), // Open the date picker
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: locationController,
                      decoration: InputDecoration(
                        labelText: 'Location',
                        prefixIcon: Icon(Icons.location_on),
                      ),
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField(
                      value: selectedEvent,
                      items: events.map((event) {
                        return DropdownMenuItem(
                          value: event['event_id'].toString(),
                          child: Text(event['title']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedEvent = value as String?;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Select Event'),
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField(
                      value: selectedTeam1,
                      items: teams.map((team) {
                        return DropdownMenuItem(
                          value: team['team_id'].toString(),
                          child: Text(team['name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedTeam1 = value as String?;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Select Team 1'),
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField(
                      value: selectedTeam2,
                      items: teams.map((team) {
                        return DropdownMenuItem(
                          value: team['team_id'].toString(),
                          child: Text(team['name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedTeam2 = value as String?;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Select Team 2'),
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedSport.isEmpty ? null : selectedSport,
                      items: [
                        DropdownMenuItem(
                          value: null,
                          child: Text('Choose a sport', style: TextStyle(color: Colors.grey)),
                        ),
                        ...['football', 'cricket', 'chess', 'handball', 'carom']
                            .map((sport) => DropdownMenuItem(
                          value: sport,
                          child: Text(sport),
                        ))
                            .toList(),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedSport = value ?? '';
                        });
                      },
                      decoration: InputDecoration(labelText: 'Select Sport'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: createMatch,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text('Create Match', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
