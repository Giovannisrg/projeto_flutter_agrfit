import 'package:flutter/material.dart';
import 'package:projeto_flutter_agrfit/database/treino_dao.dart';
import 'package:projeto_flutter_agrfit/database/exercicio_dao.dart';
import 'package:projeto_flutter_agrfit/database/listas_dao.dart';
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
    case 'Push':
      return ['Peito', 'Ombro', 'Tríceps'];
    case 'Pull':
      return ['Costas', 'Bíceps'];
    case 'Legs':
      return ['Pernas', 'Glúteos'];
    case 'Upper':
      return ['Peito', 'Costas', 'Ombro'];
    case 'Lower':
      return ['Pernas', 'Glúteos'];
    default:
      return [tipo];
  }
}

String traduzirGrupo(String grupo) {
  switch (grupo) {
    case 'Push':
      return 'Peito/Tríceps';
    case 'Pull':
      return 'Costas/Bíceps';
    case 'Legs':
      return 'Pernas';
    case 'Upper':
      return 'Superior';
    case 'Lower':
      return 'Inferior';
    default:
      return grupo;
  }
}

  @override
  void initState() {
    super.initState();
    carregarTreinos();
  }

  Future<void> carregarTreinos() async {
    final data = await treinoDAO.listarTreinos(widget.user['id']);

    if (!mounted) return;

    setState(() {
      treinos = data;
    });
  }

  Future<void> criarTreinoWizard() async {
    final listas = ListasDAO();

    final professores = await listas.professores();
    final objetivos = await listas.objetivos();
    final frequencias = await listas.frequencias();

    int? professorId;
    int? objetivoId;
    int? frequenciaId;

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (_, setState) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            title: const Text('Montar treino', style: TextStyle(color: Colors.white)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<int>(
                  hint: const Text('Professor', style: TextStyle(color: Colors.white)),
                  value: professorId,
                  dropdownColor: Colors.grey[900],
                  items: professores.map((p) {
                    return DropdownMenuItem<int>(
                      value: p['id'] as int,
                      child: Text(p['nome'], style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (v) => setState(() => professorId = v),
                ),
                DropdownButton<int>(
                  hint: const Text('Objetivo', style: TextStyle(color: Colors.white)),
                  value: objetivoId,
                  dropdownColor: Colors.grey[900],
                  items: objetivos.map((o) {
                    return DropdownMenuItem<int>(
                      value: o['id'] as int,
                      child: Text(o['nome'], style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (v) => setState(() => objetivoId = v),
                ),
                DropdownButton<int>(
                  hint: const Text('Dias/semana', style: TextStyle(color: Colors.white)),
                  value: frequenciaId,
                  dropdownColor: Colors.grey[900],
                  items: frequencias.map((f) {
                    return DropdownMenuItem<int>(
                      value: f['id'] as int,
                      child: Text('${f['dias_por_semana']} dias',
                          style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (v) => setState(() => frequenciaId = v),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  if (objetivoId == null || professorId == null || frequenciaId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Preencha todos os campos')),
                    );
                    return;
                  }

                  final freq = frequencias.firstWhere((f) => f['id'] == frequenciaId);
                  final dias = freq['dias_por_semana'];

                  final divisao = {
                    3: ['Push', 'Pull', 'Legs'],
                    4: ['Upper', 'Lower', 'Push', 'Pull'],
                    5: ['Peito', 'Costas', 'Pernas', 'Ombro', 'Braço'],
                  };

                  final grupos = divisao[dias] ?? ['Peito', 'Costas', 'Pernas'];

                  final modelos = await listas.exerciciosPorObjetivo(objetivoId!);

                  for (var grupo in grupos) {
                    final treinoId = await treinoDAO.criarTreino(
                      widget.user['id'],
                      objetivoId!,
                      professorId!,
                      frequenciaId!,
                      'Treino: ${traduzirGrupo(grupo)}',
                    );

                    final gruposMusculares = mapearGrupo(grupo);

                    final filtrados = modelos.where((e) {
                      final grupoDB = (e['grupo_muscular'] ?? '').toString().toLowerCase();

                      return gruposMusculares
                          .map((g) => g.toLowerCase())
                          .contains(grupoDB);
                    }).toList();
                    
                    if (filtrados.isEmpty) continue;

                    filtrados.shuffle();

                    for (var m in filtrados.take(4)) {
                      await ExercicioDAO().inserirExercicio(
                        treinoId,
                        m['nome'],
                        '',
                        m['series'],
                        m['reps'],
                      );
                    }
                  }

                  if (!mounted) return;

                  Navigator.pop(context);
                  carregarTreinos();
                },
                child: const Text('Criar'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> editarTreino(Map treino) async {
    final controller = TextEditingController(text: treino['nome']);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Editar treino', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              await treinoDAO.atualizarTreino(
                treino['id'],
                controller.text,
              );

              if (!mounted) return;

              Navigator.pop(context);
              carregarTreinos();
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Future<void> excluirTreino(Map treino) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Excluir treino', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Tem certeza que deseja excluir esse treino?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir', style: TextStyle(color: Color.fromARGB(146, 32, 30, 30))),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await treinoDAO.deletarTreino(treino['id']);

      if (!mounted) return;

      carregarTreinos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Treino', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Seus treinos 💪', style: TextStyle(color: Colors.white, fontSize: 20)),
            const SizedBox(height: 20),

            treinos.isEmpty
                ? const Text('Nenhum treino', style: TextStyle(color: Colors.white54))
                : Expanded(
                    child: ListView.builder(
                      itemCount: treinos.length,
                      itemBuilder: (_, i) {
                        final treino = treinos[i];

                        return GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ExecucaoTreinoPage(treino: treino),
                              ),
                            );

                            if (result == true) carregarTreinos();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: treino['finalizado'] == 1
                                  ? Colors.green
                                  : Colors.grey[900],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    treino['finalizado'] == 1
                                        ? '${treino['nome']}'
                                        : treino['nome'],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.white70),
                                  onPressed: () async {
                                    final confirmar = await showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text('Excluir treino?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            child: const Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            child: const Text('Excluir'),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirmar == true) {
                                      await treinoDAO.deletarTreino(treino['id']);
                                      carregarTreinos();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: criarTreinoWizard,
                child: const Text('Criar treino'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ExecucaoTreinoPage extends StatefulWidget {
  final Map treino;

  const ExecucaoTreinoPage({super.key, required this.treino});

  @override
  State<ExecucaoTreinoPage> createState() => _ExecucaoTreinoPageState();
}

class _ExecucaoTreinoPageState extends State<ExecucaoTreinoPage> {
  final ExercicioDAO dao = ExercicioDAO();

  List<Map<String, dynamic>> exercicios = [];

  int segundos = 0;
  Timer? timer;
  bool iniciado = false;

  int descanso = 0;
  Timer? descansoTimer;
  bool descansando = false;

  @override
  void initState() {
    super.initState();
    carregar();
  }

  @override
  void dispose() {
    timer?.cancel();
    descansoTimer?.cancel();
    super.dispose();
  }

  Future<void> carregar() async {
    final data = await dao.listarExercicios(widget.treino['id']);

    if (!mounted) return;

    setState(() {
      exercicios = data;
    });
  }

  void iniciarTreino() {
    setState(() => iniciado = true);

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => segundos++);
    });
  }

  void iniciarDescanso() {
    setState(() {
      descansando = true;
      descanso = 60;
    });

    descansoTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (descanso == 0) {
        t.cancel();
        setState(() => descansando = false);
      } else {
        setState(() => descanso--);
      }
    });
  }

  void finalizarTreino() async {
  timer?.cancel();

  await TreinoDAO().marcarFinalizado(widget.treino['id']);

  if (!mounted) return;

  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: Colors.grey[900],
      title: const Text('Treino finalizado',
          style: TextStyle(color: Colors.white)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // fecha popup
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );

  if (!mounted) return;

  Navigator.pop(context, true); // volta pra lista
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.treino['nome']),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Text(
            '${(segundos ~/ 60).toString().padLeft(2, '0')}:${(segundos % 60).toString().padLeft(2, '0')}',
            style: const TextStyle(color: Colors.white, fontSize: 30),
          ),

          if (descansando)
            Text(
              'Descanso: $descanso s',
              style: const TextStyle(color: Colors.white),
            ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: iniciado ? iniciarDescanso : null,
              child: const Text('Descansar'),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: ListView.builder(
              itemCount: exercicios.length,
              itemBuilder: (_, i) {
                final ex = exercicios[i];
                final feito = ex['concluido'] == 1;

                return ListTile(
                  title: Text(
                    '${ex['nome']} - ${ex['series'] ?? ''}x${ex['reps'] ?? ''}',
                    style: TextStyle(
                      color: Colors.white,
                      decoration:
                          feito ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  trailing: Icon(
                    feito ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: feito ? Colors.green : Colors.purple,
                  ),
                  onTap: () async {
                    await dao.marcarConcluido(ex['id'], feito ? 0 : 1);
                    carregar();
                  },
                );
              },
            ),
          ),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: iniciado ? finalizarTreino : iniciarTreino,
              child: Text(iniciado ? 'Finalizar' : 'Iniciar'),
            ),
          ),
        ],
      ),
    );
  }
}