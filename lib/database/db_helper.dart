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
      version: 6,
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS exercicios');
        await db.execute('DROP TABLE IF EXISTS treinos');
        await db.execute('DROP TABLE IF EXISTS frequencias');
        await db.execute('DROP TABLE IF EXISTS professores');
        await db.execute('DROP TABLE IF EXISTS objetivos');
        await db.execute('DROP TABLE IF EXISTS usuarios');
        await db.execute('DROP TABLE IF EXISTS exercicios_modelo');

        await _createDB(db, newVersion);
      },
      onOpen: (db) async {
        await _seed(db); // add dados automaticamente
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

    await db.execute('''
      CREATE TABLE exercicios_modelo (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        objetivo_id INTEGER
      )
    ''');

    // usuário padrão
    await db.insert('usuarios', {
      'nome': 'Admin',
      'email': 'admin@email.com',
      'senha': '123456',
      'peso': '75',
      'altura': '161',
      'idade': '21',
    });
  }

  Future<void> _seed(Database db) async {
    final profs = await db.query('professores');
    if (profs.isEmpty) {
      await db.insert('professores', {'nome': 'Carlos'});
      await db.insert('professores', {'nome': 'Ana'});
    }

    final objs = await db.query('objetivos');
    if (objs.isEmpty) {
      await db.insert('objetivos', {'nome': 'Emagrecimento'});
      await db.insert('objetivos', {'nome': 'Fortalecimento'});
      await db.insert('objetivos', {'nome': 'Hipertrofia'});
    }

    final freqs = await db.query('frequencias');
    if (freqs.isEmpty) {
      await db.insert('frequencias', {'dias_por_semana': 3});
      await db.insert('frequencias', {'dias_por_semana': 4});
      await db.insert('frequencias', {'dias_por_semana': 5});
    }

    final modelos = await db.query('exercicios_modelo');
    if (modelos.isEmpty) {
      // objetivo 1 = Emagrecimento
      await db.insert('exercicios_modelo', {
        'nome': 'Corrida',
        'objetivo_id': 1
      });
      await db.insert('exercicios_modelo', {
        'nome': 'Bike',
        'objetivo_id': 1
      });

      // objetivo 2 = Fortalecimento
      await db.insert('exercicios_modelo', {
        'nome': 'Agachamento Búlgaro',
        'objetivo_id': 2
      });
      await db.insert('exercicios_modelo', {
        'nome': 'Remada Curvada',
        'objetivo_id': 2
      });

      // objetivo 3 = Hipertrofia
      await db.insert('exercicios_modelo', {
        'nome': 'Supino Reto',
        'objetivo_id': 3
      });
      await db.insert('exercicios_modelo', {
        'nome': 'Leg Press',
        'objetivo_id': 3
      });
    }
  }
}