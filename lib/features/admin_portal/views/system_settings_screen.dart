import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../core/auth/auth_repository.dart';
import '../../common/views/unauthorized_screen.dart';
import '../data/repositories/admin_portal_repository.dart';

/// System Settings Screen
/// Platform configuration and settings
class SystemSettingsScreen extends ConsumerStatefulWidget {
  const SystemSettingsScreen({super.key});

  @override
  ConsumerState<SystemSettingsScreen> createState() => _SystemSettingsScreenState();
}

class _SystemSettingsScreenState extends ConsumerState<SystemSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final permissions = ref.watch(userPermissionsProvider);
    
    if (permissions == null || !permissions.hasAdminPrivileges) {
      return const UnauthorizedScreen(
        message: 'Admin access required to manage settings',
      );
    }

    final repository = ref.watch(adminPortalRepositoryProvider);

    return Scaffold(
      backgroundColor: const Color(0xff00519A),
      appBar: AppBar(
        backgroundColor: const Color(0xff023C7B),
        title: const Text('System Settings'),
      ),
      body: FutureBuilder(
        future: repository.getSettings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
            );
          }

          final settings = snapshot.data;
          if (settings == null) {
            return const Center(child: Text('No settings found', style: TextStyle(color: Colors.white)));
          }

          return ListView(
            padding: EdgeInsets.all(16.w),
            children: [
              _buildSection('General Settings', [
                _buildSettingTile('Platform Name', settings.platformName),
                _buildSettingTile('Default Language', settings.defaultLanguage),
                _buildSettingTile('Timezone', settings.timezone),
              ]),
              Gap(16.h),
              _buildSection('User Settings', [
                _buildSwitchTile('Registration Enabled', settings.registrationEnabled, (val) {}),
                _buildSwitchTile('Email Verification Required', settings.emailVerificationRequired, (val) {}),
              ]),
              Gap(16.h),
              _buildSection('Circle Settings', [
                _buildSettingTile('Max Circle Members', settings.maxCircleMembers.toString()),
              ]),
              Gap(16.h),
              _buildSection('Security Settings', [
                _buildSettingTile('Session Timeout', '${settings.sessionTimeout} minutes'),
                _buildSettingTile('Max File Size', '${settings.maxFileSize} MB'),
              ]),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      color: const Color(0xff023C7B),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingTile(String label, String value) {
    return ListTile(
      title: Text(label, style: const TextStyle(color: Colors.white70)),
      trailing: Text(value, style: const TextStyle(color: Colors.white)),
      onTap: () {},
    );
  }

  Widget _buildSwitchTile(String label, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(label, style: const TextStyle(color: Colors.white70)),
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xff0082DF),
    );
  }
}
