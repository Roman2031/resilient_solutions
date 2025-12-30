import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/rbac_providers.dart';
import '../../../core/auth/auth_repository.dart';

/// Example screen demonstrating RBAC implementation
/// This shows how to use role-based access control in the UI
class RBACExampleScreen extends ConsumerWidget {
  const RBACExampleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissions = ref.watch(userPermissionsProvider);
    final userDisplayName = ref.watch(userDisplayNameProvider);
    final userEmail = ref.watch(userEmailProvider);
    final roleNames = ref.watch(userRoleDisplayNamesProvider);
    final navItems = ref.watch(navigationItemsProvider);
    
    final canManageCircles = ref.watch(
      canAccessFeatureProvider('manage_circle'),
    );
    final canCreateCourses = ref.watch(
      canAccessFeatureProvider('create_course'),
    );
    final isAdminUIVisible = ref.watch(shouldShowAdminUIProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('RBAC Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authRepositoryProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: permissions == null
          ? const Center(child: Text('Not authenticated'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Info Section
                  _buildSectionCard(
                    title: 'User Information',
                    children: [
                      _buildInfoRow('Name', userDisplayName ?? 'N/A'),
                      _buildInfoRow('Email', userEmail ?? 'N/A'),
                      _buildInfoRow(
                        'Roles',
                        roleNames.join(', '),
                      ),
                      _buildInfoRow(
                        'Magento ID',
                        permissions.magentoId ?? 'N/A',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Roles & Permissions Section
                  _buildSectionCard(
                    title: 'Roles & Permissions',
                    children: [
                      _buildRoleBadge('Learner', permissions.isLearner),
                      _buildRoleBadge('Facilitator', permissions.isFacilitator),
                      _buildRoleBadge('Instructor', permissions.isInstructor),
                      _buildRoleBadge('Admin', permissions.isAdmin),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Capabilities Section
                  _buildSectionCard(
                    title: 'Capabilities',
                    children: [
                      _buildCapabilityChip(
                        'Manage Circles',
                        permissions.canManageCircles,
                      ),
                      _buildCapabilityChip(
                        'Manage Courses',
                        permissions.canManageCourses,
                      ),
                      _buildCapabilityChip(
                        'Write Attendance',
                        permissions.canWriteAttendance,
                      ),
                      _buildCapabilityChip(
                        'Broadcast Messages',
                        permissions.canBroadcastMessages,
                      ),
                      _buildCapabilityChip(
                        'Admin Privileges',
                        permissions.hasAdminPrivileges,
                      ),
                      _buildCapabilityChip(
                        'Moderate',
                        permissions.canModerate,
                      ),
                      _buildCapabilityChip(
                        'Export Data',
                        permissions.canExport,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // API Scopes Section
                  _buildSectionCard(
                    title: 'API Scopes',
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: permissions.apiScopes
                            .map((scope) => Chip(
                                  label: Text(
                                    scope,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  backgroundColor: Colors.blue.shade100,
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Feature Access Section
                  _buildSectionCard(
                    title: 'Feature Access',
                    children: [
                      _buildFeatureAccess(
                        'Manage Circle UI',
                        canManageCircles,
                      ),
                      _buildFeatureAccess(
                        'Create Course UI',
                        canCreateCourses,
                      ),
                      _buildFeatureAccess(
                        'Admin Panel',
                        isAdminUIVisible,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Navigation Items Section
                  _buildSectionCard(
                    title: 'Navigation Items',
                    children: [
                      ...navItems.map((item) => ListTile(
                            leading: Icon(
                              _getIconData(item.icon),
                              color: Theme.of(context).primaryColor,
                            ),
                            title: Text(item.label),
                            subtitle: Text(item.route),
                            dense: true,
                          )),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Groups/Communities Section
                  if (permissions.groups.isNotEmpty)
                    _buildSectionCard(
                      title: 'Groups/Communities',
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: permissions.groups
                              .map((group) => Chip(
                                    label: Text(group),
                                    backgroundColor: Colors.green.shade100,
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleBadge(String role, bool hasRole) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: hasRole ? Colors.green.shade100 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            hasRole ? Icons.check_circle : Icons.cancel,
            size: 20,
            color: hasRole ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            role,
            style: TextStyle(
              fontWeight: hasRole ? FontWeight.bold : FontWeight.normal,
              color: hasRole ? Colors.green.shade800 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCapabilityChip(String capability, bool hasCapability) {
    return Chip(
      label: Text(capability),
      avatar: Icon(
        hasCapability ? Icons.check : Icons.close,
        size: 18,
        color: hasCapability ? Colors.green : Colors.red,
      ),
      backgroundColor:
          hasCapability ? Colors.green.shade50 : Colors.grey.shade200,
    );
  }

  Widget _buildFeatureAccess(String feature, bool hasAccess) {
    return ListTile(
      leading: Icon(
        hasAccess ? Icons.check_circle : Icons.cancel,
        color: hasAccess ? Colors.green : Colors.red,
      ),
      title: Text(feature),
      subtitle: Text(hasAccess ? 'Accessible' : 'No access'),
      dense: true,
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'home':
        return Icons.home;
      case 'school':
        return Icons.school;
      case 'group':
        return Icons.group;
      case 'manage_accounts':
        return Icons.manage_accounts;
      case 'create':
        return Icons.create;
      case 'analytics':
        return Icons.analytics;
      case 'admin_panel_settings':
        return Icons.admin_panel_settings;
      case 'person':
        return Icons.person;
      case 'login':
        return Icons.login;
      default:
        return Icons.circle;
    }
  }
}
