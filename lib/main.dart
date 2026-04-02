import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: LoginPage());
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controller = TextEditingController();
  String _nomeUsuario = "";
  String _senhaUsuario = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFFDAD3E8),
        appBar: AppBar(
          title: const Text('AGR Fit', style: TextStyle(color: Colors.black)),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 250.0,
              vertical: 20.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset('assets/images/logo.png', height: 120),
                ),

                const SizedBox(height: 20),

                Center(
                  child: Text(
                    'LOGIN',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),

                const SizedBox(height: 20),

                const Text('Usuário'),
                const SizedBox(height: 5),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Digite o nome de usuário:',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (valor) {
                    setState(() {
                      _nomeUsuario = valor;
                    });
                  },
                ),

                const SizedBox(height: 20),

                const Text('Senha'),
                const SizedBox(height: 5),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Digite sua senha:',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (valor) {
                    setState(() {
                      _senhaUsuario = valor;
                    });
                  },
                ),

                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[200],
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        String acessarLogin = "";
                      });
                    },
                    child: const Text('Login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
