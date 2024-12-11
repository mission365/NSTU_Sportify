import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/representative.dart';

class RepresentativeList extends StatefulWidget {
  @override
  _RepresentativeListState createState() => _RepresentativeListState();
}

class _RepresentativeListState extends State<RepresentativeList> {
  late Future<List<Representative>> _representativeList;

  @override
  void initState() {
    super.initState();
    _representativeList = fetchRepresentatives();
  }

  Future<List<Representative>> fetchRepresentatives() async {
    ApiService apiService = ApiService();
    List<dynamic> playersJson = await apiService.fetchRepresentatives();
    return playersJson.map((json) => Representative.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Representative Info'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: FutureBuilder<List<Representative>>(
        future: _representativeList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.redAccent, fontSize: 18),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No representatives found.',
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final representative = snapshot.data![index];
                return DepartmentCard(
                  representativeName: representative.name,
                  email: representative.email,
                  department: representative.department,
                );
              },
            );
          }
        },
      ),
    );
  }
}

class DepartmentCard extends StatelessWidget {
  final String representativeName;
  final String email;
  final String department;

  const DepartmentCard({
    Key? key,
    required this.representativeName,
    required this.email,
    required this.department,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 8,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purpleAccent, Colors.deepPurple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                representativeName, // Displaying the name at the top
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 3,
                      color: Colors.black.withOpacity(0.4),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Email: $email', // Displaying the email below the name
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Department: $department', // Displaying the department below the email
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
