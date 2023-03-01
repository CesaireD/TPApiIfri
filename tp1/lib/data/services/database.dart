import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tp1/data/models/Todo.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "Todoiiii.db";
  //static const Path _path = "/data";

  static Future<Database> _getDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
        onCreate: (db, version) async => await db.execute(
            "CREATE TABLE Todo(id TEXT PRIMARY KEY,title TEXT,description text,userId TEXT, createdAt text, updatedAt text,beginedAt text,deadlinedAt text,finishedAt text);"),
        version: _version);
  }

  static Future<int> addNote(Todo todo) async {
    final db = await _getDB();
    print('------------------------------------\n${todo.id}');
    print(todo.title);
    print(todo.description);
    print(todo.deadlinedAt);
    print(todo.createdAt);
    print(todo.beginedAt);
    print(todo.finishedAt);
    print(todo.updatedAt);
    print(todo.userId);
    if(todo.finishedAt == DateTime(1999)){
      todo.finishedAt = null;
    }
    if(todo.beginedAt == DateTime(1999)){
      todo.beginedAt = null;
    }
    if(todo.deadlinedAt == DateTime(1999)){
      todo.deadlinedAt = null;
    }
    return await db.insert("Todo", todo.toJsonDB(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateNote(Todo todo) async {
    final db = await _getDB();
    print("---------------update-------------------");
    return await db.update("Todo", todo.toJsonDB(),
        where: "id = ?",
        whereArgs: [todo.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteNote(Todo note) async {
    final db = await _getDB();
    return await db.delete(
      "Todo",
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  static Future<int?> nonCommencer() async {
    final db = await _getDB();
    List<Map<String, dynamic>> maps = await db.query('Todo',
      //columns: ['title' ],
      where: "beginedAt == 'null'",
    );
    print("---------------nonCommencer-------------------");
    return await maps.length;
  }

  static Future<int?> enCours() async {
    final db = await _getDB();
    List<Map<String, dynamic>> maps = await db.query('Todo',
      //columns: ['title'],
      where: "finishedAt == 'null' AND beginedAt <> 'null'",
    );
    print("---------------enCours-------------------");
    return await maps.length;
  }

  static Future<int?> finie() async {
    final db = await _getDB();
    List<Map<String, dynamic>> maps = await db.query('Todo',
      //columns: ['id', 'title' ],
      where: "finishedAt <> 'null'",
    );
    print("---------------finie-------------------");
    return await maps.length;
  }

  static Future<int?> finiEnRetard() async {
    final db = await _getDB();
    List<Map<String, dynamic>> maps = await db.query('Todo');
    List? listTodo = List.generate(maps.length, (index) => Todo.fromJsonDB(maps[index]));
    int count = 0;
    listTodo.forEach((element) {
      print('---------------------${element.deadlinedAt}--${element.finishedAt}');
      if(element.deadlinedAt.toString() == "null"){ }else{
        if(element.finishedAt.toString() == "null"){ }else{
          if(DateTime.parse(element.finishedAt.toString()).isAfter(DateTime.parse(element.deadlinedAt.toString()))){count++;}
        }
      }

    });
    print("---------------retart-------------------");
    return count;//await maps.length;
  }


  static Future<List<Todo?>> getAllNotes() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("Todo");

    if (maps.isEmpty) {
      return [];
    }
    print("---------------all-------------------");
    return List.generate(maps.length, (index) => Todo.fromJsonDB(maps[index]));
  }
}