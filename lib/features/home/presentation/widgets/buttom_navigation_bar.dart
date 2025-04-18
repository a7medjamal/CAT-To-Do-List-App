import 'package:cat_to_do_list/core/app_router.dart';
import 'package:cat_to_do_list/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:cat_to_do_list/features/home/presentation/widgets/buttom_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ButtomNavBar extends StatefulWidget {
  const ButtomNavBar({super.key});

  @override
  State<ButtomNavBar> createState() => _ButtomNavBarState();
}

class _ButtomNavBarState extends State<ButtomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(18.0),
        topRight: Radius.circular(18.0),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          unselectedItemColor: Color(0xff777E99),
          onTap: _onItemTapped,
          backgroundColor: const Color(0xff242443),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          selectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          showUnselectedLabels: false,
          showSelectedLabels: false,
          items: [
            buildNavItem(
              'assets/icons/menu_icon.svg',
              'Menu',
              0,
              _selectedIndex,
              () {},
            ),
            buildNavItem(
              'assets/icons/tasks_icon.svg',
              'Tasks',
              1,
              _selectedIndex,
              () {},
            ),
            buildNavItem(
              'assets/icons/calendar_icon.svg',
              'Calendar',
              2,
              _selectedIndex,
              () {},
            ),
            buildNavItem(
              'assets/icons/user_icon.svg',
              'Mine',
              3,
              _selectedIndex,
              () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Are you sure you want to log out?',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 12,
                              ),
                            ),
                            onPressed: () async {
                              GoRouter.of(context).pop();
                              context.read<AuthCubit>().logout();
                              GoRouter.of(context).push(AppRouter.kLoginView);
                            },
                            child: const Text('Log Out'),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () => GoRouter.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
