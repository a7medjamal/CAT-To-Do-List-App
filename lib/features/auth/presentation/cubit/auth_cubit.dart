import 'package:cat_to_do_list/features/auth/domain/repositories/usecases/login_user.dart';
import 'package:cat_to_do_list/features/auth/domain/repositories/usecases/signup_user.dart';
import 'package:cat_to_do_list/features/auth/domain/repositories/usecases/user_google_register.dart';
import 'package:cat_to_do_list/features/auth/domain/repositories/usecases/user_logout.dart';
import 'package:cat_to_do_list/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUser loginUser;
  final SignUpUser signUpUser;
  final LogoutUser logoutUser;
  final SignInWithGoogle signInWithGoogle;

  AuthCubit({
    required this.loginUser,
    required this.signUpUser,
    required this.logoutUser,
    required this.signInWithGoogle,
  }) : super(AuthInitial());

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

  Future<void> signInWithGoogleAccount() async {
    emit(AuthLoading());
    try {
      await signInWithGoogle.call();
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await logoutUser.call();
      emit(AuthLoggedOut());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
