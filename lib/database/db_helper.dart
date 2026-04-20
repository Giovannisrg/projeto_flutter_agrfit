import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('agrfit.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 5,
      onCreate: _createDB,

      // 🔥 CORREÇÃO AQUI
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS exercicios');
        await db.execute('DROP TABLE IF EXISTS treinos');
        await db.execute('DROP TABLE IF EXISTS frequencias');
        await db.execute('DROP TABLE IF EXISTS professores');
        await db.execute('DROP TABLE IF EXISTS objetivos');
        await db.execute('DROP TABLE IF EXISTS usuarios');

        await _createDB(db, newVersion);
      },
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        senha TEXT NOT NULL,
        peso TEXT,
        altura TEXT,
        idade TEXT,
        data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
        data_expiracao DATETIME
      )
    ''');

    await db.execute('''
      CREATE TABLE objetivos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE professores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE frequencias (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dias_por_semana INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE treinos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario_id INTEGER,
        objetivo_id INTEGER,
        professor_id INTEGER,
        frequencia_id INTEGER,
        nome TEXT,
        data_inicio DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE exercicios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        treino_id INTEGER,
        nome TEXT NOT NULL,
        video_url TEXT,
        concluido INTEGER DEFAULT 0,
        FOREIGN KEY (treino_id) REFERENCES treinos(id)
      )
    ''');

    await db.insert('usuarios', {
      'nome': 'Admin',
      'email': 'admin@email.com',
      'senha': '123456',
      'peso': '75',
      'altura': '161',
      'idade': '21',
    });
  }
}