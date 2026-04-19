import 'package:flutter/material.dart';
import '../database/user_dao.dart';

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

    nomeController = TextEditingController(text: widget.user['nome']);
    emailController = TextEditingController(text: widget.user['email']);

    pesoController = TextEditingController(text: widget.user['peso'] ?? '75');
    alturaController = TextEditingController(
      text: widget.user['altura'] ?? '161',
    );
    idadeController = TextEditingController(text: widget.user['idade'] ?? '21');
  }

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
            icon: Icon(editando ? Icons.close : Icons.edit),
            onPressed: () {
              setState(() {
                editando = !editando;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.purple,
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
                      style: const TextStyle(color: Colors.white, fontSize: 22),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  )
                : Text(
                    nomeController.text,
                    style: const TextStyle(color: Colors.white, fontSize: 22),
                  ),

            const SizedBox(height: 5),

            const Text('Brasil 🇧🇷', style: TextStyle(color: Colors.white54)),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _editavelBox('Peso', pesoController, 'kg'),
                _editavelBox('Altura', alturaController, 'cm'),
                _editavelBox('Idade', idadeController, ''),
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
                children: [
                  const Text(
                    'Email',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 10),

                  editando
                      ? TextField(
                          controller: emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        )
                      : Text(
                          emailController.text,
                          style: const TextStyle(color: Colors.white54),
                        ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            if (editando)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: _salvar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Salvar'),
                ),
              ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _editavelBox(
    String title,
    TextEditingController controller,
    String sufixo,
  ) {
    return Column(
      children: [
        SizedBox(
          width: 80,
          child: TextField(
            controller: controller,
            enabled: editando,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 18),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: InputBorder.none,
              suffixText: sufixo,
              suffixStyle: const TextStyle(color: Colors.white54),
            ),
          ),
        ),
        Text(title, style: const TextStyle(color: Colors.white54)),
      ],
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

    setState(() {
      editando = false;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Perfil atualizado')));
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
