import 'db_helper.dart';

class ListasDAO {
  Future<List<Map<String, dynamic>>> professores() async {
    final db = await DBHelper.instance.database;
    return await db.query('professores');
  }

  Future<List<Map<String, dynamic>>> objetivos() async {
    final db = await DBHelper.instance.database;
    return await db.query('objetivos');
  }

  Future<List<Map<String, dynamic>>> frequencias() async {
    final db = await DBHelper.instance.database;
    return await db.query('frequencias');
  }

  Future<List<Map<String, dynamic>>> exerciciosPorObjetivo(int objetivoId) async {
    final db = await DBHelper.instance.database;
    return await db.query(
      'exercicios_modelo',
      where: 'objetivo_id = ?',
      whereArgs: [objetivoId],
    );
  }

  Future<List<Map<String, dynamic>>> exerciciosPorGrupo(int objetivoId, String grupo) async {
    final db = await DBHelper.instance.database;
    return await db.query(
      'exercicios_modelo',
      where: 'objetivo_id = ? AND grupo_muscular = ?',
      whereArgs: [objetivoId, grupo],
    );
  }
}