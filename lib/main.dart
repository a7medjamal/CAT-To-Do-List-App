import 'package:cat_to_do_list/core/app_router.dart';
import 'package:cat_to_do_list/features/auth/data/repositories/auth_repository_impl.dart'; // Ensure this file exists and contains the AuthRepositoryImpl class definition.
import 'package:cat_to_do_list/features/auth/domain/repositories/usecases/login_user.dart';
import 'package:cat_to_do_list/features/auth/domain/repositories/usecases/signup_user.dart';
import 'package:cat_to_do_list/features/auth/domain/repositories/usecases/user_google_register.dart';
import 'package:cat_to_do_list/features/auth/domain/repositories/usecases/user_logout.dart';
import 'package:cat_to_do_list/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:cat_to_do_list/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:cat_to_do_list/features/tasks/domain/use_cases/add_task.dart';
import 'package:cat_to_do_list/features/tasks/domain/use_cases/delete_task.dart';
import 'package:cat_to_do_list/features/tasks/domain/use_cases/get_task_by_id.dart';
import 'package:cat_to_do_list/features/tasks/domain/use_cases/get_tasks.dart';
import 'package:cat_to_do_list/features/tasks/domain/use_cases/update_task.dart';
import 'package:cat_to_do_list/features/tasks/presentation/screens/cubit/task_cubit.dart';
import 'package:cat_to_do_list/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final authRepository = AuthRepositoryImpl();
  final loginUser = LoginUser(authRepository);
  final logoutUser = LogoutUser(authRepository);
  final signUpUser = SignUpUser(authRepository);
  final signInWithGoogle = SignInWithGoogle(authRepository);
  final firestore = FirebaseFirestore.instance;
  final taskRepository = TaskRepositoryImpl(firestore: firestore);
  final addTask = AddTask(taskRepository);
  final updateTask = UpdateTask(taskRepository);
  final deleteTask = DeleteTask(taskRepository);
  final getTaskById = GetTaskById(taskRepository);
  final getTasks = GetTasks(taskRepository);

  runApp(
    ToDoApp(
      loginUser: loginUser,
      signUpUser: signUpUser,
      addTask: addTask,
      updateTask: updateTask,
      deleteTask: deleteTask,
      getTaskById: getTaskById,
      getTasks: getTasks,
      logoutUser: logoutUser,
      signInWithGoogle: signInWithGoogle,
    ),
  );
}

class ToDoApp extends StatelessWidget {
  final LoginUser loginUser;
  final SignUpUser signUpUser;
  final LogoutUser logoutUser;
  final SignInWithGoogle signInWithGoogle;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;
  final GetTaskById getTaskById;
  final GetTasks getTasks;

  const ToDoApp({
    super.key,
    required this.loginUser,
    required this.signUpUser,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
    required this.getTaskById,
    required this.getTasks,
    required this.logoutUser,
    required this.signInWithGoogle,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // AuthCubit
        BlocProvider(
          create:
              (_) => AuthCubit(
                loginUser: loginUser,
                signUpUser: signUpUser,
                logoutUser: logoutUser,
                signInWithGoogle: signInWithGoogle,
              ),
        ),
        BlocProvider(
          create:
              (_) => TaskCubit(
                addTask: addTask,
                updateTask: updateTask,
                deleteTask: deleteTask,
                getTaskById: getTaskById,
                getTasks: getTasks,
              )..loadTasks(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xff1A1A2F),
          fontFamily: 'Roboto',
          appBarTheme: const AppBarTheme(backgroundColor: Color(0xff242443)),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
