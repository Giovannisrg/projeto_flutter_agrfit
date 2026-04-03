import 'package:flutter/material.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Perfil'),
        foregroundColor: const Color.fromARGB(255, 226, 226, 226),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // depois você liga com configurações
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // FOTO
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.purple,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),

            const SizedBox(height: 15),

            const Text(
              'Ana Júlia M.',
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),

            const SizedBox(height: 5),

            const Text('Brasil 🇧🇷', style: TextStyle(color: Colors.white54)),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _InfoBox(title: 'Peso', value: '75 kg'),
                _InfoBox(title: 'Altura', value: '161 cm'),
                _InfoBox(title: 'Idade', value: '21'),
              ],
            ),

            const SizedBox(height: 20),

            _CardInfo(
              icon: Icons.favorite,
              title: '70 bpm',
              subtitle: 'Batimentos',
            ),

            const SizedBox(height: 10),

            _CardInfo(
              icon: Icons.local_fire_department,
              title: '28500 kcal',
              subtitle: 'Calorias',
            ),

            const SizedBox(height: 20),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Produtividade',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Gráfico semanal (simulado)',
                    style: TextStyle(color: Colors.white54),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String title;
  final String value;

  const _InfoBox({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18)),
        Text(title, style: const TextStyle(color: Colors.white54)),
      ],
    );
  }
}

class _CardInfo extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _CardInfo({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.purple),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(color: Colors.white)),
          const Spacer(),
          Text(subtitle, style: const TextStyle(color: Colors.white54)),
        ],
      ),
    );
  }
}
