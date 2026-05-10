import 'package:flutter/material.dart';
import '../database/user_dao.dart';
import '../services/api_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String nome = "";
  String email = "";
  String senha = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Cadastro'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _input('Nome', (v) => nome = v),
            _input('Email', (v) => email = v),
            _input('Senha', (v) => senha = v, isPassword: true),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                try {
                  if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Preencha todos os campos'),
                      ),
                    );
                    return;
                  }

                  final sucesso = await ApiService.register(
                    nome,
                    email,
                    senha,
                  );

                  if (!sucesso) {
                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Erro ao cadastrar usuário'),
                      ),
                    );
                    return;
                  }

                  await UserDAO().criarUsuario(
                    nome,
                    email,
                    senha,
                  );

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Usuário criado com sucesso!'),
                    ),
                  );

                  Navigator.pop(context);

                } catch (e) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro: $e'),
                    ),
                  );
                }
              },
              child: const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(
    String label,
    Function(String) onChanged, {
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.grey[850],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}