class Standing {
  final int standingId;
  final String teamName;
  final int position;

  Standing({required this.standingId, required this.teamName, required this.position});

  factory Standing.fromJson(Map<String, dynamic> json) {
    return Standing(
      standingId: json['standing_id'],
      teamName: json['team_name'],  // Assuming team name is returned in the response
      position: json['position'],
    );
  }
}
