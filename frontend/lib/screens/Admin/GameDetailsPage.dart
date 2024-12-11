import 'package:flutter/material.dart';

class GameDetailsPage extends StatefulWidget {
  final String token;
  final String matchId;
  final String sportType;

  const GameDetailsPage({
    Key? key,
    required this.token,
    required this.matchId,
    required this.sportType,
  }) : super(key: key);

  @override
  _GameDetailsPageState createState() => _GameDetailsPageState();
}

class _GameDetailsPageState extends State<GameDetailsPage> {
  String? sportType;
  final TextEditingController oversController = TextEditingController();
  final TextEditingController runsTeam1Controller = TextEditingController();
  final TextEditingController runsTeam2Controller = TextEditingController();
  final TextEditingController wicketsTeam1Controller = TextEditingController();
  final TextEditingController wicketsTeam2Controller = TextEditingController();

  final TextEditingController durationController = TextEditingController();
  final TextEditingController goalsTeam1Controller = TextEditingController();
  final TextEditingController goalsTeam2Controller = TextEditingController();

  final TextEditingController movesController = TextEditingController();

  final TextEditingController roundsController = TextEditingController();
  final TextEditingController pointsTeam1Controller = TextEditingController();
  final TextEditingController pointsTeam2Controller = TextEditingController();

  Future<void> submitDetails() async {
    final gameSpecificData = {
      if (sportType == 'cricket') ...{
        'overs': int.tryParse(oversController.text),
        'runs_team1': int.tryParse(runsTeam1Controller.text),
        'runs_team2': int.tryParse(runsTeam2Controller.text),
        'wickets_team1': int.tryParse(wicketsTeam1Controller.text),
        'wickets_team2': int.tryParse(wicketsTeam2Controller.text),
      },
      if (sportType == 'football') ...{
        'duration': int.tryParse(durationController.text),
        'goals_team1': int.tryParse(goalsTeam1Controller.text),
        'goals_team2': int.tryParse(goalsTeam2Controller.text),
      },
      if (sportType == 'chess') ...{
        'duration': int.tryParse(durationController.text),
        'moves': int.tryParse(movesController.text),
      },
      if (sportType == 'handball') ...{
        'duration': int.tryParse(durationController.text),
        'goals_team1': int.tryParse(goalsTeam1Controller.text),
        'goals_team2': int.tryParse(goalsTeam2Controller.text),
      },
      if (sportType == 'carom') ...{
        'rounds': int.tryParse(roundsController.text),
        'points_team1': int.tryParse(pointsTeam1Controller.text),
        'points_team2': int.tryParse(pointsTeam2Controller.text),
      },
    };

    // Placeholder for POST API call
    print('Posting Game-Specific Details: $gameSpecificData');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Game details submitted successfully!')),
    );
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    fetchSportType();
  }

  Future<void> fetchSportType() async {
    // Placeholder: Fetch `sportType` from API or match details
    setState(() {
      sportType = 'cricket'; // Example sport type
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Game Details'),
        backgroundColor: Colors.indigo,
      ),
      body: sportType == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter details for $sportType:',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              if (sportType == 'cricket') ...[
                TextField(
                  controller: oversController,
                  decoration: const InputDecoration(labelText: 'Overs', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: runsTeam1Controller,
                  decoration: const InputDecoration(labelText: 'Runs Team 1', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: runsTeam2Controller,
                  decoration: const InputDecoration(labelText: 'Runs Team 2', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: wicketsTeam1Controller,
                  decoration: const InputDecoration(labelText: 'Wickets Team 1', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: wicketsTeam2Controller,
                  decoration: const InputDecoration(labelText: 'Wickets Team 2', border: OutlineInputBorder()),
                ),
              ],
              if (sportType == 'football') ...[
                TextField(
                  controller: durationController,
                  decoration: const InputDecoration(labelText: 'Duration (minutes)', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: goalsTeam1Controller,
                  decoration: const InputDecoration(labelText: 'Goals Team 1', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: goalsTeam2Controller,
                  decoration: const InputDecoration(labelText: 'Goals Team 2', border: OutlineInputBorder()),
                ),
              ],
              if (sportType == 'chess') ...[
                TextField(
                  controller: durationController,
                  decoration: const InputDecoration(labelText: 'Duration (minutes)', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: movesController,
                  decoration: const InputDecoration(labelText: 'Total Moves', border: OutlineInputBorder()),
                ),
              ],
              if (sportType == 'handball') ...[
                TextField(
                  controller: durationController,
                  decoration: const InputDecoration(labelText: 'Duration (minutes)', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: goalsTeam1Controller,
                  decoration: const InputDecoration(labelText: 'Goals Team 1', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: goalsTeam2Controller,
                  decoration: const InputDecoration(labelText: 'Goals Team 2', border: OutlineInputBorder()),
                ),
              ],
              if (sportType == 'carom') ...[
                TextField(
                  controller: roundsController,
                  decoration: const InputDecoration(labelText: 'Rounds', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: pointsTeam1Controller,
                  decoration: const InputDecoration(labelText: 'Points Team 1', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: pointsTeam2Controller,
                  decoration: const InputDecoration(labelText: 'Points Team 2', border: OutlineInputBorder()),
                ),
              ],
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: submitDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Submit Details'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
