import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xff023C7B),
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Row(
        children: [
          // 🔹 Optional back button
          if (showBackButton)
            IconButton(
              onPressed: onBackPressed ?? () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          // 🔹 Logo aligned to left
          Image.asset(
            "assets/pngs/logo.png",
            height: 50.h,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
