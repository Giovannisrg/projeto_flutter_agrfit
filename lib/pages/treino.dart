import 'package:flutter/material.dart';
import 'package:projeto_flutter_agrfit/database/treino_dao.dart';
import 'package:projeto_flutter_agrfit/database/exercicio_dao.dart';
import 'package:projeto_flutter_agrfit/database/listas_dao.dart';
import 'package:projeto_flutter_agrfit/pages/chatbot.dart';
import '../services/auth_service.dart';
import 'dart:async';

class TreinoPage extends StatefulWidget {
  final Map<String, dynamic> user;

  const TreinoPage({super.key, required this.user});

  @override
  State<TreinoPage> createState() => _TreinoPageState();
}

class _TreinoPageState extends State<TreinoPage> {
  final TreinoDAO treinoDAO = TreinoDAO();
  List<Map<String, dynamic>> treinos = [];

  List<String> mapearGrupo(String tipo) {
    switch (tipo) {
      case 'Push':  return ['Peito', 'Ombro', 'Tríceps'];
      case 'Pull':  return ['Costas', 'Bíceps'];
      case 'Legs':  return ['Pernas', 'Glúteos'];
      case 'Upper': return ['Peito', 'Costas', 'Ombro'];
      case 'Lower': return ['Pernas', 'Glúteos'];
      default:      return [tipo];
    }
  }

  String traduzirGrupo(String grupo) {
    switch (grupo) {
      case 'Push':  return 'Peito/Tríceps';
      case 'Pull':  return 'Costas/Bíceps';
      case 'Legs':  return 'Pernas';
      case 'Upper': return 'Superior';
      case 'Lower': return 'Inferior';
      default:      return grupo;
    }
  }

  @override
  void initState() {
    super.initState();
    carregarTreinos();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    carregarTreinos();
  }

  Future<void> carregarTreinos() async {
    try {
      final usuarioAtual = await AuthService.getUser();
      if (usuarioAtual == null) return;
      final data = await treinoDAO.listarTreinos(usuarioAtual['id']);
      if (!mounted) return;
      setState(() {
        treinos = [
          ...data.where((t) => t['finalizado'] == 0),
          ...data.where((t) => t['finalizado'] == 1),
        ];
      });
    } catch (e) {
      debugPrint('Erro ao carregar treinos: $e');
    }
  }

