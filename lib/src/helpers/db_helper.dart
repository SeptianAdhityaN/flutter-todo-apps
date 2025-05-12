import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task_model.dart'; // asumsi TaskModel dipisah di sini

class DBHelper {
  static const String _dbName = 'tasks.db';
  static const String _tableName = 'tasks';

  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id TEXT PRIMARY KEY,  -- Mengubah id menjadi TEXT
            category TEXT NOT NULL,
            title TEXT NOT NULL,
            description TEXT,
            startDate TEXT NOT NULL,
            endDate TEXT NOT NULL,
            isCompleted INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  // INSERT tugas
  static Future<void> insertTask(Map<String, dynamic> task) async {
    final db = await database;
    await db.insert(
      _tableName,
      task,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // GET semua tugas
  static Future<List<TaskModel>> getTasks() async {
    final db = await database;
    final result = await db.query(_tableName);
    return result.map((e) => TaskModel.fromMap(e)).toList();
  }

  // UPDATE tugas berdasarkan ID
  static Future<void> updateTask(String id, Map<String, dynamic> task) async {
    final db = await database;
    await db.update(
      _tableName,
      task,
      where: 'id = ?',
      whereArgs: [id],  // ID sekarang bertipe String
    );
  }

  // DELETE berdasarkan ID
  static Future<void> deleteTask(String id) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE semua tugas
  static Future<void> deleteAllTasks() async {
    final db = await database;
    await db.delete(_tableName);
  }
}