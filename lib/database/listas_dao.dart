import 'db_helper.dart';

class ListasDAO {
  Future<List<Map>> professores() async {
    final db = await DBHelper.instance.database;
    return db.query('professores');
  }

  Future<List<Map>> objetivos() async {
    final db = await DBHelper.instance.database;
    return db.query('objetivos');
  }

  Future<List<Map>> frequencias() async {
    final db = await DBHelper.instance.database;
    return db.query('frequencias');
  }

  Future<List<Map>> exerciciosPorObjetivo(int objetivoId) async {
    final db = await DBHelper.instance.database;
    return db.query(
      'exercicios_modelo',
      where: 'objetivo_id = ?',
      whereArgs: [objetivoId],
    );
  }
}