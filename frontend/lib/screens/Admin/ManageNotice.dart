import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ManageNoticesPage extends StatefulWidget {
  final String token;

  ManageNoticesPage({Key? key, required this.token}) : super(key: key);

  @override
  _ManageNoticesPageState createState() => _ManageNoticesPageState();
}

class _ManageNoticesPageState extends State<ManageNoticesPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<dynamic> notices = [];
  List<dynamic> events = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNoticesAndEvents();
  }

  Future<void> fetchNoticesAndEvents() async {
    final noticeUrl = Uri.parse('http://127.0.0.1:8000/api/notices/');
    final eventUrl = Uri.parse('http://127.0.0.1:8000/api/events/');

    try {
      final noticeResponse = await http.get(noticeUrl, headers: {
        'Authorization': 'Bearer ${widget.token}',
      });

      final eventResponse = await http.get(eventUrl, headers: {
        'Authorization': 'Bearer ${widget.token}',
      });

      if (noticeResponse.statusCode == 200 && eventResponse.statusCode == 200) {
        setState(() {
          notices = json.decode(noticeResponse.body);
          events = json.decode(eventResponse.body);
          isLoading = false;
        });
      } else {
        throw Exception("Failed to fetch data");
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data')),
      );
    }
  }

  Future<void> createNotice(
      String title, String content, int eventId) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/notices/');
    final currentDate =
        DateTime.now().toIso8601String().split('T').first; // YYYY-MM-DD format

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: json.encode({
          'title': title,
          'content': content,
          'event': eventId,
          'posted_date': currentDate,
        }),
      );

      if (response.statusCode == 201) {
        final newNotice = json.decode(response.body);
        setState(() {
          notices.insert(0, newNotice);
          _listKey.currentState?.insertItem(0);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Notice created successfully')),
        );
      } else {
        throw Exception("Failed to create notice");
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating notice')),
      );
    }
  }

  Future<void> _deleteNotice(int index) async {
    final noticeId = notices[index]['notice_id'];
    final url = Uri.parse('http://127.0.0.1:8000/api/notices/$noticeId/');

    try {
      final response = await http.delete(url, headers: {
        'Authorization': 'Bearer ${widget.token}',
      });

      if (response.statusCode == 204) {
        final removedNotice = notices.removeAt(index);
        _listKey.currentState?.removeItem(
          index,
              (context, animation) => _buildNoticeCard(context, removedNotice, animation),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Notice deleted successfully')),
        );
      } else {
        throw Exception("Failed to delete notice");
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting notice')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Notices',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[200]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : AnimatedList(
          key: _listKey,
          initialItemCount: notices.length,
          itemBuilder: (context, index, animation) {
            return _buildNoticeCard(
              context,
              notices[index],
              animation,
              index: index,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateNoticeDialog(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  Widget _buildNoticeCard(BuildContext context, dynamic notice, Animation<double> animation, {int? index}) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          title: Text(
            notice['title'],
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Text(
            notice['content'],
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey[600]),
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              // Show the confirmation dialog before deletion
              _showDeleteConfirmationDialog(context, index!);
            },
          ),
          onTap: () => _showNoticeDetails(context, notice),
        ),
      ),
    );
  }

  void _showCreateNoticeDialog(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    int? selectedEvent;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create Notice'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Notice Title'),
              ),
              TextField(
                controller: contentController,
                decoration: InputDecoration(labelText: 'Notice Content'),
              ),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Select Event'),
                items: events.map<DropdownMenuItem<int>>((event) {
                  return DropdownMenuItem<int>(
                    value: event['event_id'],
                    child: Text(event['title']),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedEvent = value;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  contentController.text.isNotEmpty &&
                  selectedEvent != null) {
                createNotice(
                  titleController.text,
                  contentController.text,
                  selectedEvent!,
                );
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please fill all fields')),
                );
              }
            },
            child: Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showNoticeDetails(BuildContext context, dynamic notice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notice['title']),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Content:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(notice['content']),
              SizedBox(height: 16),
              Text(
                'Posted Date:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(notice['posted_date']),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Notice'),
        content: Text('Are you sure you want to delete this notice?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog without deleting
            },
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              // Proceed with deletion
              _deleteNotice(index);
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
