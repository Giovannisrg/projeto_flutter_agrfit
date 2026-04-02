import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AGR Fit',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usuarioController = TextEditingController();
  final _senhaController = TextEditingController();

  String _nomeUsuario = '';
  String _senhaUsuario = '';

  bool _obscurePassword = true;

  void _handleLogin() {
    if (_nomeUsuario.isEmpty || _senhaUsuario.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Preencha todos os campos')));
      return;
    }

    // Aqui entra API futuramente
    debugPrint('Usuário: $_nomeUsuario');
    debugPrint('Senha: $_senhaUsuario');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login realizado (simulação)')),
    );
  }

  @override
  void dispose() {
    _usuarioController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDAD3E8),
      appBar: AppBar(
        title: const Text('AGR Fit', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.indigo[200],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset('assets/images/logo.png', height: 120),
                  ),

                  const SizedBox(height: 20),

                  const Center(
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // USUÁRIO
                  const Text('Usuário'),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _usuarioController,
                    decoration: const InputDecoration(
                      hintText: 'Digite o nome de usuário',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (valor) {
                      setState(() {
                        _nomeUsuario = valor;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  // SENHA
                  const Text('Senha'),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _senhaController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Digite sua senha',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    onChanged: (valor) {
                      setState(() {
                        _senhaUsuario = valor;
                      });
                    },
                  ),

                  const SizedBox(height: 25),

                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo[200],
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: _handleLogin,
                        child: const Text('Login'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
