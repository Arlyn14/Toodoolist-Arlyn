import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  Task(
      {required this.id,
      required this.title,
      required this.subtitle,
      required this.createdAtTime,
      required this.createdAtDate,
      required this.isCompleted});

  /// ID
  @HiveField(0)
  final String id;

  /// TITLE
  @HiveField(1)
  String title;

  /// SUBTITLE
  @HiveField(2)
  String subtitle;

  /// CREATED AT TIME
  @HiveField(3)
  DateTime createdAtTime;

  /// CREATED AT DATE
  @HiveField(4)
  DateTime createdAtDate;

  /// IS COMPLETED
  @HiveField(5)
  bool isCompleted;

  /// create new Task
  factory Task.create({
    required String? title,
    required String? subtitle,
    DateTime? createdAtTime,
    DateTime? createdAtDate,
  }) =>
      Task(
        id: const Uuid().v1(),
        title: title ?? "",
        subtitle: subtitle ?? "",
        createdAtTime: createdAtTime ?? DateTime.now(),
        isCompleted: false,
        createdAtDate: createdAtDate ?? DateTime.now(),
      );

  // Untuk Firestore
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'createdAtTime': createdAtTime.toIso8601String(),
        'createdAtDate': createdAtDate.toIso8601String(),
        'isCompleted': isCompleted,
      };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
        id: map['id'] ?? '',
        title: map['title'] ?? '',
        subtitle: map['subtitle'] ?? '',
        createdAtTime: DateTime.parse(map['createdAtTime']),
        createdAtDate: DateTime.parse(map['createdAtDate']),
        isCompleted: map['isCompleted'] ?? false,
      );
}
