import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ViewRequestsPage extends StatefulWidget {
  final String token;

  ViewRequestsPage({Key? key, required this.token}) : super(key: key);

  @override
  _ViewRequestsPageState createState() => _ViewRequestsPageState();
}

class _ViewRequestsPageState extends State<ViewRequestsPage> {
  List<dynamic> _pendingRequests = [];
  List<dynamic> _approvedRequests = [];
  List<dynamic> _rejectedRequests = [];
  Timer? _pollingTimer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchRequests() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/representative-requests/'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        final requests = json.decode(response.body);

        // Fetch department names for each request
        for (var request in requests) {
          final departmentName = await _fetchDepartmentName(request['department']);
          request['department_name'] = departmentName; // Add department name to the request
        }

        setState(() {
          _pendingRequests = requests.where((r) => r['status'] == 'pending').toList();
          _approvedRequests = requests.where((r) => r['status'] == 'approved').toList();
          _rejectedRequests = requests.where((r) => r['status'] == 'rejected').toList();
          _isLoading = false;
        });
      } else {
        _showSnackBar('Failed to fetch requests.');
      }
    } catch (e) {
      _showSnackBar('Error fetching requests: $e');
    }
  }


  void _startPolling() {
    _fetchRequests();
    _pollingTimer = Timer.periodic(Duration(seconds: 5), (_) => _fetchRequests());
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _approveRequest(int requestId) async {
    await _handleRequest(requestId, 'approve_request', 'approved');
  }

  Future<void> _rejectRequest(int requestId) async {
    await _handleRequest(requestId, 'reject_request', 'rejected');
  }

  Future<void> _handleRequest(int requestId, String endpoint, String status) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/representative-requests/$requestId/$endpoint/'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        _showSnackBar('Request $status successfully.');
        _fetchRequests();
      } else {
        _showSnackBar('Failed to $status request.');
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }
  Future<String> _fetchDepartmentName(int departmentId) async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/departments/$departmentId/'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        final department = json.decode(response.body);
        return department['name'];
      } else {
        return 'Unknown Department';
      }
    } catch (e) {
      return 'Error Fetching Department';
    }
  }

  Widget _buildRequestList(List<dynamic> requests, String status, {bool isInteractive = false}) {
    if (requests.isEmpty) {
      return Center(
        child: Text(
          'No $status requests.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: status == 'approved'
                  ? Colors.green
                  : status == 'rejected'
                  ? Colors.red
                  : Colors.orange,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(
              request['name'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email: ${request['email']}'),
                Text('Department: ${request['department_name']}'),
                Text('Status: ${request['status']}'),
              ],
            ),
            trailing: isInteractive
                ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.check, color: Colors.green),
                  onPressed: () => _approveRequest(request['id']),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.red),
                  onPressed: () => _rejectRequest(request['id']),
                ),
              ],
            )
                : null,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Requests'),
        backgroundColor: Colors.indigo,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              labelColor: Colors.indigo,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.indigo,
              tabs: [
                Tab(icon: Icon(Icons.pending), text: 'Pending'),
                Tab(icon: Icon(Icons.check_circle), text: 'Approved'),
                Tab(icon: Icon(Icons.cancel), text: 'Rejected'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildRequestList(_pendingRequests, 'pending', isInteractive: true),
                  _buildRequestList(_approvedRequests, 'approved'),
                  _buildRequestList(_rejectedRequests, 'rejected'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
