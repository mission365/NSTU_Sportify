class Player {
  final int playerId;
  final String name;
  final int age;
  final String position;

  Player({
    required this.playerId,
    required this.name,
    required this.age,
    required this.position,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      playerId: json['player_id'],
      name: json['name'],
      age: json['age'],
      position: json['position'],
    );
  }
}