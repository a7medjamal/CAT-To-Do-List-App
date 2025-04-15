import 'package:cat_to_do_list/features/home/presentation/home_screen.dart';
import 'package:cat_to_do_list/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xff1A1A2F),
        fontFamily: 'Roboto',
        appBarTheme: AppBarTheme(backgroundColor: Color(0xff242443)),
      ),
      home: const HomeScreen(),
    );
  }
}
