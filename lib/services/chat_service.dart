import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  static const String url = 'https://mobile-ios-ia.zani0x03.eti.br/api/ai/chat';

  static Future<String> enviarMensagem(String mensagem, String token) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'prompt': mensagem}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data['response'] ?? data['message'] ?? response.body;
    }

    return 'Erro ao conectar com a IA.';
  }
}
