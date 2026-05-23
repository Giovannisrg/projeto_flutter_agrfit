import 'package:flutter/material.dart';
import '../database/user_dao.dart';
import '../services/auth_service.dart';

class PerfilPage extends StatefulWidget {
  final Map<String, dynamic> user;

  const PerfilPage({super.key, required this.user});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  bool editando = false;

  late TextEditingController nomeController;
  late TextEditingController emailController;
  late TextEditingController pesoController;
  late TextEditingController alturaController;
  late TextEditingController idadeController;

  @override
  void initState() {
    super.initState();
    nomeController   = TextEditingController(text: widget.user['nome']);
    emailController  = TextEditingController(text: widget.user['email']);
    pesoController   = TextEditingController(text: widget.user['peso']   ?? '75');
    alturaController = TextEditingController(text: widget.user['altura'] ?? '161');
    idadeController  = TextEditingController(text: widget.user['idade']  ?? '21');
  }

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    pesoController.dispose();
    alturaController.dispose();
    idadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            icon: Icon(editando ? Icons.close : Icons.edit),
            onPressed: () => setState(() => editando = !editando),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            CircleAvatar(
              radius: 50,
              backgroundColor: cs.primary,
              child: Text(
                nomeController.text.isNotEmpty
                    ? nomeController.text[0].toUpperCase()
                    : '',
                style: const TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),

            const SizedBox(height: 15),

            editando
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: TextField(
                      controller: nomeController,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: cs.onSurface, fontSize: 22),
                      decoration: const InputDecoration(border: InputBorder.none),
                    ),
                  )
                : Text(
                    nomeController.text,
                    style: TextStyle(color: cs.onSurface, fontSize: 22),
                  ),

            const SizedBox(height: 5),
            Text('Brasil 🇧🇷',
                style: TextStyle(color: cs.onSurface.withValues(alpha: 0.5))),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(child: _metricaCard(context, 'Peso',   pesoController,   'kg')),
                  const SizedBox(width: 10),
                  Expanded(child: _metricaCard(context, 'Altura', alturaController, 'cm')),
                  const SizedBox(width: 10),
                  Expanded(child: _metricaCard(context, 'Idade',  idadeController,  'anos')),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _CardInfo(icon: Icons.favorite,              title: '70 bpm',    subtitle: 'Batimentos'),
            const SizedBox(height: 10),
            _CardInfo(icon: Icons.local_fire_department, title: '28500 kcal', subtitle: 'Calorias'),

            const SizedBox(height: 20),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.email_outlined, color: cs.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      emailController.text,
                      style: TextStyle(color: cs.onSurface.withValues(alpha: 0.7)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            if (editando)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _salvar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text('Salvar', style: TextStyle(fontSize: 15)),
                  ),
                ),
              ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _metricaCard(
    BuildContext context,
    String label,
    TextEditingController controller,
    String sufixo,
  ) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: cs.surface, // mesmo fundo dos outros cards
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          TextField(
            controller: controller,
            enabled: editando,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            style: TextStyle(
              color: cs.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              filled: true,
              fillColor: Colors.transparent,
              suffixText: sufixo,
              suffixStyle: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.5),
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: cs.onSurface.withValues(alpha: 0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _salvar() async {
    await UserDAO().atualizarUsuario(
      widget.user['id'],
      nomeController.text,
      emailController.text,
      pesoController.text,
      alturaController.text,
      idadeController.text,
    );

    final usuarioAtualizado = await UserDAO().buscarPorEmail(emailController.text);
    await AuthService.saveUser(usuarioAtualizado!);

    if (!mounted) return;

    setState(() => editando = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil atualizado')),
    );
  }
}

class _CardInfo extends StatelessWidget {
  final IconData icon;
  final String   title;
  final String   subtitle;

  const _CardInfo({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: cs.primary),
          const SizedBox(width: 10),
          Text(title,    style: TextStyle(color: cs.onSurface)),
          const Spacer(),
          Text(subtitle, style: TextStyle(color: cs.onSurface.withValues(alpha: 0.5))),
        ],
      ),
    );
  }
}