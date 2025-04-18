// lib/features/tasks/data/repositories/task_repository_impl.dart

import 'package:cat_to_do_list/core/utils/auth_helper.dart';
import 'package:cat_to_do_list/features/tasks/data/models/task_model.dart';
import 'package:cat_to_do_list/features/tasks/domain/entities/task.dart';
import 'package:cat_to_do_list/features/tasks/domain/repositories/task_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; // For kDebugMode logging

// Define custom exceptions for better error handling (Optional but recommended)
class TaskRepositoryException implements Exception {
  final String message;
  final dynamic originalException;
  TaskRepositoryException(this.message, [this.originalException]);

  @override
  String toString() {
    if (originalException != null) {
      return 'TaskRepositoryException: $message (Caused by: $originalException)';
    }
    return 'TaskRepositoryException: $message';
  }
}

class TaskRepositoryImpl implements TaskRepository {
  final FirebaseFirestore firestore;

  TaskRepositoryImpl({required this.firestore});

  // Helper to get the correct path in Firestore, ensuring user separation
  CollectionReference _tasksCollection(String uid) =>
      firestore.collection('users').doc(uid).collection('tasks');

  // Helper for logging errors consistently
  void _logError(String message, dynamic error, StackTrace? stackTrace) {
    // Use debugPrint in debug mode, consider a proper logger for release
    if (kDebugMode) {
      debugPrint(
        'TaskRepository Error: $message\nException: $error\nStackTrace: $stackTrace',
      );
    }
  }

  @override
  Future<void> addTask(Task task) async {
    try {
      final uid = AuthHelper.getCurrentUserId(); // Throws if not logged in
      // Ensure ID is set if it's a new task
      final taskWithId =
          task.id.isEmpty
              ? task.copyWith(
                id: _tasksCollection(uid).doc().id,
              ) // Generate ID if empty
              : task;
      final taskModel = TaskModel.fromEntity(taskWithId);

      // Use the potentially generated ID for the document path
      await _tasksCollection(uid).doc(taskModel.id).set(taskModel.toMap());
    } on FirebaseException catch (e, s) {
      _logError('Error adding task to Firestore', e, s);
      throw TaskRepositoryException('Failed to add task. Please try again.', e);
    } catch (e, s) {
      _logError('Unexpected error adding task', e, s);
      throw TaskRepositoryException(
        'An unexpected error occurred while adding the task.',
        e,
      );
    }
  }

  @override
  Future<void> updateTask(Task task) async {
    if (task.id.isEmpty) {
      throw TaskRepositoryException('Cannot update task without an ID.');
    }
    try {
      final uid = AuthHelper.getCurrentUserId();
      final taskModel = TaskModel.fromEntity(task);
      await _tasksCollection(uid).doc(task.id).update(taskModel.toMap());
    } on FirebaseException catch (e, s) {
      _logError('Error updating task in Firestore (ID: ${task.id})', e, s);
      // Check for specific errors like 'not-found'
      if (e.code == 'not-found') {
        throw TaskRepositoryException('Task not found, could not update.', e);
      }
      throw TaskRepositoryException(
        'Failed to update task. Please try again.',
        e,
      );
    } catch (e, s) {
      _logError('Unexpected error updating task (ID: ${task.id})', e, s);
      throw TaskRepositoryException(
        'An unexpected error occurred while updating the task.',
        e,
      );
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    if (taskId.isEmpty) {
      throw TaskRepositoryException('Cannot delete task without an ID.');
    }
    try {
      final uid = AuthHelper.getCurrentUserId();
      await _tasksCollection(uid).doc(taskId).delete();
    } on FirebaseException catch (e, s) {
      _logError('Error deleting task from Firestore (ID: $taskId)', e, s);
      throw TaskRepositoryException(
        'Failed to delete task. Please try again.',
        e,
      );
    } catch (e, s) {
      _logError('Unexpected error deleting task (ID: $taskId)', e, s);
      throw TaskRepositoryException(
        'An unexpected error occurred while deleting the task.',
        e,
      );
    }
  }

  @override
  Stream<List<Task>> getTasks() {
    try {
      final uid = AuthHelper.getCurrentUserId();
      return _tasksCollection(
        uid,
      ).orderBy('timestamp', descending: true).snapshots().map((snapshot) {
        try {
          return snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return TaskModel.fromMap(data, documentId: doc.id).toEntity();
          }).toList();
        } catch (e, s) {
          _logError('Error parsing tasks from snapshot', e, s);
          throw TaskRepositoryException('Failed to parse tasks data', e);
        }
      });
    } catch (e, s) {
      _logError('Error getting tasks stream', e, s);
      throw TaskRepositoryException('Failed to get tasks stream', e);
    }
  }

  @override
  Future<Task?> GetTaskById(String taskId) async {
    if (taskId.isEmpty) {
      throw TaskRepositoryException('Cannot get task with empty ID.');
    }
    try {
      final uid = AuthHelper.getCurrentUserId();
      final doc = await _tasksCollection(uid).doc(taskId).get();
      if (!doc.exists) return null;

      final data = doc.data() as Map<String, dynamic>;
      return TaskModel.fromMap(data, documentId: doc.id).toEntity();
    } on FirebaseException catch (e, s) {
      _logError('Error getting task from Firestore (ID: $taskId)', e, s);
      if (e.code == 'permission-denied') {
        throw TaskRepositoryException(
          'You do not have permission to access this task.',
          e,
        );
      }
      throw TaskRepositoryException('Failed to get task. Please try again.', e);
    } catch (e, s) {
      _logError('Unexpected error getting task (ID: $taskId)', e, s);
      throw TaskRepositoryException(
        'An unexpected error occurred while getting the task.',
        e,
      );
    }
  }
}
