import 'package:cat_to_do_list/features/tasks/domain/repositories/task_repository.dart';
import 'package:cat_to_do_list/features/tasks/domain/entities/task.dart';

class GetTasks {
  final TaskRepository repository;

  GetTasks(this.repository);

  Stream<List<Task>> execute() {
    return repository.getTasks();
  }
}
