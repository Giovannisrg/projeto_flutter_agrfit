import 'package:sqflite/sqflite.dart';
import 'db_helper.dart';

class UserDAO {
  Future<Map<String, dynamic>?> login(String email, String senha) async {
    final db = await DBHelper.instance.database;

    final result = await db.query(
      'usuarios',
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }
}
