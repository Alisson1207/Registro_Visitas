import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/visit_model.dart';

class VisitsDB {
  static final VisitsDB _instance = VisitsDB._internal();
  factory VisitsDB() => _instance;
  VisitsDB._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    try {
      final path = join(await getDatabasesPath(), 'visits.db');
      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE visits(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              code TEXT,
              technician TEXT,
              role TEXT,
              latitude REAL,
              longitude REAL,
              date TEXT
            )
          ''');
        },
      );
    } catch (e) {
      throw Exception('Error inicializando base de datos: $e');
    }
  }

  Future<void> insertVisit(VisitModel visit) async {
    try {
      final db = await database;
      await db.insert('visits', visit.toMap());
    } catch (e) {
      throw Exception('Error insertando visita: $e');
    }
  }

  Future<List<VisitModel>> getVisits({String? technician, String? role}) async {
    try {
      final db = await database;
      String where = '';
      List<String> args = [];

      if (technician != null) {
        where += 'technician = ?';
        args.add(technician);
      }
      if (role == 'supervisor') {
        where = '';
        args = [];
      }

      final maps = await db.query(
        'visits',
        where: where.isNotEmpty ? where : null,
        whereArgs: args.isNotEmpty ? args : null,
      );

      return maps.map((e) => VisitModel.fromMap(e)).toList();
    } catch (e) {
      throw Exception('Error obteniendo visitas: $e');
    }
  }

  Future<void> deleteVisit(int id) async {
    try {
      final db = await database;
      await db.delete('visits', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw Exception('Error eliminando visita: $e');
    }
  }

  Future<void> clearAllVisits() async {
    try {
      final db = await database;
      await db.delete('visits');
    } catch (e) {
      throw Exception('Error eliminando todas las visitas: $e');
    }
  }
}
