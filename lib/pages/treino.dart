import 'package:flutter/material.dart';
import 'package:projeto_flutter_agrfit/database/treino_dao.dart';

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
                                      onTap: () async {
                                        await treinoDAO.deletarTreino(treino['id']);
                                        Navigator.pop(context);
                                        carregarTreinos();
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Treino iniciado 💪')),
                  );
                },
                child: const Text(
                  'Iniciar treino',
                  style: TextStyle(color: Colors.white),
                ),
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

class ExecucaoTreinoPage extends StatelessWidget {
  final Map treino;

  const ExecucaoTreinoPage({super.key, required this.treino});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          treino['nome'] ?? 'Treino',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: const Center(
        child: Text(
          'Execução do treino',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}