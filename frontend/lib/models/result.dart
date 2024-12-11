class Result {
  final int resultId;
  final int matchNumber;
  final String matchDate;
  final String sportType;
  final String winnerTeam;
  final String loserTeam;
  final bool draw;

  Result({
    required this.resultId,
    required this.matchNumber,
    required this.matchDate,
    required this.sportType,
    required this.winnerTeam,
    required this.loserTeam,
    required this.draw,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      resultId: json['result_id'],
      matchNumber: json['match'],
      matchDate: json['match_date'],
      sportType: json['sport_type'],
      winnerTeam: json['winner_team_name'],
      loserTeam: json['loser_team_name'],
      draw: json['draw'],
    );
  }
}
