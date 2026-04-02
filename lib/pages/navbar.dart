import 'package:flutter/material.dart';

//import 'chatbot.dart';
//import 'configuracao.dart';
import 'perfil.dart';
//import 'treino.dart';

class NavBarPage extends StatefulWidget {
  const NavBarPage({super.key});

  @override
  State<NavBarPage> createState() => _NavBarPageState();
}

class _NavBarPageState extends State<NavBarPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    //const TreinoPage(),
    //const ChatbotPage(),
    const PerfilPage(),
    //const ConfiguracaoPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],

      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black,
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
                color: Colors.purpleAccent,
                shape: BoxShape.circle,
              )
            : null,
        child: Icon(icon, color: isSelected ? Colors.black : Colors.white),
      ),
    );
  }
}
