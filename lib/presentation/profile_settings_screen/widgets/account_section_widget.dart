import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AccountSectionWidget extends StatelessWidget {
  final bool isLinked;
  final String? linkedEmail;
  final VoidCallback onLinkAccount;

  const AccountSectionWidget({
    Key? key,
    required this.isLinked,
    this.linkedEmail,
    required this.onLinkAccount,
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
              'Account',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'account_circle',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isLinked
                            ? 'Google Account Linked'
                            : 'Link Google Account',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (isLinked && linkedEmail != null) ...[
                        SizedBox(height: 0.5.h),
                        Text(
                          linkedEmail!,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (!isLinked)
                  TextButton(
                    onPressed: onLinkAccount,
                    child: Text('Link'),
                  )
                else
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
              ],
            ),
            if (!isLinked) ...[
              SizedBox(height: 1.h),
              Text(
                'Link your Google account to recover your anonymous profile if you lose access to this device.',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
