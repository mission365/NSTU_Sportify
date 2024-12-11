class Score {
  final int scoreId;
  final int score;
  final String teamName;  // You may need to join with the Team model for team names

  Score({required this.scoreId, required this.score, required this.teamName});

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      scoreId: json['score_id'],
      score: json['score'],
      teamName: json['team_name'],  // Assuming team name is returned in the response
    );
  }
}
