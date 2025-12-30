import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/auth/auth_repository.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/widgets/popup.dart';
import '../../Donate/views/donate_screen.dart';
import '../../actions/views/my_actions_screen.dart';
import '../../allnotes/views/all_notes_screen.dart';
import '../../chat/views/chats_screen.dart';
import '../../mycalls/views/mycalls.dart';
import '../../profile/views/my_profile.dart';
import '../../profile/views/profile_page.dart';

class DashBoardScreen extends ConsumerStatefulWidget {
  const DashBoardScreen({super.key});

  @override
  ConsumerState<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends ConsumerState<DashBoardScreen> {
  int _selectedIndex = 0;

  // Example pages for each tab
  final List<Widget> _pages = [
    ChatsScreen(),
    ProfilePageScreen(),
    MycallsScreen(),
    MyActionsScreen(), // Changed from DonateScreen to MyActionsScreen
    AllNotesScreen(),
    MyProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _showFirstTimePopup();
  }

  Future<void> _showFirstTimePopup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      showDialog(
        context: context,
        builder: (_) => const Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(16),
          child: LearnerPopupCard(),
        ),
      );
      await prefs.setBool('isFirstTime', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if user has admin privileges
    final permissions = ref.watch(userPermissionsProvider);
    final isAdmin = permissions?.hasAdminPrivileges ?? false;
    
    return Scaffold(
      backgroundColor: const Color(0xff0056A6),
      body: Stack(
        children: [
          // ======= Page Content =======
          Positioned.fill(child: _pages[_selectedIndex]),

          // ======= Admin Portal Button (for admins only) =======
          if (isAdmin)
            Positioned(
              top: 40,
              right: 16,
              child: SafeArea(
                child: FloatingActionButton(
                  heroTag: 'admin_portal',
                  onPressed: () => context.push(Routes.admin),
                  backgroundColor: const Color(0xff0082DF),
                  child: const Icon(Icons.admin_panel_settings, color: Colors.white),
                ),
              ),
            ),

          // ======= Bottom Navigation =======
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 65,
                  color: const Color(0xff0082DF),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _bottomIcon('assets/pngs/chat.png', 'Chats', 0),
                      _bottomIcon('assets/pngs/multiperson.png', 'Groups', 1),
                      _bottomIcon('assets/pngs/call.png', 'Phone', 2),
                      _bottomIcon('assets/pngs/mail.png', 'Actions', 3),
                      _bottomIcon('assets/pngs/note.png', 'Notes', 4),
                      _bottomIcon('assets/pngs/profile.png', 'Profile', 5),
                    ],
                  ),
                ),
                Container(
                  height: 39,
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Color(0xff012B5E)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "©2025 Kingdom® Call Circles",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Licensed Trademark",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Privacy Policy",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===== Bottom Navigation Icon =====
  Widget _bottomIcon(String image, String label, int index) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedIndex = index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 30, width: 30),

          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
