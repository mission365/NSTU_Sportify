import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/standing.dart';

class StandingListScreen extends StatefulWidget {
  @override
  _StandingListScreenState createState() => _StandingListScreenState();
}

class _StandingListScreenState extends State<StandingListScreen> {
  late Future<List<Standing>> futureStandings;

  @override
  void initState() {
    super.initState();
    futureStandings = fetchStandings();
  }

  Future<List<Standing>> fetchStandings() async {
    ApiService apiService = ApiService();
    List<dynamic> standingsJson = await apiService.fetchStandings();
    return standingsJson.map((json) => Standing.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Standings'),
      ),
      body: FutureBuilder<List<Standing>>(
        future: futureStandings,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Standing>? standings = snapshot.data;
            return ListView.builder(
              itemCount: standings?.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Team: ${standings![index].teamName}'),
                  subtitle: Text('Position: ${standings[index].position}'),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
