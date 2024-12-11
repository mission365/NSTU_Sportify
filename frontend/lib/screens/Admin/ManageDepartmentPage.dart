import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ManageDepartmentsPage extends StatefulWidget {
  final String token;

  ManageDepartmentsPage({Key? key, required this.token}) : super(key: key);

  @override
  _ManageDepartmentsPageState createState() => _ManageDepartmentsPageState();
}

class _ManageDepartmentsPageState extends State<ManageDepartmentsPage> {
  final TextEditingController _departmentController = TextEditingController();
  List<Map<String, dynamic>> _departments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDepartments();
  }

  Future<void> _fetchDepartments() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/departments/'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _departments = data.map((e) => {
            'id': e['department_id'],
            'name': e['name'],
          }).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load departments');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching departments: $e')),
      );
    }
  }

  Future<void> _createDepartment(String name) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/departments/'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'name': name}),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final int departmentId = data['department_id'];

        setState(() {
          _departments.add({'id': departmentId, 'name': name});
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Department created successfully.')),
        );
      } else {
        throw Exception('Failed to create department');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating department: $e')),
      );
    }
  }

  Future<void> _deleteDepartment(int departmentId) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Department'),
        content: Text('Are you sure you want to delete this department?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete'),
          ),
        ],
      ),
    ) ??
        false;

    if (confirmDelete) {
      try {
        final response = await http.delete(
          Uri.parse('http://127.0.0.1:8000/api/departments/$departmentId/'),
          headers: {
            'Authorization': 'Bearer ${widget.token}',
          },
        );

        if (response.statusCode == 204) {
          setState(() {
            _departments.removeWhere((department) => department['id'] == departmentId);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Department deleted successfully.')),
          );
        } else {
          throw Exception('Failed to delete department');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting department: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Departments'),
        backgroundColor: Colors.indigoAccent,
        centerTitle: true,
        elevation: 8,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.indigo.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create a New Department',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: _departmentController,
                        decoration: InputDecoration(
                          labelText: 'Department Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          prefixIcon: Icon(Icons.apartment, color: Colors.indigoAccent),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final name = _departmentController.text.trim();
                            if (name.isNotEmpty) {
                              _createDepartment(name);
                              _departmentController.clear();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Department name cannot be empty.')),
                              );
                            }
                          },
                          icon: Icon(Icons.add, size: 20),
                          label: Text('Create'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.indigo,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Existing Departments',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _departments.length,
                  itemBuilder: (context, index) {
                    final department = _departments[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.indigoAccent,
                          child: Icon(Icons.business, color: Colors.white),
                        ),
                        title: Text(
                          department['name'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteDepartment(department['id']),
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