  Future<void> criarTreinoWizard() async {
    final listas      = ListasDAO();
    final professores = await listas.professores();
    final objetivos   = await listas.objetivos();
    final frequencias = await listas.frequencias();

    int? professorId, objetivoId, frequenciaId;

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (_, setState) {
          final cs = Theme.of(context).colorScheme;

          return AlertDialog(
            backgroundColor: Theme.of(context).cardColor,
            title: Text('Montar treino', style: TextStyle(color: cs.onSurface)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dropdown(cs, 'Professor', professorId, professores,
                    (v) => setState(() => professorId = v)),
                _dropdown(cs, 'Objetivo', objetivoId, objetivos,
                    (v) => setState(() => objetivoId = v)),
                DropdownButton<int>(
                  hint: Text('Dias/semana', style: TextStyle(color: cs.onSurface)),
                  value: frequenciaId,
                  dropdownColor: Theme.of(context).cardColor,
                  items: frequencias.map((f) => DropdownMenuItem<int>(
                    value: f['id'] as int,
                    child: Text('${f['dias_por_semana']} dias',
                        style: TextStyle(color: cs.onSurface)),
                  )).toList(),
                  onChanged: (v) => setState(() => frequenciaId = v),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancelar', style: TextStyle(color: cs.primary)),
              ),
              TextButton(
                onPressed: () async {
                  if (objetivoId == null || professorId == null || frequenciaId == null) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Preencha todos os campos')),
                    );
                    return;
                  }

                  final freq   = frequencias.firstWhere((f) => f['id'] == frequenciaId);
                  final dias   = freq['dias_por_semana'];
                  final grupos = _gerarDivisao(dias);
                  final letras = ['A', 'B', 'C', 'D', 'E'];
                  final modelos = await listas.exerciciosPorObjetivo(objetivoId!);

                  for (int i = 0; i < grupos.length; i++) {
                    final grupo    = grupos[i];
                    final letra    = letras[i];
                    final treinoId = await treinoDAO.criarTreino(
                      widget.user['id'], objetivoId!, professorId!, frequenciaId!,
                      'Treino $letra: ${traduzirGrupo(grupo)}',
                    );

                    final gruposMusculares = mapearGrupo(grupo);
                    final filtrados = modelos.where((e) {
                      final grupoDB = (e['grupo_muscular'] ?? '').toString().toLowerCase();
                      return gruposMusculares.map((g) => g.toLowerCase()).contains(grupoDB);
                    }).toList()..shuffle();

                    final usados     = <String>{};
                    final selecionados = filtrados.where((e) {
                      if (usados.contains(e['nome'])) return false;
                      usados.add(e['nome']);
                      return true;
                    }).take(4).toList();

                    for (var m in selecionados) {
                      await ExercicioDAO().inserirExercicio(
                          treinoId, m['nome'], '', m['series'], m['reps']);
                    }
                  }

                  if (!mounted) return;
                  Navigator.pop(context);
                  await carregarTreinos();
                },
                child: const Text('Criar'),
              ),
            ],
          );
        },
      ),
    );
  }

  List<String> _gerarDivisao(int dias) {
    if (dias == 3) return ['Push', 'Pull', 'Legs'];
    if (dias == 4) return ['Upper', 'Lower', 'Upper', 'Lower'];
    if (dias == 5) return ['Push', 'Pull', 'Legs', 'Upper', 'Lower'];
    return ['Full'];
  }

  DropdownButton<int> _dropdown(
    ColorScheme cs,
    String hint,
    int? value,
    List<Map<String, dynamic>> items,
    ValueChanged<int?> onChanged,
  ) {
    return DropdownButton<int>(
      hint: Text(hint, style: TextStyle(color: cs.onSurface)),
      value: value,
      dropdownColor: cs.surface,
      items: items.map((p) => DropdownMenuItem<int>(
        value: p['id'] as int,
        child: Text(p['nome'], style: TextStyle(color: cs.onSurface)),
      )).toList(),
      onChanged: onChanged,
    );
  }

  Future<void> excluirTreino(Map treino) async {
    if (!mounted) return;
    final cs = Theme.of(context).colorScheme;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text('Excluir treino', style: TextStyle(color: cs.onSurface)),
        content: Text('Tem certeza que deseja excluir esse treino?',
            style: TextStyle(color: cs.onSurface.withValues(alpha: 0.7))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Excluir',
                style: TextStyle(color: cs.primary, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      try {
        await treinoDAO.deletarTreino(treino['id']);
        if (!mounted) return;
        await carregarTreinos();
      } catch (e) {
        debugPrint('Erro ao excluir treino: $e');
        if (!mounted) return;
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          const SnackBar(content: Text('Erro ao excluir treino')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Treino')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Seus treinos 💪',
                style: TextStyle(color: cs.onSurface, fontSize: 20)),
            const SizedBox(height: 20),

            treinos.isEmpty
                ? Text('Nenhum treino',
                    style: TextStyle(color: cs.onSurface.withValues(alpha: 0.4)))
                : Expanded(
                    child: ListView.builder(
                      itemCount: treinos.length,
                      itemBuilder: (_, i) {
                        final treino     = treinos[i];
                        final finalizado = treino['finalizado'] == 1;

                        return GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ExecucaoTreinoPage(treino: treino),
                              ),
                            );
                            if (!mounted) return;
                            if (result == true) carregarTreinos();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: finalizado ? Colors.green : cs.surface,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(treino['nome'],
                                          style: TextStyle(
                                              color: finalizado ? Colors.white : cs.onSurface,
                                              fontSize: 16)),
                                      const SizedBox(height: 4),
                                      Text('Professor: ${treino['professor_nome'] ?? '---'}',
                                          style: TextStyle(
                                              color: finalizado
                                                  ? Colors.white70
                                                  : cs.onSurface.withValues(alpha: 0.6),
                                              fontSize: 12)),
                                      Text('Objetivo: ${treino['objetivo_nome'] ?? '---'}',
                                          style: TextStyle(
                                              color: finalizado
                                                  ? Colors.white70
                                                  : cs.onSurface.withValues(alpha: 0.6),
                                              fontSize: 12)),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: cs.primary),
                                  onPressed: () async => excluirTreino(treino),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

            // ── Botão Criar treino — usa cor primária do tema ───────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  minimumSize: const Size(0, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: criarTreinoWizard,
                child: const Text('Criar treino',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EXECUÇÃO DO TREINO
// ─────────────────────────────────────────────────────────────────────────────
class ExecucaoTreinoPage extends StatefulWidget {
  final Map treino;

  const ExecucaoTreinoPage({super.key, required this.treino});

  @override
  State<ExecucaoTreinoPage> createState() => _ExecucaoTreinoPageState();
}

class _ExecucaoTreinoPageState extends State<ExecucaoTreinoPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final ExercicioDAO dao = ExercicioDAO();

  List<Map<String, dynamic>> exercicios = [];

  int      segundos = 0;
  Timer?   timer;
  bool     iniciado = false;
  DateTime? inicioTreino;

  int      descanso = 0;
  Timer?   descansoTimer;
  DateTime? inicioDescanso;
  bool     descansando = false;

  late AnimationController controller;
  late Animation<double>   anim;

  String formatarTempo(int s) {
    final m   = (s ~/ 60).toString().padLeft(2, '0');
    final sec = (s % 60).toString().padLeft(2, '0');
    return '$m:$sec';
  }

  // ── Botão que segue a paleta de cores do tema ─────────────────────────────
  ButtonStyle _botaoEstilo(ColorScheme cs) => ElevatedButton.styleFrom(
    backgroundColor: cs.primary,
    foregroundColor: Colors.white,
    elevation: 0,
    padding: const EdgeInsets.symmetric(vertical: 12),
    minimumSize: const Size(0, 45),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
  );

  // ── Botão desabilitado (quando treino não iniciado) ───────────────────────
  ButtonStyle _botaoDesabilitado(ColorScheme cs) => ElevatedButton.styleFrom(
    backgroundColor: cs.primary.withValues(alpha: 0.3),
    foregroundColor: Colors.white.withValues(alpha: 0.5),
    elevation: 0,
    padding: const EdgeInsets.symmetric(vertical: 12),
    minimumSize: const Size(0, 45),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 250),
    );
    anim = Tween(begin: 0.8, end: 1.0).animate(controller);
    controller.forward();
    carregar();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    timer?.cancel();
    descansoTimer?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && inicioTreino != null) {
      setState(() => segundos = DateTime.now().difference(inicioTreino!).inSeconds);
    }
  }

  Future<void> carregar() async {
    final data = await dao.listarExercicios(widget.treino['id']);
    if (!mounted) return;
    setState(() => exercicios = data);
  }

  void iniciarTreino() {
    if (timer != null && timer!.isActive) return;
    inicioTreino ??= DateTime.now();
    setState(() => iniciado = true);
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || inicioTreino == null) return;
      setState(() => segundos = DateTime.now().difference(inicioTreino!).inSeconds);
      controller.forward(from: 0.8);
    });
  }

  void iniciarDescanso() {
    inicioDescanso = DateTime.now();
    setState(() { descansando = true; descanso = 60; });
    descansoTimer?.cancel();
    descansoTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted || inicioDescanso == null) return;
      final restante = 60 - DateTime.now().difference(inicioDescanso!).inSeconds;
      if (restante <= 0) {
        t.cancel();
        setState(() { descansando = false; descanso = 0; });
      } else {
        setState(() => descanso = restante);
      }
    });
  }

  void finalizarTreino() async {
    timer?.cancel();
    descansoTimer?.cancel();
    setState(() {
      iniciado    = false;
      descansando = false;
      inicioTreino = null;
      segundos    = 0;
    });

    await TreinoDAO().marcarFinalizado(widget.treino['id']);
    if (!mounted) return;

    final cs = Theme.of(context).colorScheme;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text('Treino finalizado 🎉', style: TextStyle(color: cs.onSurface)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(widget.treino['nome'])),
      body: Column(
        children: [
          ScaleTransition(
            scale: anim,
            child: Text(
              formatarTempo(segundos),
              style: TextStyle(
                color: cs.onSurface,
                fontSize: 40,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),

          if (descansando)
            Text('Descanso: $descanso s',
                style: TextStyle(color: cs.onSurface)),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: iniciado ? _botaoEstilo(cs) : _botaoDesabilitado(cs),
              onPressed: iniciado ? iniciarDescanso : null,
              child: const Text('Descansar'),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: ListView.builder(
              itemCount: exercicios.length,
              itemBuilder: (_, i) {
                final ex    = exercicios[i];
                final feito = ex['concluido'] == 1;

                return ListTile(
                  title: Text(
                    '${ex['nome']} - ${ex['series'] ?? ''}x${ex['reps'] ?? ''}',
                    style: TextStyle(
                      color: cs.onSurface,
                      decoration: feito ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.play_circle_outline, color: cs.primary),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatbotPage(
                                perguntaInicial:
                                    'Adrianna, como eu executo ${ex['nome']}?',
                              ),
                            ),
                          );
                        },
                      ),
                      Icon(
                        feito ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: feito ? Colors.green : cs.primary,
                      ),
                    ],
                  ),
                  onTap: () async {
                    await dao.marcarConcluido(ex['id'], feito ? 0 : 1);
                    if (!mounted) return;
                    carregar();
                  },
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: _botaoEstilo(cs),
                onPressed: iniciado ? finalizarTreino : iniciarTreino,
                child: Text(iniciado ? 'Finalizar' : 'Iniciar'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}