import 'package:cat_to_do_list/features/auth/domain/repositories/usecases/login_user.dart';
import 'package:cat_to_do_list/features/auth/domain/repositories/usecases/signup_user.dart';
import 'package:cat_to_do_list/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUser loginUser;
  final SignUpUser signUpUser;

  AuthCubit({required this.loginUser, required this.signUpUser})
    : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      await loginUser.call(email, password);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> signUp(String email, String password) async {
    emit(AuthLoading());
    try {
      await signUpUser.call(email, password);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      await loginUser.signInWithGoogle();
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
