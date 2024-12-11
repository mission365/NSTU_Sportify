import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class TestRepresentative extends StatefulWidget {
  final String username;
  final String token;

  const TestRepresentative({
    Key? key,
    required this.username,
    required this.token,
  }) : super(key: key);

  @override
  _TestRepresentativeState createState() =>
      _TestRepresentativeState();
}

class _TestRepresentativeState
    extends State<TestRepresentative> {
  String _selectedOption = 'Create Player'; // Default selected option

  final _playerNameController = TextEditingController();
  final _playerAgeController = TextEditingController();
  final _playerPositionController = TextEditingController();
  final _teamNameController = TextEditingController();
  final _coachNameController = TextEditingController();
  String? _selectedSport; // For selecting a sport when creating a team
  List<dynamic> _teams = [];
  String? _playerId; // For selecting a player
  List<dynamic> _players = [];
  String? _selectedTeamForAdd; // For selecting a team
  String? _selectedTeamForRemove;//For removing a team
  final List<String> _sports = [
    'Football',
    'Cricket',
    'Chess',
    'Handball',
    'Carom',
  ];
  @override
  void initState() {
    super.initState();
    _fetchTeams();
    _fetchPlayers();
  }
  bool _isLoading = false; // Loading indicator state
  Future<void> _fetchTeams() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/teams/owned'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
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

  Future<void> _fetchPlayers() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/players/'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        setState(() {
          _players = json.decode(response.body);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch players.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching players: $e')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome - ${widget.username}'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Row(
        children: [
          // Enhanced Sidebar
          Container(
            width: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade700, Colors.blue.shade300],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.dashboard, size: 40, color: Colors.white),
                        SizedBox(height: 10),
                        Text(
                          'Dashboard',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),

                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: [
                      _buildSidebarTile(
                        icon: Icons.person_add,
                        title: 'Create Player',
                        onTap: () {
                          setState(() {
                            _selectedOption = 'Create Player';
                          });
                        },
                      ),
                      _buildSidebarTile(
                        icon: Icons.group_add,
                        title: 'Create Team',
                        onTap: () {
                          setState(() {
                            _selectedOption = 'Create Team';
                          });
                        },
                      ),
                      _buildSidebarTile(
                        icon: Icons.person_add_alt_1,
                        title: 'Add Player to Team',
                        onTap: () {
                          setState(() {
                            _selectedOption = 'Add Player to Team';
                          });
                        },
                      ),
                      _buildSidebarTile(
                        icon: Icons.person_remove,
                        title: 'Remove Player from Team',
                        onTap: () {
                          setState(() {
                            _selectedOption = 'Remove Player from Team';
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Main Content Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

// Helper function for sidebar tiles
  Widget _buildSidebarTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      onTap: onTap,
      tileColor: Colors.transparent,
      hoverColor: Colors.blue.shade400,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white70),
    );
  }


  // Dynamically render content based on selected option
  Widget _buildContent() {
    switch (_selectedOption) {
      case 'Create Player':
        return _buildCreatePlayerUI();
      case 'Create Team':
        return _buildCreateTeamUI();
      case 'Add Player to Team':
        return _buildAddPlayerToTeamUI();
      case 'Remove Player from Team':
        return _buildRemovePlayerFromTeamUI();
      default:
        return Center(
          child: Text('Select an option from the menu.'),
        );
    }
  }

  Widget _buildCreatePlayerUI() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Create a New Player',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent.shade700,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Fill in the details below to add a new player to your roster.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 20),

            // Form Container
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.blue.shade50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Player Name Field
                  _buildInputField(
                    controller: _playerNameController,
                    label: 'Player Name',
                    icon: Icons.person,
                  ),
                  SizedBox(height: 15),

                  // Player Age Field
                  _buildInputField(
                    controller: _playerAgeController,
                    label: 'Player Age',
                    icon: Icons.calendar_today,
                    inputType: TextInputType.number,
                  ),
                  SizedBox(height: 15),

                  // Player Position Field
                  _buildInputField(
                    controller: _playerPositionController,
                    label: 'Player Position',
                    icon: Icons.sports,
                  ),
                  SizedBox(height: 25),

                  // Create Player Button
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                    onPressed: _createPlayer,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.blueAccent.shade700,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Create Player',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// Helper Method for Input Fields
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey.shade800,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: inputType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade100,
            prefixIcon: Icon(icon, color: Colors.blueAccent),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent.shade100),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent.shade400, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildCreateTeamUI() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Text(
              'Create a New Team',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Enter the details below to create a new team.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 20),

            // Form Container
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.green.shade50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Team Name Field
                  _buildInputFieldForTeam(
                    controller: _teamNameController,
                    label: 'Team Name',
                    icon: Icons.group,
                  ),
                  SizedBox(height: 15),

                  // Coach Name Field
                  _buildInputFieldForTeam(
                    controller: _coachNameController,
                    label: 'Coach Name',
                    icon: Icons.person,
                  ),
                  SizedBox(height: 15),

                  // Select Sport Dropdown
                  Text(
                    'Select Sport',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                  SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedSport,
                    onChanged: (value) {
                      setState(() {
                        _selectedSport = value;
                      });
                    },
                    items: _sports
                        .map<DropdownMenuItem<String>>(
                          (sport) => DropdownMenuItem<String>(
                        value: sport.toLowerCase(),
                        child: Text(
                          sport,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                        .toList(),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      prefixIcon: Icon(Icons.sports, color: Colors.green),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green.shade200),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green.shade500, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                  SizedBox(height: 25),

                  // Create Team Button
                  ElevatedButton(
                    onPressed: _createTeam,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.green.shade700,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Create Team',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// Helper Method for Input Fields
  Widget _buildInputFieldForTeam({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.green.shade700,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade100,
            prefixIcon: Icon(icon, color: Colors.green),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green.shade200),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green.shade500, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildAddPlayerToTeamUI() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Text(
              'Add Player to Team',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.purple.shade800,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Select a team and a player to add them together.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 20),

            // Form Container
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.purple.shade50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Select Team Dropdown
                  _buildDropdownField(
                    label: 'Select Team',
                    value: _selectedTeamForAdd,
                    items: _teams.map<DropdownMenuItem<String>>((team) {
                      return DropdownMenuItem<String>(
                        value: team['name'],
                        child: Text(team['name']),
                      );
                    }).toList(),
                    icon: Icons.group,
                    onChanged: (value) {
                      setState(() {
                        _selectedTeamForAdd = value;
                      });
                    },
                  ),
                  SizedBox(height: 15),

                  // Select Player Dropdown
                  _buildDropdownField(
                    label: 'Select Player',
                    value: _playerId,
                    items: _players.map<DropdownMenuItem<String>>((player) {
                      return DropdownMenuItem<String>(
                        value: player['player_id'].toString(),
                        child: Text(player['name']),
                      );
                    }).toList(),
                    icon: Icons.person_outline,
                    onChanged: (value) {
                      setState(() {
                        _playerId = value;
                      });
                    },
                  ),
                  SizedBox(height: 25),

                  // Add Player Button
                  ElevatedButton(
                    onPressed: _addPlayerToTeam,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.purpleAccent,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.group_add, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Add Player to Team',
                          style: TextStyle(fontSize: 16,color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// Helper Widget for Dropdown Fields
  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.purple.shade700,
          ),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          items: items,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade100,
            prefixIcon: Icon(icon, color: Colors.purple),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.purple.shade200),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.purple.shade500, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildRemovePlayerFromTeamUI() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Text(
              'Remove Player from Team',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.teal, // Changed red to teal
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Select a team and a player to remove them.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 20),

            // Form Container
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.teal.shade100], // Changed red to teal
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Select Team Dropdown
                  _buildDropdownFieldForRemove(
                    label: 'Select Team',
                    value: _selectedTeamForRemove,
                    items: _teams.map<DropdownMenuItem<String>>((team) {
                      return DropdownMenuItem<String>(
                        value: team['name'],
                        child: Text(team['name']),
                      );
                    }).toList(),
                    icon: Icons.group_remove,
                    onChanged: (value) {
                      setState(() {
                        _selectedTeamForRemove = value;
                      });
                    },
                  ),
                  SizedBox(height: 15),

                  // Select Player Dropdown
                  _buildDropdownFieldForRemove(
                    label: 'Select Player',
                    value: _playerId,
                    items: _players.map<DropdownMenuItem<String>>((player) {
                      return DropdownMenuItem<String>(
                        value: player['player_id'].toString(),
                        child: Text(player['name']),
                      );
                    }).toList(),
                    icon: Icons.person_remove,
                    onChanged: (value) {
                      setState(() {
                        _playerId = value;
                      });
                    },
                  ),
                  SizedBox(height: 25),

                  // Remove Player Button
                  ElevatedButton(
                    onPressed: () {
                      if (_selectedTeamForRemove != null && _playerId != null) {
                        _removePlayer(_selectedTeamForRemove!, int.parse(_playerId!));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please select both a team and a player.')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.teal, // Changed red to teal
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.remove_circle, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Remove Player from Team',
                          style: TextStyle(fontSize: 16,color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// Helper Widget for Dropdown Fields
  Widget _buildDropdownFieldForRemove({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.teal.shade700, // Changed red to teal
          ),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          items: items,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade100,
            prefixIcon: Icon(icon, color: Colors.teal), // Changed red to teal
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal.shade200), // Changed red to teal
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal.shade500, width: 2), // Changed red to teal
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }



  // Create Player API Call
  Future<void> _createPlayer() async {
    final name = _playerNameController.text.trim();
    final age = int.tryParse(_playerAgeController.text.trim());
    final position = _playerPositionController.text.trim();

    if (name.isEmpty || age == null || position.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields correctly.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/players/'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': name,
          'age': age,
          'position': position,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Player created successfully!')),
        );
        _clearFields();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create player.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Clear input fields
  void _clearFields() {
    _playerNameController.clear();
    _playerAgeController.clear();
    _playerPositionController.clear();
  }

  // API Call for Creating a Team
  Future<void> _createTeam() async {
    final teamName = _teamNameController.text.trim();
    final coachName = _coachNameController.text.trim();
    final sport = _selectedSport;

    if (teamName.isEmpty || coachName.isEmpty || sport == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/teams/'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': teamName,
          'coach': coachName,
          'sport': sport,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Team created successfully!')),
        );
        _clearTeamFields();
        _fetchTeams(); // Refresh the team list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create team.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

// Clear team input fields
  void _clearTeamFields() {
    _teamNameController.clear();
    _coachNameController.clear();
    _selectedSport = null;
  }
  Future<void> _addPlayerToTeam() async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://127.0.0.1:8000/api/teams/$_selectedTeamForAdd/add_player/'), // Using team name in the URL
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
        body: json.encode({'player_id': _playerId}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Player added to team successfully!')),
        );
        _clearAddPlayerFields;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add player to team.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding player to team: $e')),
      );
    }
  }
  void _clearAddPlayerFields() {
    _selectedTeamForAdd = null; // Reset team selection
    _playerId = null; // Reset player selection
  }
  Future<void> _removePlayer(String teamName, int playerId) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/teams/$_selectedTeamForRemove/remove_player/'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'player_id': playerId,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Player removed successfully!')),
        );
        _fetchPlayers(); // Refresh player list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to remove player.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing player: $e')),
      );
    }
  }

}
