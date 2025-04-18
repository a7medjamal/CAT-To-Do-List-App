import 'package:cat_to_do_list/features/auth/data/repositories/auth_repository_interface.dart';

class SignInWithGoogle {
  final AuthRepository repository;

  SignInWithGoogle(this.repository);

  Future<void> call() => repository.signInWithGoogle();
}
