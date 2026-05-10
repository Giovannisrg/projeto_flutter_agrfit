import 'dart:convert';
import 'package:http/http.dart' as http;
import '../dto/auth_response_dto.dart';

class ApiService {
  static const String baseUrl = 'https://mobile-ios-login.zani0x03.eti.br/api';

  static const String sistemaId = '3a8802e2-c460-49f7-a5d2-3cf556e8024a';

  static Future<AuthResponseDto?> login(
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
      final data = jsonDecode(response.body);

      return AuthResponseDto.fromJson(data);
    }

    return null;
  }

  static Future<bool> register(String nome, String email, String senha) async {
  final response = await http.post(
    Uri.parse('$baseUrl/register'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'name': nome.trim(),
      'surname': nome.trim(),
      'login': email.trim(),
      'email': email.trim(),
      'password': senha.trim(),
      'sistemaId': sistemaId,
    }),
  );

  print("STATUS REGISTER: ${response.statusCode}");
  print("BODY REGISTER: ${response.body}");

  return response.statusCode == 200 || response.statusCode == 201;
}
}
