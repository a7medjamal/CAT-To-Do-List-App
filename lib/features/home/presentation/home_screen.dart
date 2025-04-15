import 'package:cat_to_do_list/features/home/presentation/widgets/buttom_navigation_bar.dart';
import 'package:cat_to_do_list/core/utils/widgets/custom_app_bar.dart';
import 'package:cat_to_do_list/features/home/presentation/widgets/create_new_task_button.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const ButtomNavBar(),
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              pfpPath: 'assets/icons/profile_icon.svg',
              pName: 'Ahmed',
              iconPath: 'assets/icons/home_screen_search_icon.svg',
            ),
            const SizedBox(height: 70),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [CreateNewTaskButton(), const SizedBox(height: 20)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
