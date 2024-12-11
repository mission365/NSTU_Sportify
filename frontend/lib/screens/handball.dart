import 'package:flutter/material.dart';
import 'package:frontend/models/matchmodels.dart'; // Import the model
import 'dart:convert';
import 'package:http/http.dart' as http;

class HandballPage extends StatefulWidget {
  @override
  _HandballPageState createState() => _HandballPageState();
}

class _HandballPageState extends State<HandballPage> {
  List<Match> matches = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMatches();
  }

  Future<void> fetchMatches() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/matches/handball/'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          matches = data.map((item) => Match.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load matches');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Handball"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upcoming Matches',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurpleAccent,
                ),
              ),
              const SizedBox(height: 16),
              // Display matches grouped by event
              for (var eventGroup in groupMatchesByEvent(matches)) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    eventGroup['eventName'],
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Table(
                    border: TableBorder(
                      horizontalInside: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    columnWidths: const <int, TableColumnWidth>{
                      0: FlexColumnWidth(3),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(4),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      // Header Row
                      TableRow(
                        decoration:
                        BoxDecoration(color: Colors.deepPurpleAccent.shade100),
                        children: [
                          headerCell('MATCH'),
                          headerCell('DATE'),
                          headerCell('LOCATION'),
                        ],
                      ),
                      // Data Rows
                      for (var match in eventGroup['matches']) TableRow(children: matchRow(match)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget headerCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
        textAlign: TextAlign.center,
      ),
    );
  }

  List<Widget> matchRow(Match match) {
    return [
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(Icons.sports_soccer, color: Colors.deepPurple, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${match.team1Name} v ${match.team2Name}',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          match.date,
          style: TextStyle(color: Colors.grey.shade600),
          textAlign: TextAlign.center,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          match.location,
          style: TextStyle(color: Colors.grey.shade600),
          textAlign: TextAlign.center,
        ),
      ),
    ];
  }

  List<Map<String, dynamic>> groupMatchesByEvent(List<Match> matches) {
    final Map<String, List<Match>> grouped = {};
    for (var match in matches) {
      if (!grouped.containsKey(match.eventName)) {
        grouped[match.eventName] = [];
      }
      grouped[match.eventName]!.add(match);
    }
    return grouped.entries
        .map((entry) => {'eventName': entry.key, 'matches': entry.value})
        .toList();
  }
}
