class Match {
  final int matchId;
  final String date;
  final String location;
  final String eventName;
  final String sport;
  final String team1Name;
  final String team2Name;

  Match({
    required this.matchId,
    required this.date,
    required this.location,
    required this.eventName,
    required this.sport,
    required this.team1Name,
    required this.team2Name,
  });

  // Factory constructor to create a Match instance from JSON
  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      matchId: json['match_id'],
      date: json['date'],
      location: json['location'],
      eventName: json['event_name'],
      sport: json['sport'],
      team1Name: json['team1_name'],
      team2Name: json['team2_name'],
    );
  }
}
