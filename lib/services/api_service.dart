import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://mobile-ios-login.zani0x03.eti.br/api';

  static const String sistemaId = 'd7f0beee-ac36-4cdf-8dba-7c752ace6ec6';

  static Future<Map<String, dynamic>?> login(
    String username,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'sistemaId': sistemaId,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return null;
  }

  static Future<bool> register(String nome, String email, String senha) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': nome,
        'surname': '',
        'login': email,
        'email': email,
        'password': senha,
        'sistemaId': sistemaId,
      }),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }
}
