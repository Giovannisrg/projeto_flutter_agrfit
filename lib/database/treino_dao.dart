import 'package:projeto_flutter_agrfit/database/db_helper.dart';

class TreinoDAO {
  Future<int> criarTreino(
    int usuarioId,
    int objetivoId,
    int professorId,
    int frequenciaId,
    String nome,
  ) async {
    final db = await DBHelper.instance.database;

    return await db.insert(
      'treinos',
      {
        'usuario_id': usuarioId,
        'objetivo_id': objetivoId,
        'professor_id': professorId,
        'frequencia_id': frequenciaId,
        'nome': nome,
        'finalizado': 0,
      },
    );
  }

  Future<List<Map<String, dynamic>>> listarTreinos(int usuarioId) async {
    final db = await DBHelper.instance.database;

    return await db.query(
      'treinos',
      where: 'usuario_id = ?',
      whereArgs: [usuarioId],
      orderBy: 'id ASC',
    );
  }

  Future<int> atualizarTreino(int id, String nome) async {
    final db = await DBHelper.instance.database;

    return await db.update(
      'treinos',
      {'nome': nome},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deletarTreino(int id) async {
    final db = await DBHelper.instance.database;

    await db.delete(
      'exercicios',
      where: 'treino_id = ?',
      whereArgs: [id],
    );

    return await db.delete(
      'treinos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> marcarFinalizado(int id) async {
    final db = await DBHelper.instance.database;

    await db.update(
      'treinos',
      {'finalizado': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Map<String, dynamic>?> buscarTreinoPorId(int id) async {
    final db = await DBHelper.instance.database;

    final result = await db.query(
      'treinos',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }
}