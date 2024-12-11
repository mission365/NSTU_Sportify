class MatchDetails {
  final int matchId;
  final String date;
  final String location;

  MatchDetails({required this.matchId, required this.date, required this.location});

  factory MatchDetails.fromJson(Map<String, dynamic> json) {
    return MatchDetails(
      matchId: json['match_id'],
      date: json['date'],
      location: json['location'],
    );
  }
}
