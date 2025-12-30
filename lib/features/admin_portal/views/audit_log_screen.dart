import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../core/auth/auth_repository.dart';
import '../../common/views/unauthorized_screen.dart';
import '../data/repositories/admin_portal_repository.dart';

/// Audit Log Screen
/// Activity audit trail and logs
class AuditLogScreen extends ConsumerWidget {
  const AuditLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissions = ref.watch(userPermissionsProvider);
    
    if (permissions == null || !permissions.hasAdminPrivileges) {
      return const UnauthorizedScreen(
        message: 'Admin access required to view audit logs',
      );
    }

    final repository = ref.watch(adminPortalRepositoryProvider);

    return Scaffold(
      backgroundColor: const Color(0xff00519A),
      appBar: AppBar(
        backgroundColor: const Color(0xff023C7B),
        title: const Text('Audit Logs'),
      ),
      body: FutureBuilder(
        future: repository.getAuditLogs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
            );
          }

          final logs = snapshot.data ?? [];
          
          if (logs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64.sp, color: Colors.white38),
                  Gap(16.h),
                  Text(
                    'No audit logs found',
                    style: TextStyle(fontSize: 18.sp, color: Colors.white70),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              return Card(
                color: const Color(0xff023C7B),
                margin: EdgeInsets.only(bottom: 8.h),
                child: ListTile(
                  leading: Icon(
                    _getEventIcon(log.eventType),
                    color: _getEventColor(log.eventType),
                  ),
                  title: Text(
                    log.action,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    '${log.userName} • ${_formatDate(log.timestamp)}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.white54),
                  onTap: () => _showLogDetails(context, log),
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData _getEventIcon(String eventType) {
    switch (eventType.toLowerCase()) {
      case 'user_created':
        return Icons.person_add;
      case 'user_deleted':
        return Icons.person_remove;
      case 'role_assigned':
        return Icons.admin_panel_settings;
      case 'settings_changed':
        return Icons.settings;
      default:
        return Icons.info;
    }
  }

  Color _getEventColor(String eventType) {
    switch (eventType.toLowerCase()) {
      case 'user_created':
        return Colors.green;
      case 'user_deleted':
        return Colors.red;
      case 'role_assigned':
        return Colors.blue;
      case 'settings_changed':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showLogDetails(BuildContext context, dynamic log) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff023C7B),
        title: const Text('Log Details', style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Event Type', log.eventType),
              _buildDetailRow('Action', log.action),
              _buildDetailRow('User', log.userName),
              _buildDetailRow('Time', _formatDate(log.timestamp)),
              if (log.ipAddress != null) _buildDetailRow('IP Address', log.ipAddress!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
