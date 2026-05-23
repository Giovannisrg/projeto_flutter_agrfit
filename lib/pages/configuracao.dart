import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/db_helper.dart';
import '../services/notification_service.dart';
import '../main.dart';
import '../main.dart' show salvarTema, temaAtual;

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  bool temaClaro          = false;
  bool notificacoesAtivas = false;
  TimeOfDay? horarioNotif;

  @override
  void initState() {
    super.initState();
    _carregarPreferencias();
  }

  Future<void> _carregarPreferencias() async {
    final prefs   = await SharedPreferences.getInstance();
    final horario = await NotificationService.horarioSalvo();

    setState(() {
      temaClaro          = temaAtual.value == ThemeMode.light;
      notificacoesAtivas = prefs.getBool('notificacoes') ?? false;
      if (horario != null) {
        horarioNotif = TimeOfDay(
          hour:   horario['hora']!,
          minute: horario['minuto']!,
        );
      }
    });
  }

  Future<void> _toggleTema() async {
    final novoModo = temaClaro ? ThemeMode.dark : ThemeMode.light;
    await salvarTema(novoModo);
    setState(() => temaClaro = !temaClaro);
  }

  Future<void> _toggleNotificacoes() async {
    if (!notificacoesAtivas) {
      final horario = await showTimePicker(
        context: context,
        initialTime: horarioNotif ?? const TimeOfDay(hour: 8, minute: 0),
        helpText: 'Escolha o horário do lembrete',
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              timePickerTheme: TimePickerThemeData(
                backgroundColor: Theme.of(context).cardColor,
              ),
            ),
            child: child!,
          );
        },
      );

      if (horario == null) return;

      await NotificationService.agendarLembreteDiario(
        horario.hour,
        horario.minute,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notificacoes', true);

      if (!mounted) return;
      setState(() {
        notificacoesAtivas = true;
        horarioNotif       = horario;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Lembrete ativado às ${horario.format(context)} 🔔',
          ),
        ),
      );
    } else {
      await NotificationService.cancelarLembreteDiario();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notificacoes', false);

      if (!mounted) return;
      setState(() {
        notificacoesAtivas = false;
        horarioNotif       = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lembrete desativado 🔕')),
      );
    }
  }

  Future<void> _editarHorario() async {
    final horario = await showTimePicker(
      context: context,
      initialTime: horarioNotif ?? const TimeOfDay(hour: 8, minute: 0),
      helpText: 'Alterar horário do lembrete',

    );

    if (horario == null || !mounted) return;

    await NotificationService.agendarLembreteDiario(
      horario.hour,
      horario.minute,
    );

    setState(() => horarioNotif = horario);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Horário atualizado para ${horario.format(context)} 🔔'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
//    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações'), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(
                  context,
                  temaClaro ? 'Modo claro' : 'Modo escuro',
                  onPressed: _toggleTema,
                ),

                _buildButton(context, 'Privacidade',
                    onPressed: () => _showPrivacidade(context)),

                _buildButton(
                  context,
                  notificacoesAtivas
                      ? 'Notificações: ${horarioNotif?.format(context) ?? 'Ligadas'}'
                      : 'Notificações: Desligadas',
                  onPressed: _toggleNotificacoes,
                ),

                if (notificacoesAtivas)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _editarHorario,
                      icon: const Icon(Icons.edit),
                      label: const Text('Alterar horário'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
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
          backgroundColor: isSair
              ? Colors.red.shade700
              : Theme.of(context).colorScheme.primary,
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
      builder: (_) => AlertDialog(
        title: const Text('Sobre o App'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AGR Fit',
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 6),
            Text('Versão 1.0.0'),
            SizedBox(height: 12),
            Text('Desenvolvido por:',
                style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 4),
            Text('• Ana Júlia Morais Moreira'),
            Text('• Rafaela da Silva'),
            Text('• Giovanni S. R. Gemignani'),
            SizedBox(height: 12),
            Text('Ciência da Computação — Grupo Anchieta'),
            SizedBox(height: 4),
            Text('Projeto acadêmico desenvolvido em Flutter/Dart para gerenciamento de treinos, com autenticação de usuários e integração com inteligência artificial para assistência personalizada. '),
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
      builder: (_) => AlertDialog(
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
            Text(
                'Esses dados são utilizados apenas para personalização dos treinos.'),
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
      builder: (_) => AlertDialog(
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
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Tem certeza que deseja sair da conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
            Navigator.pop(dialogContext);
            await Future.delayed(const Duration(milliseconds: 100));
            if (!mounted) return;
            _logout(context);
          },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) async {
    await NotificationService.cancelarLembreteDiario();

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('user');
    await prefs.remove('token');

    if (!context.mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const MainApp(),
      ),
      (route) => false,
    );
  }
}