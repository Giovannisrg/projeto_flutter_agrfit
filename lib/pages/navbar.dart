import 'package:flutter/material.dart';

import 'package:projeto_flutter_agrfit/pages/chatbot.dart';
import 'package:projeto_flutter_agrfit/pages/configuracao.dart';
import 'package:projeto_flutter_agrfit/pages/perfil.dart';
import 'package:projeto_flutter_agrfit/pages/treino.dart';


class NavBarPage extends StatefulWidget {
  final Map<String, dynamic> user;

  const NavBarPage({super.key, required this.user});

  @override
  State<NavBarPage> createState() => _NavBarPageState();
}

class _NavBarPageState extends State<NavBarPage> {
  int _currentIndex = 0;

  late final List<Widget> _pages;
  @override
  void initState() {
    super.initState();

    _pages = [
      TreinoPage(user: widget.user),
      const ChatbotPage(),
      PerfilPage(user: widget.user),
      const ConfigPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      backgroundColor: Colors.black,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildItem(Icons.fitness_center, 0),
            _buildItem(Icons.smart_toy, 1),
            _buildItem(Icons.person, 2),
            _buildItem(Icons.settings, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(IconData icon, int index) {
    bool isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: isSelected
            ? const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                shape: BoxShape.circle,
              )
            : null,
        child: Icon(
          icon,
          color: isSelected
              ? const Color.fromARGB(255, 90, 49, 159)
              : Colors.white,
        ),
      ),
    );
  }
}
