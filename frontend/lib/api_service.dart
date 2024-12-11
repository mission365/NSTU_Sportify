import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://127.0.0.1:8000/api';

  // Fetch all events
  Future<List<dynamic>> fetchEvents() async {
    final response = await http.get(Uri.parse('$baseUrl/events/'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load events');
    }
  }
  Future<List<dynamic>> fetchRepresentatives() async {
    final response = await http.get(Uri.parse('$baseUrl/representatives/'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load representative');
    }
  }
  // Fetch all teams
  Future<List<dynamic>> fetchTeams() async {
    final response = await http.get(Uri.parse('$baseUrl/teams/'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load teams');
    }
  }

  // Fetch all players
  Future<List<dynamic>> fetchPlayers() async {
    final response = await http.get(Uri.parse('$baseUrl/players/'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load players');
    }
  }

  // Fetch all match details
  Future<List<dynamic>> fetchMatchDetails() async {
    final response = await http.get(Uri.parse('$baseUrl/matchdetails/'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load match details');
    }
  }

  // Fetch all scores
  Future<List<dynamic>> fetchScores() async {
    final response = await http.get(Uri.parse('$baseUrl/livescores/'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load scores');
    }
  }

  // Fetch all standings
  Future<List<dynamic>> fetchStandings() async {
    final response = await http.get(Uri.parse('$baseUrl/standings/'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load standings');
    }
  }

  // Fetch all notices
  Future<List<dynamic>> fetchNotices() async {
    final response = await http.get(Uri.parse('$baseUrl/notices/'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load notices');
    }
  }
  Future<List<dynamic>> fetchLiveScores() async {
    final response = await http.get(Uri.parse('$baseUrl/livescores/'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load live scores');
    }
  }
  Future<List<dynamic>> fetchResults() async{
    final response = await http.get(Uri.parse('$baseUrl/results/'));
    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }
    else{
      throw Exception('Failed to load results');
    }
  }
  Future<Map<String, dynamic>> fetchCricketMatchDetails(int matchId) async {
    final url = Uri.parse('$baseUrl/cricket/$matchId/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load match details');
    }
  }
  Future<Map<String, dynamic>> fetchResultDetails(int resultId) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/result/$resultId/details/'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load result details');
    }
  }
  Future<String?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/login/'),
      body: {'username': username, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['access'];
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserRole(String accessToken) async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/user/'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }
}
