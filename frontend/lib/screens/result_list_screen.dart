import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/result.dart';
import 'package:intl/intl.dart'; // For date formatting.
import 'package:frontend/screens/FootballDetailScreen.dart';
import 'package:frontend/screens/CricketDetailScreen.dart';
import 'package:frontend/screens/HandballDetailScreen.dart';
import 'package:frontend/screens/CarromDetailScreen.dart';
import 'package:frontend/screens/ChessDetailScreen.dart';

class ResultListScreen extends StatefulWidget {
  @override
  _ResultListScreenState createState() => _ResultListScreenState();
}

class _ResultListScreenState extends State<ResultListScreen> {
  late Future<List<Result>> futureResults;

  @override
  void initState() {
    super.initState();
    futureResults = fetchResults();
  }

  Future<List<Result>> fetchResults() async {
    ApiService apiService = ApiService();
    List<dynamic> resultsJson = await apiService.fetchResults();
    return resultsJson.map((json) => Result.fromJson(json)).toList();
  }

  Map<String, List<Result>> groupResultsByDate(List<Result> results) {
    // Sort results by date
    results.sort((a, b) => a.matchDate.compareTo(b.matchDate));

    // Group by matchDate
    Map<String, List<Result>> groupedResults = {};
    for (var result in results) {
      if (!groupedResults.containsKey(result.matchDate)) {
        groupedResults[result.matchDate] = [];
      }
      groupedResults[result.matchDate]!.add(result);
    }
    return groupedResults;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Match Results',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigoAccent,
      ),
      body: FutureBuilder<List<Result>>(
        future: futureResults,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Result>? results = snapshot.data;
            if (results == null || results.isEmpty) {
              return Center(
                child: Text(
                  'No results available',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }

            Map<String, List<Result>> groupedResults = groupResultsByDate(results);

            return ListView(
              padding: EdgeInsets.all(10),
              children: groupedResults.entries.map((entry) {
                String dateTitle = entry.key;
                List<Result> matches = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Title
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        DateFormat('MMMM dd, yyyy').format(DateTime.parse(dateTitle)),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                    ),
                    // Match Cards for this Date
                    ...matches.map((result) => ResultCard(result: result)).toList(),
                  ],
                );
              }).toList(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(fontSize: 18, color: Colors.redAccent),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class ResultCard extends StatelessWidget {
  final Result result;

  const ResultCard({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Match Type: ${result.sportType.toUpperCase()}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTeamInfo('Winner', result.winnerTeam, Colors.green),
                _buildTeamInfo('Loser', result.loserTeam, Colors.red),
              ],
            ),
            SizedBox(height: 12),
            Text(
              'Draw: ${result.draw ? "Yes" : "No"}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.amberAccent,
              ),
            ),
            SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  navigateToSportDetail(context, result);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.indigoAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Show Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamInfo(String label, String teamName, Color labelColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 4),
        Text(
          teamName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void navigateToSportDetail(BuildContext context, Result result) {
    switch (result.sportType.toLowerCase()) {
      case 'cricket':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CricketDetailScreen(resultId: result.resultId)),
        );
        break;
      case 'football':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FootballDetailScreen(resultId: result.resultId)),
        );
        break;
      case 'chess':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChessDetailScreen(result: result)),
        );
        break;
      case 'handball':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HandballDetailScreen(result: result)),
        );
        break;
      case 'carrom':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CarromDetailScreen(result: result)),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No details page available for ${result.sportType}')),
        );
    }
  }
}


