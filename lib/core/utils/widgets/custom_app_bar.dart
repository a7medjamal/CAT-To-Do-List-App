// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget {
  String? iconPath;
  String? pfpPath, pName, taskName;
  bool taskScreen = false;
  CustomAppBar({
    super.key,
    this.iconPath,
    this.pfpPath,
    this.pName,
    this.taskName,
    this.taskScreen = false,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xff7A12FF), width: 1)),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: AppBar(
        backgroundColor: const Color(0xff242443),
        toolbarHeight: 80,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            taskScreen
                ? Text(
                  taskName!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                )
                : Text(
                  'Hello ${pName ?? 'User'},',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
            const SizedBox(height: 5),
            !taskScreen
                ? Text(
                  'Keep Plan For 1 Day',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                )
                : const SizedBox(height: 0),
          ],
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          if (iconPath != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: SvgPicture.asset(
                iconPath!,
                height: 30,
                color: Colors.white,
              ),
            )
          else
            const SizedBox(width: 1),
        ],
        leading:
            pfpPath != null
                ? Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: SvgPicture.asset(
                    pfpPath!,
                    fit: BoxFit.contain,
                    height: 32,
                  ),
                )
                : Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: SvgPicture.asset(
                    'assets/icons/profile_icon.svg',
                    fit: BoxFit.contain,
                    height: 32,
                  ),
                ),
      ),
    );
  }
}
