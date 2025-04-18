import 'package:cat_to_do_list/core/app_router.dart';
import 'package:cat_to_do_list/features/home/presentation/widgets/buttom_navigation_bar.dart';
import 'package:cat_to_do_list/core/utils/widgets/custom_app_bar.dart';
import 'package:cat_to_do_list/features/home/presentation/widgets/create_new_task_button.dart';
import 'package:cat_to_do_list/features/home/presentation/widgets/expandable_drawer_button.dart';
import 'package:cat_to_do_list/features/tasks/domain/entities/task.dart';
import 'package:cat_to_do_list/features/tasks/presentation/screens/cubit/task_cubit.dart';
import 'package:cat_to_do_list/features/tasks/presentation/screens/cubit/task_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Import go_router if not already imported
// import 'package:go_router/go_router.dart'; // Use AppRouter helper methods instead

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Ensure tasks are loaded when the screen initializes
    // If loadTasks() is called in main.dart's BlocProvider create, this might be redundant
    // but ensures loading if the user navigates back to home.
    // Consider if you want to reload every time or rely on the stream.
    // context.read<TaskCubit>().loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          const ButtomNavBar(), // Assuming this is correctly implemented
      body: SafeArea(
        child: Column(
          children: [
            // Assuming CustomAppBar is correctly implemented
            CustomAppBar(
              pfpPath: 'assets/icons/profile_icon.svg', // Placeholder
              pName: 'User', // Placeholder - fetch actual user name later
              iconPath:
                  'assets/icons/home_screen_search_icon.svg', // Placeholder
              // Add actions like logout if needed
            ),
            const SizedBox(height: 10), // Reduced spacing
            Expanded(
              child: BlocBuilder<TaskCubit, TaskState>(
                builder: (context, state) {
                  if (state is TaskLoading || state is TaskInitial) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TaskLoaded) {
                    // Filter tasks (Example logic, adjust as needed)
                    final now = DateTime.now();
                    final today = DateTime(now.year, now.month, now.day);
                    final tomorrow = today.add(const Duration(days: 1));

                    final allTasks = state.tasks;
                    final todayTasks =
                        allTasks
                            .where(
                              (task) =>
                                  !task.isCompleted &&
                                  task.timestamp.isAfter(today) &&
                                  task.timestamp.isBefore(tomorrow),
                            )
                            .toList();
                    final previousTasks =
                        allTasks
                            .where(
                              (task) =>
                                  !task.isCompleted &&
                                  task.timestamp.isBefore(today),
                            )
                            .toList();
                    final completedTasks =
                        allTasks.where((task) => task.isCompleted).toList();

                    // Group tasks by category
                    final tasksByCategory = <String, List<Task>>{};
                    for (var task in allTasks.where((t) => !t.isCompleted)) {
                      // Only show active tasks in categories
                      (tasksByCategory[task.category] ??= []).add(task);
                    }

                    if (allTasks.isEmpty) {
                      return const Center(
                        child: Text(
                          "No tasks yet!\nTap '+' to add one.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white54, fontSize: 16),
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      padding: const EdgeInsets.only(
                        bottom: 120,
                        left: 16,
                        right: 16,
                      ), // Add horizontal padding
                      child: Column(
                        children: [
                          if (previousTasks.isNotEmpty) ...[
                            ExpandableDrawerButton(
                              label: 'Previous Tasks (${previousTasks.length})',
                              initiallyExpanded: false, // Collapse by default
                              children: _buildTaskList(context, previousTasks),
                            ),
                            const SizedBox(height: 15),
                          ],
                          if (todayTasks.isNotEmpty) ...[
                            ExpandableDrawerButton(
                              label: 'Today Tasks (${todayTasks.length})',
                              initiallyExpanded: true, // Expand today's tasks
                              children: _buildTaskList(context, todayTasks),
                            ),
                            const SizedBox(height: 15),
                          ],
                          if (tasksByCategory.isNotEmpty) ...[
                            ExpandableDrawerButton(
                              label: 'Categories',
                              initiallyExpanded: false,
                              children:
                                  tasksByCategory.entries.map((entry) {
                                    return ExpansionTile(
                                      // Use ExpansionTile for sub-categories
                                      title: Text(
                                        '${entry.key} (${entry.value.length})',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      iconColor: Colors.white54,
                                      collapsedIconColor: Colors.white54,
                                      children: _buildTaskList(
                                        context,
                                        entry.value,
                                      ),
                                    );
                                  }).toList(),
                            ),
                            const SizedBox(height: 15),
                          ],
                          if (completedTasks.isNotEmpty) ...[
                            ExpandableDrawerButton(
                              label:
                                  'Completed Tasks (${completedTasks.length})',
                              initiallyExpanded: false,
                              children: _buildTaskList(
                                context,
                                completedTasks,
                                isCompletedList: true,
                              ),
                            ),
                            const SizedBox(height: 15),
                          ],
                        ],
                      ),
                    );
                  } else if (state is TaskError) {
                    return Center(
                      child: Text(
                        'Error loading tasks: ${state.message}',
                        style: const TextStyle(color: Colors.redAccent),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return const SizedBox.shrink(); // Default empty state
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 65,
        ), // Adjust padding if needed based on BottomNavBar height
        child: CreateNewTaskButton(
          onPressed: () {
            // Use the AppRouter helper method for navigation
            AppRouter.goToNewTask(context);
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // Helper to build list tiles for tasks
  List<Widget> _buildTaskList(
    BuildContext context,
    List<Task> tasks, {
    bool isCompletedList = false,
  }) {
    if (tasks.isEmpty) {
      return [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            "No tasks here.",
            style: TextStyle(color: Colors.white54),
          ),
        ),
      ];
    }
    return tasks
        .map(
          (task) => ListTile(
            leading: Checkbox(
              // Add checkbox to mark complete/incomplete
              value: task.isCompleted,
              onChanged: (bool? value) {
                if (value != null) {
                  final updatedTask = task.copyWith(isCompleted: value);
                  context.read<TaskCubit>().updateTask(updatedTask);
                }
              },
              checkColor: Colors.black, // Color of the check mark
              activeColor: Colors.deepPurpleAccent, // Color when checked
              side: const BorderSide(
                color: Colors.white54,
              ), // Border color when unchecked
            ),
            title: Text(
              task.title,
              style: TextStyle(
                color: Colors.white,
                decoration:
                    task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                decorationColor: Colors.white54,
              ),
            ),
            subtitle:
                task.description.isNotEmpty
                    ? Text(
                      task.description,
                      style: TextStyle(
                        color: Colors.white70,
                        decoration:
                            task.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                        decorationColor: Colors.white54,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                    : null,
            trailing:
                isCompletedList
                    ? IconButton(
                      // Add delete button for completed tasks
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {
                        // Optional: Add confirmation dialog here
                        context.read<TaskCubit>().deleteTask(task.id);
                      },
                    )
                    : const Icon(
                      Icons.chevron_right,
                      color: Colors.white54,
                    ), // Indicate tappable
            onTap: () {
              // Use AppRouter helper method to navigate to edit screen
              AppRouter.goToEditTask(context, task.id);
            },
            dense: true, // Make list items more compact
          ),
        )
        .toList();
  }
}
