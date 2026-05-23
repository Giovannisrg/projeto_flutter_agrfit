import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'chatbot.dart';
import 'configuracao.dart';
import 'perfil.dart';
import 'treino.dart';

class NavBarPage extends StatefulWidget {
  final Map<String, dynamic> user;

  const NavBarPage({super.key, required this.user});

  @override
  State<NavBarPage> createState() => _NavBarPageState();
}

class _NavBarPageState extends State<NavBarPage> {
  int _currentIndex = 0;
  Map<String, dynamic>? usuarioPerfil;

  @override
  void initState() {
    super.initState();
    carregarUsuario();
  }

  Future<void> carregarUsuario() async {
    usuarioPerfil = await AuthService.getUser();
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          TreinoPage(user: widget.user),

          const ChatbotPage(),

          usuarioPerfil == null
              ? const Center(child: CircularProgressIndicator())
              : PerfilPage(user: usuarioPerfil!),

          const ConfigPage(),
        ],
      ),

      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: cs.primary,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildItem(Icons.fitness_center, 0),
            _buildItem(Icons.smart_toy,      1),
            _buildItem(Icons.person,         2),
            _buildItem(Icons.settings,       3),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(IconData icon, int index) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () async {
        if (index == 2) await carregarUsuario();
        if (!mounted) return;
        setState(() => _currentIndex = index);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: isSelected
            ? const BoxDecoration(color: Colors.white, shape: BoxShape.circle)
            : null,
        child: Icon(
          icon,
          color: isSelected
              ? const Color(0xFF5A319F)
              : Colors.white,
        ),
      ),
    );
  }
}