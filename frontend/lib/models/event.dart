class Event {
  final int eventId;
  final String title;
  final String description;
  final String startDate;
  final String endDate;

  Event({required this.eventId, required this.title, required this.description, required this.startDate, required this.endDate});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventId: json['event_id'],
      title: json['title'],
      description: json['description'],
      startDate: json['start_date'],
      endDate: json['end_date'],
    );
  }
}
