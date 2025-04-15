import 'package:cat_to_do_list/features/home/presentation/widgets/buttom_navigation_bar.dart';
import 'package:cat_to_do_list/core/utils/widgets/custom_app_bar.dart';
import 'package:cat_to_do_list/features/home/presentation/widgets/create_new_task_button.dart';
import 'package:cat_to_do_list/features/home/presentation/widgets/expandable_drawer_button.dart';
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
            const SizedBox(height: 20),
            ExpandableDrawerButton(
              label: 'Previous Tasks',
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Personal',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Work',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ExpandableDrawerButton(
              label: 'Today Tasks',
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Personal',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Work',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ExpandableDrawerButton(
              label: 'Categories',
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Personal',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Work',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ExpandableDrawerButton(
              label: 'Completed Tasks',
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Personal',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Work',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
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
