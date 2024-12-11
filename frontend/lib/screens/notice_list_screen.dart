import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/notice.dart';

class NoticeListScreen extends StatefulWidget {
  @override
  _NoticeListScreenState createState() => _NoticeListScreenState();
}

class _NoticeListScreenState extends State<NoticeListScreen> {
  late Future<List<Notice>> futureNotices;

  @override
  void initState() {
    super.initState();
    futureNotices = fetchNotices();
  }

  Future<List<Notice>> fetchNotices() async {
    ApiService apiService = ApiService();
    List<dynamic> noticesJson = await apiService.fetchNotices();
    return noticesJson.map((json) => Notice.fromJson(json)).toList();
  }

  // Function to show the notice details when clicked
  void _showNoticeDetail(BuildContext context, Notice notice) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(notice.title),
          content: Text(notice.content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notices'),
        backgroundColor: Color(0xFF003366),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg.jpg"), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Foreground Content
          FutureBuilder<List<Notice>>(
            future: futureNotices,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Notice>? notices = snapshot.data;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title Section
                        Center(
                          child: Text(
                            'Notice',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF003366),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        // List of Notices
                        for (var notice in notices!)
                          NoticeItem(
                            date: notice.postedDate,
                            title: notice.title,
                            onTap: () {
                              _showNoticeDetail(context, notice);
                            },
                          ),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }
}

class NoticeItem extends StatelessWidget {
  final String date;
  final String title;
  final VoidCallback onTap;

  const NoticeItem({
    required this.date,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Section
          Text(
            date,
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFFB73C3C),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),

          // Title Section with Icon
          Row(
            children: [
              Icon(
                Icons.notifications,
                color: Color(0xFFB73C3C),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),

          // Clickable Link
          InkWell(
            onTap: onTap, // The action when the link is clicked
            child: Text(
              'Click here',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
