// ignore_for_file: prefer_conditional_assignment

import 'dart:async';

import 'package:sqflite/sqflite.dart';

import '../../models/series_table.dart';

class DatabaseHelperSeries {
  static DatabaseHelperSeries? _databaseHelper;
  DatabaseHelperSeries._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelperSeries() =>
      _databaseHelper ?? DatabaseHelperSeries._instance();

  static Database? _database;

  Future<Database?> get database async {
    if (_database == null) {
      _database = await _initDb();
    }
    return _database;
  }

  static const String _tblSeries = 'series';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/morisseries.db';

    var db = await openDatabase(databasePath, version: 2, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE  $_tblSeries (
        id INTEGER PRIMARY KEY,
        name TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
  }

  Future<int> insertWatchlistSeries(SeriesTable movie) async {
    final db = await database;
    return await db!.insert(_tblSeries, movie.toJson());
  }

  Future<int> removeWatchlistSeries(SeriesTable series) async {
    final db = await database;
    return await db!.delete(
      _tblSeries,
      where: 'id = ?',
      whereArgs: [series.id],
    );
  }

  Future<Map<String, dynamic>?> getSeriesById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblSeries,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistSeries() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(_tblSeries);

    return results;
  }
}
