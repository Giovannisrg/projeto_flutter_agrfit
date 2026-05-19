import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/db_helper.dart';
import '../main.dart' show salvarTema, temaAtual;

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  bool notificacoesAtivas = true;
  bool temaClaro = false;

  @override
  void initState() {
    super.initState();
    _carregarPreferencias();
  }

  Future<void> _carregarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notificacoesAtivas = prefs.getBool('notificacoes') ?? true;
      temaClaro = temaAtual.value == ThemeMode.light;
    });
  }

  Future<void> _toggleNotificacoes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => notificacoesAtivas = !notificacoesAtivas);
    await prefs.setBool('notificacoes', notificacoesAtivas);
  }

  Future<void> _toggleTema() async {
    final novoModo = temaClaro ? ThemeMode.dark : ThemeMode.light;
    await salvarTema(novoModo);
    setState(() => temaClaro = !temaClaro);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações'), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Aparência — botão igual aos outros, com ícone dinâmico ──
                _buildButton(
                  context,
                  temaClaro ? 'Modo claro' : 'Modo escuro',
                  onPressed: _toggleTema,
                ),

                _buildButton(context, 'Privacidade',
                    onPressed: () => _showPrivacidade(context)),

                // ── Notificações — botão com estado inline ─────────────────
                _buildButton(
                  context,
                  notificacoesAtivas
                      ? 'Notificações: Ligadas'
                      : 'Notificações: Desligadas',
                  onPressed: _toggleNotificacoes,
                ),

                _buildButton(context, 'Sobre o App',
                    onPressed: () => _showSobre(context)),

                _buildButton(context, 'Ajuda',
                    onPressed: () => _showAjuda(context)),

                const SizedBox(height: 20),

                _buildButton(context, 'Sair',
                    onPressed: () => _confirmLogout(context), isSair: true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Botão padrão (todos do mesmo tamanho) ─────────────────────────────────
  Widget _buildButton(
    BuildContext context,
    String text, {
    VoidCallback? onPressed,
    bool isSair = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isSair ? Colors.red.shade700 : Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: onPressed ?? () {},
        child: Text(text),
      ),
    );
  }

  void _showSobre(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sobre o App'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AGR Fit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 6),
            Text('Versão 1.0.0'),
            SizedBox(height: 12),
            Text('Desenvolvido por:', style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 4),
            Text('• Ana Júlia Morais Moreira'),
            Text('• Rafaela da Silva'),
            Text('• Giovanni S. R. Gemignani'),
            SizedBox(height: 12),
            Text('Ciência da Computação — Grupo Anchieta'),
            SizedBox(height: 4),
            Text('Disciplina: Desenvolvimento Mobile'),
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
            Text('• Nome'),
            Text('• Email'),
            Text('• Peso, altura e idade'),
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
    await DBHelper.instance.closeDatabase();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!context.mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }
}