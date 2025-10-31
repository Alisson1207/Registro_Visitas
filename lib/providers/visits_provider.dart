import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../data/models/visit_model.dart';
import 'package:fluttertoast/fluttertoast.dart';


class VisitsProvider extends ChangeNotifier {
  Database? _db;
  List<VisitModel> _visits = [];

  List<VisitModel> get visits => _visits;

  Future<void> init() async {
    try {
      final dbPath = await getDatabasesPath();
      _db = await openDatabase(
        join(dbPath, 'visits.db'),
        onCreate: (db, version) async {
          await db.execute(
            'CREATE TABLE visits(id INTEGER PRIMARY KEY AUTOINCREMENT, code TEXT, role TEXT, latitude REAL, longitude REAL, date TEXT)',
          );
        },
        version: 1,
      );
      await fetchVisits();
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error al inicializar la base de datos: $e',
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
    }
  }

  Future<void> addVisit(VisitModel visit) async {
    try {
      await _db!.insert('visits', visit.toMap());
      await fetchVisits();
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error al agregar visita: $e',
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
    }
  }

  Future<void> fetchVisits() async {
    try {
      final List<Map<String, dynamic>> maps = await _db!.query('visits');
      _visits = List.generate(maps.length, (i) => VisitModel.fromMap(maps[i]));
      notifyListeners();
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error al obtener visitas: $e',
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
    }
  }

  List<VisitModel> visitsByRole(String role, String technician) {
    try {
      if (role == 'supervisor') return _visits;
      return _visits.where((v) => v.role == 'tecnico').toList();
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error filtrando visitas por rol: $e',
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
      return [];
    }
  }

  Future<void> deleteVisit(int id) async {
    try {
      await _db!.delete('visits', where: 'id = ?', whereArgs: [id]);
      await fetchVisits();
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error al eliminar visita: $e',
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
    }
  }
}
