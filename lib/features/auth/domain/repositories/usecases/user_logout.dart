
import 'package:cat_to_do_list/features/auth/data/repositories/auth_repository_interface.dart';

class LogoutUser {
  final AuthRepository repository;

  LogoutUser(this.repository);

  Future<void> call() async {
    return await repository.logout();
  }
}
