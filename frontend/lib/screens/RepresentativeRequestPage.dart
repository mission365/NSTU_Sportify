import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RepresentativeRequestPage extends StatefulWidget {
  @override
  _RepresentativeRequestPageState createState() =>
      _RepresentativeRequestPageState();
}

class _RepresentativeRequestPageState
    extends State<RepresentativeRequestPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String? _selectedDepartment; // Holds the selected department
  List<dynamic> _departments = []; // Holds the fetched department data

  @override
  void initState() {
    super.initState();
    _fetchDepartments();
  }

  Future<void> _fetchDepartments() async {
    try {
      final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/departments/'));

      if (response.statusCode == 200) {
        setState(() {
          _departments = json.decode(response.body);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch departments')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _submitRequest() async {
    if (_selectedDepartment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a department')),
      );
      return;
    }

    // Print the submitted details
    print({
      'name': _nameController.text,
      'email': _emailController.text,
      'department_name': _selectedDepartment, // Print selected department
    });

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/representative-requests/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': _nameController.text,
          'email': _emailController.text,
          'department_name': _selectedDepartment, // Send selected department
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Request submitted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit request')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Representative Request')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedDepartment,
              decoration: InputDecoration(labelText: 'Department'),
              items: _departments.map((department) {
                return DropdownMenuItem<String>(
                  value: department['name'],
                  child: Text(department['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDepartment = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitRequest,
              child: Text('Submit Request'),
            ),
          ],
        ),
      ),
    );
  }
}
