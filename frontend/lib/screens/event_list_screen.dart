import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/event.dart';

class EventListScreen extends StatefulWidget {
  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  late Future<List<Event>> futureEvents;
  List<Event> upcomingEvents = [];
  List<Event> currentEvents = [];
  List<Event> pastEvents = [];

  @override
  void initState() {
    super.initState();
    futureEvents = fetchAndCategorizeEvents();
  }

  Future<List<Event>> fetchAndCategorizeEvents() async {
    ApiService apiService = ApiService();
    List<dynamic> eventsJson = await apiService.fetchEvents();
    List<Event> events = eventsJson.map((json) => Event.fromJson(json)).toList();

    final now = DateTime.now();

    upcomingEvents = events.where((e) => DateTime.parse(e.startDate).isAfter(now)).toList();
    currentEvents = events.where((e) {
      DateTime startDate = DateTime.parse(e.startDate);
      DateTime endDate = DateTime.parse(e.endDate);
      return startDate.isBefore(now) && endDate.isAfter(now);
    }).toList();
    pastEvents = events.where((e) => DateTime.parse(e.endDate).isBefore(now)).toList();

    return events;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event List'),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 4,
      ),
      body: FutureBuilder<List<Event>>(
        future: futureEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSection("Upcoming Events", upcomingEvents, Colors.blue[100]!),
                    const SizedBox(height: 24),
                    buildSection("Current Events", currentEvents, Colors.green[100]!),
                    const SizedBox(height: 24),
                    buildSection("Past Events", pastEvents, Colors.grey[300]!),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget buildSection(String title, List<Event> events, Color cardColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurpleAccent.shade700,
            shadows: [
              Shadow(
                blurRadius: 2.0,
                color: Colors.grey.shade400,
                offset: Offset(1, 1),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        events.isEmpty
            ? Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 5,
                offset: Offset(2, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          child: const Text(
            "No events available",
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
          ),
        )
            : Column(
          children: events.map((e) => buildEventCard(e, cardColor)).toList(),
        ),
      ],
    );
  }

  Widget buildEventCard(Event event, Color cardColor) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cardColor, cardColor.withOpacity(0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 6,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              event.description,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  "From: ${event.startDate}",
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  "To: ${event.endDate}",
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
