import 'package:cat_to_do_list/features/tasks/domain/repositories/task_repository.dart';

class DeleteTask {
  final TaskRepository repository;

  DeleteTask(this.repository);

  Future<void> execute(String taskId) {
    return repository.deleteTask(taskId);
  }
}
