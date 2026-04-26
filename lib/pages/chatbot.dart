import 'package:flutter/material.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> mensagens = [
    {
      "texto":
          "Oie! Eu sou a Adrianna 💜\nSua assistente de treinos.\nComo posso te ajudar hoje?",
      "isUser": false
    }
  ];

  void enviarMensagem() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      mensagens.add({
        "texto": _controller.text,
        "isUser": true,
      });
    });

    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Adrianna',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mensagens.length,
              itemBuilder: (context, index) {
                final msg = mensagens[index];
                return _buildMensagem(msg["texto"], msg["isUser"]);
              },
            ),
          ),

          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildMensagem(String texto, bool isUser) {
    return Align(
      alignment:
          isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 250),
        decoration: BoxDecoration(
          color: isUser ? Colors.white : Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          texto,
          style: TextStyle(
            color: isUser
                ? Colors.purple // texto do usuário
                : Colors.white, // texto do chatbot
          ),
        ),
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.purple),
              decoration: const InputDecoration(
                hintText: 'Digite sua mensagem...',
                hintStyle: TextStyle(color: Colors.purple),
                border: InputBorder.none,
              ),
            ),
          ),
          GestureDetector(
            onTap: enviarMensagem,
            child: const Icon(Icons.send, color: Colors.purple),
          ),
        ],
      ),
    );
  }
}