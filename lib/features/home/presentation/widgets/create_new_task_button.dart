import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CreateNewTaskButton extends StatelessWidget {
  const CreateNewTaskButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(350, 50),
        backgroundColor: const Color(0xff7A12FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/create_new_task_icon.svg',
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          const Text(
            'Create New Task',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
