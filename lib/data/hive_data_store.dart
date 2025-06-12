import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

///
import '../models/task.dart';

class HiveDataStore {
  static const boxName = "tasksBox";
  final Box<Task> box = Hive.box<Task>(boxName);

  /// Add new Task
  Future<void> addTask({required Task task}) async {
    await box.put(task.id, task);
  }

  /// Show task
  Future<Task?> getTask({required String id}) async {
    return box.get(id);
  }

  /// Update task
  Future<void> updateTask({required Task task}) async {
    await task.save();
  }

  /// Delete task
  Future<void> dalateTask({required Task task}) async {
    await task.delete();
  }

  ValueListenable<Box<Task>> listenToTask() {
    return box.listenable();
  }
}

class FirestoreDataStore {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser?.uid ?? '';

  /// Listen to all tasks for current user
  Stream<List<Task>> listenToTask() {
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('tasks')
        .orderBy('createdAtDate', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Task.fromMap(doc.data())).toList());
  }

  /// Add new task
  Future<void> addTask({required Task task}) async {
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('tasks')
        .doc(task.id)
        .set(task.toMap());
  }

  /// Update task
  Future<void> updateTask({required Task task}) async {
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('tasks')
        .doc(task.id)
        .update(task.toMap());
  }

  /// Delete task
  Future<void> deleteTask({required Task task}) async {
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('tasks')
        .doc(task.id)
        .delete();
  }

  /// Delete all tasks
  Future<void> clearAllTasks() async {
    final batch = _firestore.batch();
    final tasksRef =
        _firestore.collection('users').doc(_userId).collection('tasks');
    final snapshot = await tasksRef.get();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
