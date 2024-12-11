import 'package:flutter/material.dart';
import '../models/result.dart';

class CarromDetailScreen extends StatelessWidget {
  final Result result;

  const CarromDetailScreen({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrom Match Details'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Carrom Match',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Match ID: ${result.resultId}', style: TextStyle(fontSize: 18)),
            Text('Winner: ${result.winnerTeam}', style: TextStyle(fontSize: 18)),
            Text('Loser: ${result.loserTeam}', style: TextStyle(fontSize: 18)),
            Text('Date: ${result.matchDate}', style: TextStyle(fontSize: 18)),
            Text('Draw: ${result.draw ? "Yes" : "No"}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
