import 'package:cat_to_do_list/core/utils/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            pfpPath: 'assets/icons/user_icon.svg',
            pName: 'Ahmed',
            iconPath: 'assets/icons/home_screen_search_icon.svg',
          ),
          Expanded(
            child: Container(
              color: const Color(0xff1A1A2F),
              child: Center(
                child: Text(
                  'Welcome to the Home Screen',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
