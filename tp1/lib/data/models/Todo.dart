// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:tp1/utils/constants.dart';
import 'user.dart';
import 'package:intl/intl.dart';

List<Todo> postFromJson(String str) => List<Todo>.from(json.decode(str).map((x) => Todo.fromJson(x)));

class Todo {
  Todo({
    required this.id,
    required this.description,
    required this.title,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.deadlinedAt,
    this.beginedAt,
    this.finishedAt
  });

  String id;
  String description;
  String title;
  String userId;
  DateTime createdAt;
  DateTime? beginedAt;
  DateTime? deadlinedAt;
  DateTime updatedAt;
  DateTime? finishedAt;

  Map<String,dynamic> toJson() => {
    'id' : id,
    'title' : title,
    'userId' : userId,
    'description' : description,
    'createdAt' : Constant.dateFormat.format(createdAt),
    'beginedAt' : beginedAt == null ? null : Constant.dateFormat.format(beginedAt!),
    'deadlinedAt' : Constant.dateFormat.format(deadlinedAt!),
    'updatedAt' : Constant.dateFormat.format(updatedAt),
    'finishedAt' : finishedAt == null ? null : Constant.dateFormat.format(finishedAt!),
  };

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    id: json["id"] == null ? null : json["id"],
    description: json["description"] == null ? null : json["description"],
    title: json["title"] == null ? null : json["title"],
    userId: json["user_id"] == null ? null : json["user_id"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    beginedAt: json["begined_at"] == null ? null : DateTime.parse(json["begined_at"]),
    finishedAt: json["finished_at"] == null ? null : DateTime.parse(json["finished_at"]),
    deadlinedAt: json["deadlined_at"],
  );

  Map<String,dynamic> toJsonDB() => {
    'id' : id,
    'title' : title,
    'userId' : userId,
    'description' : description,
    'createdAt' : createdAt.toString(),
    'beginedAt' : beginedAt.toString(),
    'deadlinedAt' : deadlinedAt.toString(),
    'updatedAt' : updatedAt.toString(),
    'finishedAt' : finishedAt.toString(),
  };

  factory Todo.fromJsonDB(Map<String, dynamic> json) => Todo(
    id: json["id"],
    description: json["description"],
    title: json["title"],
    userId: json["userId"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    beginedAt: json["beginedAt"] == "null" ? null : DateTime.parse(json["beginedAt"]),
    finishedAt: json["finishedAt"] == "null" ? null : DateTime.parse(json["finishedAt"]),
    deadlinedAt: json["deadlinedAt"] == "null" ? null : DateTime.parse(json["deadlinedAt"]),
  );

}
