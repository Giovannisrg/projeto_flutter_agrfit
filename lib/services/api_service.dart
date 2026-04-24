import 'dart:convert';
import 'package:http/http.dart' as http;

class Album {
  final int userId;
  final int id;
  final String title;

  Album({required this.userId, required this.id, required this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(userId: json['userId'], id: json['id'], title: json['title']);
  }
}

class ApiService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<Album>> fetchAlbums(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/albums'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body);
      return list.map((e) => Album.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar treinos');
    }
  }

  Future<Album> createAlbum(String title, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/albums'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'title': title}),
    );

    if (response.statusCode == 201) {
      return Album.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao criar treino');
    }
  }

  Future<Album> updateAlbum(int id, String title, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/albums/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'title': title}),
    );

    if (response.statusCode == 200) {
      return Album.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao atualizar treino');
    }
  }

  Future<void> deleteAlbum(int id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/albums/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar treino');
    }
  }
}
