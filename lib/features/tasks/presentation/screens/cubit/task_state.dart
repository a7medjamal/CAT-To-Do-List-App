// lib/features/tasks/presentation/screens/cubit/task_state.dart
import 'package:cat_to_do_list/features/tasks/domain/entities/task.dart';
import 'package:equatable/equatable.dart'; // Add equatable package: flutter pub add equatable

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;

  const TaskLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}

// Optional: State for single task loading/loaded if needed for details screen
class TaskDetailsLoading extends TaskState {}

class TaskDetailsLoaded extends TaskState {
  final Task task;
  const TaskDetailsLoaded(this.task);
   @override
  List<Object?> get props => [task];
}
