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

  Future<String> criarUsuario(String nome, String email, String senha) async {
    final db = await DBHelper.instance.database;

    final existing = await db.query(
      'usuarios',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (existing.isNotEmpty) {
      return 'email_existente';
    }

    await db.insert('usuarios', {'nome': nome, 'email': email, 'senha': senha});

    return 'sucesso';
  }

  Future<int> atualizarUsuario(
    int id,
    String nome,
    String email,
    String peso,
    String altura,
    String idade,
  ) async {
    final db = await DBHelper.instance.database;

    return await db.update(
      'usuarios',
      {
        'nome': nome,
        'email': email,
        'peso': peso,
        'altura': altura,
        'idade': idade,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
