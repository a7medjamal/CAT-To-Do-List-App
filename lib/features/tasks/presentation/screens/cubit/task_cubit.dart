// lib/features/tasks/presentation/screens/cubit/task_cubit.dart
import 'dart:async'; // Import async
import 'package:bloc/bloc.dart';
import 'package:cat_to_do_list/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:cat_to_do_list/features/tasks/domain/entities/task.dart';
import 'package:cat_to_do_list/features/tasks/domain/use_cases/add_task.dart';
import 'package:cat_to_do_list/features/tasks/domain/use_cases/delete_task.dart';
import 'package:cat_to_do_list/features/tasks/domain/use_cases/get_task_by_id.dart';
import 'package:cat_to_do_list/features/tasks/domain/use_cases/get_tasks.dart'; // Import GetTasks
import 'package:cat_to_do_list/features/tasks/domain/use_cases/update_task.dart';
import 'package:cat_to_do_list/features/tasks/presentation/screens/cubit/task_state.dart'; // Import the new state file

class TaskCubit extends Cubit<TaskState> {
  final AddTask _addTask;
  final UpdateTask _updateTask;
  final DeleteTask _deleteTask;
  final GetTaskById _getTaskById;
  final GetTasks _getTasks; // Add GetTasks use case

  StreamSubscription? _tasksSubscription; // To manage the stream subscription

  TaskCubit({
    required AddTask addTask,
    required UpdateTask updateTask,
    required DeleteTask deleteTask,
    required GetTaskById getTaskById,
    required GetTasks getTasks, // Require GetTasks
  }) : _addTask = addTask,
       _updateTask = updateTask,
       _deleteTask = deleteTask,
       _getTaskById = getTaskById,
       _getTasks = getTasks,
       super(TaskInitial()) {
    // Optionally load tasks immediately when the Cubit is created
    // loadTasks();
  }

  // Load tasks and listen to stream
  Future<void> loadTasks() async {
    if (state is TaskLoading) return; // Prevent multiple simultaneous loads

    emit(TaskLoading());
    await _tasksSubscription
        ?.cancel(); // Cancel previous subscription if exists

    try {
      _tasksSubscription = _getTasks.execute().listen(
        (tasks) => emit(TaskLoaded(tasks)),
        onError: (error) {
          final errorMessage =
              error is TaskRepositoryException
                  ? error.message
                  : "Failed to load tasks: ${error.toString()}";
          emit(TaskError(errorMessage));
          // Revert to previous state if possible
          if (state is TaskLoaded) {
            emit(TaskLoaded((state as TaskLoaded).tasks));
          }
        },
      );
    } catch (e) {
      final errorMessage =
          e is TaskRepositoryException
              ? e.message
              : "Failed to initiate task loading: ${e.toString()}";
      emit(TaskError(errorMessage));
    }
  }

  // Add task
  Future<void> addTask(Task task) async {
    final previousState = state;
    try {
      // Validate task data
      if (task.title.trim().isEmpty) {
        throw TaskRepositoryException('Task title cannot be empty');
      }

      await _addTask.execute(task);
      // Stream will automatically update the state
    } catch (e) {
      final errorMessage =
          e is TaskRepositoryException
              ? e.message
              : "Failed to add task: ${e.toString()}";
      emit(TaskError(errorMessage));

      // Restore previous state
      if (previousState is TaskLoaded) {
        emit(previousState);
      }
    }
  }

  // Update task
  Future<void> updateTask(Task task) async {
    final previousState = state;
    try {
      // Validate task data
      if (task.id.isEmpty) {
        throw TaskRepositoryException('Cannot update task without an ID');
      }
      if (task.title.trim().isEmpty) {
        throw TaskRepositoryException('Task title cannot be empty');
      }

      await _updateTask.execute(task);
      // Stream will automatically update the state
    } catch (e) {
      final errorMessage =
          e is TaskRepositoryException
              ? e.message
              : "Failed to update task: ${e.toString()}";
      emit(TaskError(errorMessage));

      // Restore previous state
      if (previousState is TaskLoaded) {
        emit(previousState);
      }
    }
  }

  // Delete task
  Future<void> deleteTask(String taskId) async {
    final previousState = state;
    try {
      if (taskId.isEmpty) {
        throw TaskRepositoryException('Cannot delete task without an ID');
      }

      await _deleteTask.execute(taskId);
      // Stream will automatically update the state
    } catch (e) {
      final errorMessage =
          e is TaskRepositoryException
              ? e.message
              : "Failed to delete task: ${e.toString()}";
      emit(TaskError(errorMessage));

      // Restore previous state
      if (previousState is TaskLoaded) {
        emit(previousState);
      }
    }
  }

  // Get task by ID - This is primarily for the details screen's initial load
  // It doesn't necessarily need to emit a global state unless you want to show
  // loading specifically for fetching details.
  Future<Task?> getTaskById(String taskId) async {
    // emit(TaskDetailsLoading()); // Optional: if you want a specific loading state
    try {
      final task = await _getTaskById.execute(taskId);
      // if (task != null) {
      //   emit(TaskDetailsLoaded(task)); // Optional: emit details loaded state
      // } else {
      //   // Handle task not found - maybe emit an error or specific state
      //   emit(TaskError("Task with ID $taskId not found"));
      // }
      return task;
    } catch (e) {
      // emit(TaskError("Failed to get task details: ${e.toString()}")); // Optional
      print("Error fetching task by ID: $e"); // Log error
      return null;
    }
  }

  // Override close to cancel the subscription
  @override
  Future<void> close() {
    _tasksSubscription?.cancel();
    return super.close();
  }
}
