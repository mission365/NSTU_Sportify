class Representative {
  //final int representativeId;
  final String name;
  final String email;
  final String department;

  Representative({
    //required this.representativeId,
    required this.name,
    required this.email,
    required this.department,
  });

  // Factory constructor to create a Representative instance from JSON
  factory Representative.fromJson(Map<String, dynamic> json) {
    return Representative(
      //representativeId: json['representative_id'] ?? 0, // default to 0 if null
      name: json['name'] , // default to empty string if null
      email: json['email'] , // default to empty string if null
      department: json['department_name'], // default to empty string if null
    );
  }
}
