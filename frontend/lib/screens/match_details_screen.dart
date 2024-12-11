import 'package:flutter/material.dart';
// Import the individual sport pages
import 'cricket.dart';
import 'football.dart';
import 'chess.dart';
import 'carrom.dart';
import 'handball.dart';

class MatchDetailsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> sports = [
    {"name": "Cricket", "icon": 'assets/images/cricket.png', "page": CricketPage()},
    {"name": "Football", "icon": 'assets/images/football.png', "page": FootballPage()},
    {"name": "Chess", "icon": 'assets/images/chess.png', "page": ChessPage()},
    {"name": "Carrom", "icon": 'assets/images/carrom.png', "page": CarromPage()},
    {"name": "Handball", "icon": 'assets/images/handball.png', "page": HandballPage()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Match Schedule',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 5,
        shadowColor: Colors.deepPurple[200],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6A11CB),
              Color(0xFF2575FC),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Explore Sports",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Three cards per row
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: sports.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => sports[index]["page"], // Navigate to the corresponding page
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10), // Smaller border radius
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFF1F8FF),
                              Color(0xFFDEE8FF),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6, // Reduced shadow blur
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              sports[index]["icon"],
                              width: 80, // Icon size
                              height: 80, // Icon size
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 6), // Spacing
                            Text(
                              sports[index]["name"],
                              style: const TextStyle(
                                fontSize: 20, // Font size
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4), // Spacing
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.deepPurpleAccent.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Tap to Explore',
                                style: TextStyle(
                                  fontSize: 10, // Font size
                                  fontWeight: FontWeight.w500,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
