import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/team.dart';
import '../models/player.dart';

class TeamListScreen extends StatefulWidget {
  @override
  _TeamListScreenState createState() => _TeamListScreenState();
}

class _TeamListScreenState extends State<TeamListScreen> {
  late Future<Map<String, List<Team>>> futureTeamsBySport;

  @override
  void initState() {
    super.initState();
    futureTeamsBySport = fetchTeamsCategorizedBySport();
  }

  Future<Map<String, List<Team>>> fetchTeamsCategorizedBySport() async {
    ApiService apiService = ApiService();
    List<dynamic> teamsJson = await apiService.fetchTeams();
    List<Team> teams = teamsJson.map((json) => Team.fromJson(json)).toList();

    // Group teams by sport
    Map<String, List<Team>> categorizedTeams = {};
    for (var team in teams) {
      categorizedTeams.putIfAbsent(team.sport, () => []).add(team);
    }
    return categorizedTeams;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Teams by Sport',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 4,
        shadowColor: Colors.deepPurple.withOpacity(0.4),
      ),
      body: FutureBuilder<Map<String, List<Team>>>(
        future: futureTeamsBySport,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, List<Team>>? teamsBySport = snapshot.data;
            return ListView.builder(
              itemCount: teamsBySport!.keys.length,
              itemBuilder: (context, index) {
                String sport = teamsBySport.keys.elementAt(index);
                List<Team> teams = teamsBySport[sport]!;
                return buildSportSection(sport, teams);
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget buildSportSection(String sport, List<Team> teams) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sport Category Header
          Text(
            sport.toUpperCase(),
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurpleAccent,
            ),
          ),
          const SizedBox(height: 12),
          // Sport Teams
          ...teams.map((team) => buildTeamCard(team)).toList(),
        ],
      ),
    );
  }

  Widget buildTeamCard(Team team) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurpleAccent, Colors.blue.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurpleAccent.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(3, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 28,
                  child: Text(
                    team.name[0],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  team.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.person, color: Colors.white70, size: 18),
                const SizedBox(width: 6),
                Text(
                  "Coach: ${team.coach}",
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "Players:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.amberAccent.shade100,
              ),
            ),
            const SizedBox(height: 12),
            ...team.players.map((player) => buildPlayerCard(player)).toList(),
          ],
        ),
      ),
    );
  }

  Widget buildPlayerCard(Player player) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.deepPurpleAccent.shade100,
              radius: 24,
              child: Text(
                player.name[0],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Position: ${player.position}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "Age: ${player.age}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurpleAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
