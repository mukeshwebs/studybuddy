import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PrivacySafetyCardWidget extends StatelessWidget {
  final List<Map<String, dynamic>> blockedUsers;
  final Function(String) onUnblockUser;
  final VoidCallback onReportIssue;
  final VoidCallback onDataDeletion;

  const PrivacySafetyCardWidget({
    Key? key,
    required this.blockedUsers,
    required this.onUnblockUser,
    required this.onReportIssue,
    required this.onDataDeletion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy & Safety',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildSettingItem(
              icon: 'block',
              title: 'Blocked Users',
              subtitle: '${blockedUsers.length} users blocked',
              onTap: () => _showBlockedUsersDialog(context),
            ),
            Divider(height: 3.h),
            _buildSettingItem(
              icon: 'report',
              title: 'Report Issues',
              subtitle: 'Report bugs or inappropriate behavior',
              onTap: onReportIssue,
            ),
            Divider(height: 3.h),
            _buildSettingItem(
              icon: 'delete_forever',
              title: 'Delete My Data',
              subtitle: 'Permanently delete all your data',
              onTap: () => _showDataDeletionDialog(context),
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: isDestructive
                  ? AppTheme.lightTheme.colorScheme.error
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isDestructive
                          ? AppTheme.lightTheme.colorScheme.error
                          : null,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showBlockedUsersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Blocked Users'),
        content: blockedUsers.isEmpty
            ? Text('No blocked users')
            : SizedBox(
                width: double.maxFinite,
                height: 30.h,
                child: ListView.builder(
                  itemCount: blockedUsers.length,
                  itemBuilder: (context, index) {
                    final user = blockedUsers[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user['avatar'] ?? ''),
                        radius: 20,
                      ),
                      title: Text(user['name'] ?? 'Unknown User'),
                      trailing: TextButton(
                        onPressed: () {
                          onUnblockUser(user['id'] ?? '');
                          Navigator.pop(context);
                        },
                        child: Text('Unblock'),
                      ),
                    );
                  },
                ),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDataDeletionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete All Data'),
        content: Text(
          'This action will permanently delete all your data including profile, chat history, and preferences. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDataDeletion();
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
