import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ManageResultsPage extends StatefulWidget {
  final String token;

  const ManageResultsPage({Key? key, required this.token}) : super(key: key);

  @override
  _ManageResultsPageState createState() => _ManageResultsPageState();
}

class _ManageResultsPageState extends State<ManageResultsPage> {
  List<dynamic> matches = [];
  Map<String, dynamic>? selectedMatchDetails;
  String? selectedMatchId;
  String? sportType;
  int? resultId;

  final TextEditingController winnerController = TextEditingController();
  final TextEditingController loserController = TextEditingController();
  bool isDraw = false;

  // Game-specific detail controllers
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

  @override
  void initState() {
    super.initState();
    fetchMatches();
  }

  Future<void> fetchMatches() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/matchdetails/'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          matches = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to fetch matches');
      }
    } catch (error) {
      print('Error fetching matches: $error');
    }
  }

  Future<void> fetchMatchDetails(String matchId) async {
    try {
      setState(() {
        selectedMatchDetails = null;
      });

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/matchdetails/$matchId/'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          selectedMatchDetails = json.decode(response.body);
          sportType = selectedMatchDetails?['sport'];
        });
      } else {
        throw Exception('Failed to fetch match details');
      }
    } catch (error) {
      print('Error fetching match details: $error');
    }
  }

  Future<void> postResult() async {
    if (selectedMatchId == null) {
      showCustomSnackbar('Please select a match first.');
      return;
    }

    if (isDraw) {
      winnerController.clear();
      loserController.clear();
    } else if (winnerController.text.isEmpty || loserController.text.isEmpty) {
      showCustomSnackbar('Please enter both team names.');
      return;
    }

    final winnerTeamId = selectedMatchDetails?['team1'];
    final loserTeamId = selectedMatchDetails?['team2'];

    if (winnerTeamId == null || loserTeamId == null) {
      showCustomSnackbar('Invalid match details.');
      return;
    }

    final resultData = {
      'match': int.parse(selectedMatchId!),
      'winner_team': isDraw ? null : winnerTeamId,
      'loser_team': isDraw ? null : loserTeamId,
      'draw': isDraw,
    };

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/results/'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
        body: json.encode(resultData),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        resultId = responseData['result_id'];
        final matchId = responseData['match'];
        showCustomSnackbar('Result posted successfully!');
        winnerController.clear();
        loserController.clear();
        setState(() {
          isDraw = false;
        });
      } else {
        final error = json.decode(response.body);
        showCustomSnackbar('Failed to post result: ${error['detail']}');
      }
    } catch (error) {
      showCustomSnackbar('Error posting result: $error');
    }
  }

  Future<void> postGameSpecificDetails() async {
    if (resultId == null) {
      showCustomSnackbar('Result ID is missing.');
      return;
    }

    final gameSpecificData = {
      if (sportType == 'cricket') ...{
        'overs': int.tryParse(oversController.text) ?? 0,
        'runs_team1': int.tryParse(runsTeam1Controller.text) ?? 0,
        'runs_team2': int.tryParse(runsTeam2Controller.text) ?? 0,
        'wickets_team1': int.tryParse(wicketsTeam1Controller.text) ?? 0,
        'wickets_team2': int.tryParse(wicketsTeam2Controller.text) ?? 0,
      },
      if (sportType == 'football') ...{
        'duration': int.tryParse(durationController.text) ?? 0,
        'goals_team1': int.tryParse(goalsTeam1Controller.text) ?? 0,
        'goals_team2': int.tryParse(goalsTeam2Controller.text) ?? 0,
      },
      if (sportType == 'chess') ...{
        'duration': int.tryParse(durationController.text) ?? 0,
        'moves': int.tryParse(movesController.text) ?? 0,
      },
      if (sportType == 'handball') ...{
        'duration': int.tryParse(durationController.text) ?? 0,
        'goals_team1': int.tryParse(goalsTeam1Controller.text) ?? 0,
        'goals_team2': int.tryParse(goalsTeam2Controller.text) ?? 0,
      },
      if (sportType == 'carom') ...{
        'rounds': int.tryParse(roundsController.text) ?? 0,
        'points_team1': int.tryParse(pointsTeam1Controller.text) ?? 0,
        'points_team2': int.tryParse(pointsTeam2Controller.text) ?? 0,
      },
    };

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/result/$resultId/details/'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
        body: json.encode(gameSpecificData),
      );

      if (response.statusCode == 201) {
        showCustomSnackbar('Game-specific details added successfully!');
      } else {
        showCustomSnackbar('Failed to add game-specific details.');
      }
    } catch (error) {
      showCustomSnackbar('Error posting game-specific details: $error');
    }
  }

  void showCustomSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Results'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 10,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                child: Column(
                  children: [
                    const Text(
                      'Select a Match',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.deepPurple.shade50,
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Choose a Match',
                          labelStyle: TextStyle(color: Colors.deepPurple.shade400),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.deepPurple.shade50,
                        ),
                        isExpanded: true,
                        value: selectedMatchId,
                        items: matches.map<DropdownMenuItem<String>>((match) {
                          return DropdownMenuItem<String>(
                            value: match['match_id'].toString(),
                            child: Text(
                              '${match['team1_name']} vs ${match['team2_name']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedMatchId = value;
                          });
                          fetchMatchDetails(value!);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (selectedMatchDetails != null)
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: selectedMatchDetails != null ? 1.0 : 0.0,
                  child: Card(
                    color: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Enter Match Result',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: winnerController,
                            decoration: InputDecoration(
                              labelText: 'Winner Team Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: const Icon(Icons.emoji_events, color: Colors.deepPurple),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: loserController,
                            decoration: InputDecoration(
                              labelText: 'Loser Team Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: const Icon(Icons.sports, color: Colors.deepPurple),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Text(
                                'Match Draw:',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              Switch(
                                value: isDraw,
                                onChanged: (value) {
                                  setState(() {
                                    isDraw = value;
                                  });
                                },
                                activeColor: Colors.deepPurple,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: postResult,
                            icon: const Icon(Icons.check_circle),
                            label: const Text('Submit Result'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (sportType != null)
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: sportType != null
                      ? Column(
                    key: ValueKey(sportType),
                    children: [
                      if (sportType == 'cricket') buildCricketForm(),
                      if (sportType == 'football') buildFootballForm(),
                      if (sportType == 'chess') buildChessForm(),
                      if (sportType == 'handball') buildHandballForm(),
                      if (sportType == 'carom') buildCaromForm(),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: postGameSpecificDetails,
                        icon: const Icon(Icons.save),
                        label: const Text('Submit Game Details'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  )
                      : const SizedBox.shrink(),
                ),
            ],
          ),
        ),
      ),
    );
  }
  Widget buildCricketForm() => Card(
    elevation: 4,
    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cricket Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          buildTextField(oversController, 'Overs', Icons.sports_cricket),
          buildTextField(runsTeam1Controller, 'Runs (Team 1)', Icons.emoji_events),
          buildTextField(runsTeam2Controller, 'Runs (Team 2)', Icons.emoji_events),
          buildTextField(wicketsTeam1Controller, 'Wickets (Team 1)', Icons.outdoor_grill),
          buildTextField(wicketsTeam2Controller, 'Wickets (Team 2)', Icons.outdoor_grill),
        ],
      ),
    ),
  );

  Widget buildFootballForm() => Card(
    elevation: 4,
    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Football Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          buildTextField(durationController, 'Duration (Minutes)', Icons.timer),
          buildTextField(goalsTeam1Controller, 'Goals (Team 1)', Icons.sports_soccer),
          buildTextField(goalsTeam2Controller, 'Goals (Team 2)', Icons.sports_soccer),
        ],
      ),
    ),
  );

  Widget buildChessForm() => Card(
    elevation: 4,
    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chess Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          buildTextField(durationController, 'Duration (Minutes)', Icons.timer),
          buildTextField(movesController, 'Total Moves', Icons.casino),
        ],
      ),
    ),
  );

  Widget buildHandballForm() => Card(
    elevation: 4,
    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Handball Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          buildTextField(durationController, 'Duration (Minutes)', Icons.timer),
          buildTextField(goalsTeam1Controller, 'Goals (Team 1)', Icons.sports_handball),
          buildTextField(goalsTeam2Controller, 'Goals (Team 2)', Icons.sports_handball),
        ],
      ),
    ),
  );

  Widget buildCaromForm() => Card(
    elevation: 4,
    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Carom Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          buildTextField(roundsController, 'Rounds', Icons.sports),
          buildTextField(pointsTeam1Controller, 'Points (Team 1)', Icons.star),
          buildTextField(pointsTeam2Controller, 'Points (Team 2)', Icons.star),
        ],
      ),
    ),
  );

  Widget buildTextField(TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }



}
