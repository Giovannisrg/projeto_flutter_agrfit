import 'package:flutter/material.dart';
import '../services/chat_service.dart';
import '../services/auth_service.dart';

class ChatbotPage extends StatefulWidget {
  final String? perguntaInicial;

  const ChatbotPage({super.key, this.perguntaInicial});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();

  bool carregando = false;
  bool telaAtiva  = true;
  int  requestId  = 0;

  List<Map<String, dynamic>> mensagens = [
    {
      'texto':  'Oie! Eu sou a Adrianna 💜\nSua assistente de treinos.\nComo posso te ajudar hoje?',
      'isUser': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.perguntaInicial != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        _controller.text = widget.perguntaInicial!;
        await enviarMensagem();
      });
    }
  }

  @override
  void dispose() {
    telaAtiva = false;
    requestId++;
    _controller.dispose();
    super.dispose();
  }

  Future<void> enviarMensagem() async {
    if (carregando || !mounted || !telaAtiva) return;
    if (_controller.text.trim().isEmpty) return;

    final pergunta = _controller.text;

    setState(() {
      mensagens.add({'texto': pergunta, 'isUser': true});
      carregando = true;
    });

    _controller.clear();

    final currentRequest = ++requestId;
    final token = await AuthService.getToken();

    if (!mounted || !telaAtiva || currentRequest != requestId) return;

    if (token == null) {
      setState(() {
        mensagens.add({'texto': 'Usuário não autenticado.', 'isUser': false});
        carregando = false;
      });
      return;
    }

    try {
      final resposta = await ChatService.enviarMensagem(pergunta, token);
      if (!mounted || !telaAtiva || currentRequest != requestId) return;
      setState(() {
        mensagens.add({'texto': resposta, 'isUser': false});
        carregando = false;
      });
    } catch (e) {
      if (!mounted || !telaAtiva || currentRequest != requestId) return;
      setState(() {
        mensagens.add({'texto': 'Erro: $e', 'isUser': false});
        carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs      = Theme.of(context).colorScheme;
    final isEscuro = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adrianna'),
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
                return _buildMensagem(context, msg['texto'], msg['isUser']);
              },
            ),
          ),

          if (carregando)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: CircularProgressIndicator(color: cs.primary),
            ),

          _buildInput(context, isEscuro, cs),
        ],
      ),
    );
  }

  Widget _buildMensagem(BuildContext context, String texto, bool isUser) {
    final cs = Theme.of(context).colorScheme;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 250),
        decoration: BoxDecoration(
          color: isUser ? cs.primary : cs.surface,
          borderRadius: BorderRadius.circular(16),
          border: isUser
              ? null
              : Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
        ),
        child: Text(
          texto,
          style: TextStyle(
            color: isUser ? Colors.white : cs.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildInput(BuildContext context, bool isEscuro, ColorScheme cs) {
    final corFundo = isEscuro ? const Color(0xFF1C1C1C) : Colors.white;
    final corTexto = isEscuro ? Colors.white : cs.primary;
    final corHint  = isEscuro
        ? Colors.white.withValues(alpha: 0.35)
        : cs.primary.withValues(alpha: 0.5);
    final corBorda = isEscuro
        ? cs.primary.withValues(alpha: 0.6)
        : cs.onSurface.withValues(alpha: 0.15);

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: corFundo,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: corBorda, width: 1.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: TextStyle(color: corTexto),
              decoration: InputDecoration(
                hintText: 'Digite sua mensagem...',
                hintStyle: TextStyle(color: corHint),
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.transparent,
              ),
            ),
          ),
          GestureDetector(
            onTap: enviarMensagem,
            child: Icon(Icons.send, color: cs.primary),
          ),
        ],
      ),
    );
  }
}