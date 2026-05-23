import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/navbar.dart';
import 'pages/register_page.dart';
import 'services/auth_service.dart';
import 'services/api_service.dart';
import 'services/notification_service.dart';
import 'database/db_helper.dart';
import 'database/user_dao.dart';
import 'app_theme.dart';

final ValueNotifier<ThemeMode> temaAtual = ValueNotifier(ThemeMode.dark);

Future<void> carregarTema() async {
  final prefs = await SharedPreferences.getInstance();
  final claro = prefs.getBool('tema_claro') ?? false;
  temaAtual.value = claro ? ThemeMode.light : ThemeMode.dark;
}

Future<void> salvarTema(ThemeMode modo) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('tema_claro', modo == ThemeMode.light);
  temaAtual.value = modo;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.instance.database;
  await carregarTema();
  await NotificationService.init(); // ← inicializa notificações
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: temaAtual,
      builder: (context, modo, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme:     temaClaro,
          darkTheme: temaEscuro,
          themeMode: modo,
          home: FutureBuilder<Map<String, dynamic>?>(
            future: AuthService.getUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              final user = snapshot.data;
              if (user != null) return NavBarPage(user: user);
              return const LoginPage();
            },
          ),
        );
      },
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
  final TextEditingController _senhaController   = TextEditingController();

  String _nomeUsuario  = '';
  String _senhaUsuario = '';
  bool   _loading      = false;
  bool _mostrarSenha   = false;

  final PageController _controller = PageController();
  int    _currentPage = 0;
  Timer? _timer;

  final List<String> banners = [
    'assets/images/banner1.png',
    'assets/images/banner2.png',
    'assets/images/banner3.png',
    'assets/images/banner4.png',
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_controller.hasClients) {
        _currentPage = (_currentPage + 1) % banners.length;
        _controller.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _usuarioController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_nomeUsuario.isEmpty || _senhaUsuario.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final response = await ApiService.login(_nomeUsuario, _senhaUsuario);

      if (!mounted) return;

      if (response != null) {
        final token = response.accessToken;

        Map<String, dynamic>? user =
            await UserDAO().buscarPorEmail(_nomeUsuario);

        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Usuário não encontrado'),
            ),
          );

          return;
        }

        await AuthService.saveToken(token);
        await AuthService.saveUser(user!);

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => NavBarPage(user: user!)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login inválido')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
            children: [
              AspectRatio(
                aspectRatio: 4 / 4,
                child: PageView.builder(
                  controller: _controller,
                  itemBuilder: (context, index) =>
                      _buildBanner(banners[index % banners.length]),
                ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          color: cs.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text('E-mail',
                        style: TextStyle(
                            color: cs.onSurface.withValues(alpha: 0.7))),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _usuarioController,
                      style: TextStyle(color: cs.onSurface),
                      onChanged: (v) => _nomeUsuario = v,
                      decoration:
                          const InputDecoration(hintText: 'Digite seu email'),
                    ),

                    const SizedBox(height: 20),
                    Text('Senha',
                        style: TextStyle(
                            color: cs.onSurface.withValues(alpha: 0.7))),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _senhaController,
                      obscureText: !_mostrarSenha,
                      style: TextStyle(color: cs.onSurface),
                      onChanged: (v) => _senhaUsuario = v,
                      decoration: InputDecoration(
                        hintText: 'Digite sua senha',

                        suffixIcon: IconButton(
                          icon: Icon(
                            _mostrarSenha
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _mostrarSenha = !_mostrarSenha;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cs.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: _loading ? null : _login,
                        child: _loading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Login'),
                      ),
                    ),

                    const SizedBox(height: 15),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RegisterPage()),
                        ),
                        child: Text(
                          'Criar conta',
                          style:
                              TextStyle(color: cs.primary, fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    ),
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