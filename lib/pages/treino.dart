import 'package:flutter/material.dart';
import 'package:projeto_flutter_agrfit/database/treino_dao.dart';
import 'package:projeto_flutter_agrfit/database/exercicio_dao.dart';

class TreinoPage extends StatefulWidget {
  final Map<String, dynamic> user;

  const TreinoPage({super.key, required this.user});

  @override
  State<TreinoPage> createState() => _TreinoPageState();
}

class _TreinoPageState extends State<TreinoPage> {
  final TreinoDAO treinoDAO = TreinoDAO();
  List<Map<String, dynamic>> treinos = [];

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

  Future<void> criarTreinoDialog() async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Novo treino', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await treinoDAO.criarTreino(
                widget.user['id'],
                1,
                1,
                3,
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
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
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
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
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Seu treino de hoje 💪',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 20),

            treinos.isEmpty
                ? const Text(
                    'Nenhum treino encontrado',
                    style: TextStyle(color: Colors.white54),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: treinos.length,
                      itemBuilder: (_, i) {
                        final treino = treinos[i];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ExecucaoTreinoPage(treino: treino),
                                ),
                              );
                            },
                            onLongPress: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.grey[900],
                                builder: (_) => Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      title: const Text('Editar', style: TextStyle(color: Colors.white)),
                                      onTap: () {
                                        Navigator.pop(context);
                                        editarTreino(treino);
                                      },
                                    ),
                                    ListTile(
                                      title: const Text('Excluir', style: TextStyle(color: Colors.red)),
                                      onTap: () {
                                        Navigator.pop(context);
                                        excluirTreino(treino);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: _buildTreinoCard(
                              treino['nome'] ?? 'Treino',
                              'Objetivo ${treino['objetivo_id']} • ${treino['frequencia_id']} dias',
                              Icons.fitness_center,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: criarTreinoDialog,
                child: const Text('Criar treino'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTreinoCard(String titulo, String subtitulo, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.purple),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: const TextStyle(color: Colors.white)),
                Text(subtitulo, style: const TextStyle(color: Colors.white54)),
              ],
            ),
          ),
        ],
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

  final List<String> exerciciosPadrao = [
    'Agachamento Búlgaro',
    'Remada Curvada',
    'Supino Reto',
    'Leg Press',
    'Elevação Lateral',
  ];

  List<Map<String, dynamic>> exercicios = [];

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    final data = await dao.listarExercicios(widget.treino['id']);

    if (!mounted) return;

    setState(() {
      exercicios = data;
    });
  }

  Future<void> toggle(Map ex) async {
    final novo = ex['concluido'] == 1 ? 0 : 1;
    await dao.marcarConcluido(ex['id'], novo);
    carregar();
  }

  double progresso() {
    if (exercicios.isEmpty) return 0;
    final feitos = exercicios.where((e) => e['concluido'] == 1).length;
    return feitos / exercicios.length;
  }

  Future<void> adicionarExercicio() async {
    final selecionado = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.grey[900],
      builder: (_) {
        return ListView(
          children: exerciciosPadrao.map((nome) {
            return ListTile(
              title: Text(nome, style: const TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context, nome),
            );
          }).toList(),
        );
      },
    );

    if (selecionado != null) {
      await dao.inserirExercicio(
        widget.treino['id'],
        selecionado,
        '',
      );
      carregar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.treino['nome'] ?? 'Treino'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: progresso(),
              color: Colors.purple,
              backgroundColor: Colors.grey[800],
            ),

            const SizedBox(height: 20),

            exercicios.isEmpty
                ? const Text('Nenhum exercício', style: TextStyle(color: Colors.white54))
                : Expanded(
                    child: ListView.builder(
                      itemCount: exercicios.length,
                      itemBuilder: (_, i) {
                        final ex = exercicios[i];
                        final feito = ex['concluido'] == 1;

                        return GestureDetector(
                          onTap: () => toggle(ex),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.play_arrow, color: Colors.purple),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    ex['nome'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      decoration: feito ? TextDecoration.lineThrough : null,
                                    ),
                                  ),
                                ),
                                Icon(
                                  feito ? Icons.check_circle : Icons.circle_outlined,
                                  color: feito ? Colors.purple : Colors.white38,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

            ElevatedButton(
              onPressed: adicionarExercicio,
              child: const Text('Adicionar exercício'),
            )
          ],
        ),
      ),
    );
  }
}