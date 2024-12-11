import 'player.dart';

class Team {
  final int teamId;
  final String name;
  final String coach;
  final int representativeId;
  final List<Player> players;
  final String sport; // Use a consistent name for clarity (previously `sportName`).

  Team({
    required this.teamId,
    required this.name,
    required this.coach,
    required this.representativeId,
    required this.players,
    required this.sport, // Updated to match the field name in the JSON.
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      teamId: json['team_id'],
      name: json['name'],
      coach: json['coach'],
      representativeId: json['representative_id'],
      players: (json['players'] as List)
          .map((playerJson) => Player.fromJson(playerJson))
          .toList(),
      sport: json['sport'], // Ensure the field name matches the JSON key.
    );
  }
}
