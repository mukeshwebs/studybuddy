import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AboutSectionWidget extends StatelessWidget {
  final String appVersion;
  final VoidCallback onPrivacyPolicy;
  final VoidCallback onTermsOfService;
  final VoidCallback onFeedback;

  const AboutSectionWidget({
    Key? key,
    required this.appVersion,
    required this.onPrivacyPolicy,
    required this.onTermsOfService,
    required this.onFeedback,
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
              'About',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildAboutItem(
              icon: 'info',
              title: 'App Version',
              subtitle: appVersion,
              onTap: null,
            ),
            Divider(height: 3.h),
            _buildAboutItem(
              icon: 'privacy_tip',
              title: 'Privacy Policy',
              subtitle: 'How we protect your data',
              onTap: onPrivacyPolicy,
            ),
            Divider(height: 3.h),
            _buildAboutItem(
              icon: 'description',
              title: 'Terms of Service',
              subtitle: 'App usage terms and conditions',
              onTap: onTermsOfService,
            ),
            Divider(height: 3.h),
            _buildAboutItem(
              icon: 'feedback',
              title: 'Send Feedback',
              subtitle: 'Help us improve StudyBuddy',
              onTap: onFeedback,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutItem({
    required String icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
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
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
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
            if (onTap != null)
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
}
