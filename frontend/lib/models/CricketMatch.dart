class CricketMatch {
  final int cricketMatchId;
  final int overs;
  final int runsTeam1;
  final int runsTeam2;
  final int wicketsTeam1;
  final int wicketsTeam2;
  final int match;
  final String team1Name;
  final String team2Name;
  final DateTime matchDate;

  CricketMatch({
    required this.cricketMatchId,
    required this.overs,
    required this.runsTeam1,
    required this.runsTeam2,
    required this.wicketsTeam1,
    required this.wicketsTeam2,
    required this.match,
    required this.team1Name,
    required this.team2Name,
    required this.matchDate,
  });

  // Factory constructor to create an object from JSON
  factory CricketMatch.fromJson(Map<String, dynamic> json) {
    return CricketMatch(
      cricketMatchId: json['cricket_match_id'],
      overs: json['overs'],
      runsTeam1: json['runs_team1'],
      runsTeam2: json['runs_team2'],
      wicketsTeam1: json['wickets_team1'],
      wicketsTeam2: json['wickets_team2'],
      match: json['match'],
      team1Name: json['team1_name'],
      team2Name: json['team2_name'],
      matchDate: DateTime.parse(json['match_date']),
    );
  }

  // Method to convert an object to JSON
  Map<String, dynamic> toJson() {
    return {
      'cricket_match_id': cricketMatchId,
      'overs': overs,
      'runs_team1': runsTeam1,
      'runs_team2': runsTeam2,
      'wickets_team1': wicketsTeam1,
      'wickets_team2': wicketsTeam2,
      'match': match,
      'team1_name': team1Name,
      'team2_name': team2Name,
      'match_date': matchDate.toIso8601String(),
    };
  }

  // Method to parse a list of matches from JSON
  static List<CricketMatch> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => CricketMatch.fromJson(json)).toList();
  }
}
