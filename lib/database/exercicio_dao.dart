import 'db_helper.dart';

class ExercicioDAO {
  Future<int> inserirExercicio(
    int treinoId,
    String nome,
    String videoUrl,
    int series,
    int reps,
  ) async {
    final db = await DBHelper.instance.database;

    return await db.insert('exercicios', {
      'treino_id': treinoId,
      'nome': nome,
      'video_url': videoUrl,
      'concluido': 0,
      'series': series,
      'reps': reps,
    });
  }

  Future<List<Map<String, dynamic>>> listarExercicios(int treinoId) async {
    final db = await DBHelper.instance.database;

    return await db.query(
      'exercicios',
      where: 'treino_id = ?',
      whereArgs: [treinoId],
    );
  }

  Future<void> marcarConcluido(int id, int status) async {
    final db = await DBHelper.instance.database;

    await db.update(
      'exercicios',
      {'concluido': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deletarExercicio(int id) async {
    final db = await DBHelper.instance.database;

    await db.delete(
      'exercicios',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}