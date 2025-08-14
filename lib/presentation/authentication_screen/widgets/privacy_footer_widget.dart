import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PrivacyFooterWidget extends StatelessWidget {
  const PrivacyFooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'shield',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Your privacy is protected',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'We use anonymous authentication to protect your identity.\nCompliant with Indian data protection regulations.',
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.6),
              height: 1.3,
            ),
          ),
          SizedBox(height: 1.5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFeatureChip('No Personal Data', 'privacy_tip'),
              SizedBox(width: 3.w),
              _buildFeatureChip('Secure Login', 'lock'),
              SizedBox(width: 3.w),
              _buildFeatureChip('Indian Compliant', 'verified'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(String text, String iconName) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 3.w,
          ),
          SizedBox(width: 1.w),
          Text(
            text,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
