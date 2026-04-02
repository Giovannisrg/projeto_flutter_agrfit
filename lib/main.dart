import 'dart:async';
import 'package:flutter/material.dart';
import 'pages/navbar.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  String _nomeUsuario = "";
  String _senhaUsuario = "";

  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<String> banners = [
    'assets/images/banner1.png',
    'assets/images/banner2.png',
    'assets/images/banner3.png',
    'assets/images/banner4.png',
  ];

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < banners.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeIn,
      );
    });
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
      body: Column(
        children: [
          SizedBox(
            height: 300,
            child: PageView.builder(
              controller: _controller,
              itemCount: banners.length,
              itemBuilder: (context, index) {
                return _buildBanner(banners[index]);
              },
            ),
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: const BoxDecoration(
                color: Color(0xFFDAD3E8),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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

                    const Text('Senha'),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _senhaController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Digite sua senha',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (valor) {
                        setState(() {
                          _senhaUsuario = valor;
                        });
                      },
                    ),

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo[200],
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          if (_nomeUsuario.isEmpty || _senhaUsuario.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Preencha todos os campos'),
                              ),
                            );
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const NavBarPage(),
                              ),
                            );
                          }
                        },
                        child: const Text('Login'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner(String path) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      child: Image.asset(path, fit: BoxFit.cover, width: double.infinity),
    );
  }
}
