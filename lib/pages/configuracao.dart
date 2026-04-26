import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  bool notificacoesAtivas = true;

  @override
  void initState() {
    super.initState();
    _carregarPreferencias();
  }

  Future<void> _carregarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notificacoesAtivas = prefs.getBool('notificacoes') ?? true;
    });
  }

  Future<void> _toggleNotificacoes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notificacoesAtivas = !notificacoesAtivas;
    });
    await prefs.setBool('notificacoes', notificacoesAtivas);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Configurações',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton('Aparência', onPressed: () => _showEmBreve(context)),
                _buildButton(
                  'Privacidade',
                  onPressed: () => _showPrivacidade(context),
                ),
                _buildButton(
                  'Notificações: ${notificacoesAtivas ? "Ligadas" : "Desligadas"}',
                  onPressed: _toggleNotificacoes,
                ),
                _buildButton('Preferências de treino', onPressed: () => _showEmBreve(context)),
                _buildButton('Ajuda', onPressed: () => _showAjuda(context)),
                _buildButton('Sair', onPressed: () => _confirmLogout(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text, {VoidCallback? onPressed}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              text == 'Sair' ? Colors.red.shade700 : Colors.purple,
          foregroundColor: Colors.white,
          minimumSize: const Size(300, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: onPressed ?? () {},
        child: Text(text),
      ),
    );
  }

  void _showEmBreve(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🚧 Em breve'),
        content: const Text(
          'Essa funcionalidade está em desenvolvimento e estará disponível em breve.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPrivacidade(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacidade'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Seus dados são armazenados localmente no dispositivo.'),
            SizedBox(height: 10),
            Text('Informações coletadas:'),
            Text('- Nome'),
            Text('- Email'),
            Text('- Peso, altura e idade'),
            SizedBox(height: 10),
            Text('Esses dados são utilizados apenas para personalização dos treinos.'),
            SizedBox(height: 10),
            Text('Nenhuma informação é compartilhada com terceiros.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _showAjuda(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajuda'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: atendimento@agrfit.com.br'),
            SizedBox(height: 8),
            Text('WhatsApp: +55 11 91234-5678'),
            SizedBox(height: 8),
            Text('Instagram: @agrfit'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Tem certeza que deseja sair da conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _logout(context);
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;

    Navigator.of(this.context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainApp()),
      (route) => false,
    );
  }
}
