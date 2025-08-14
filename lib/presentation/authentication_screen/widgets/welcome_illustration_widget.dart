import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WelcomeIllustrationWidget extends StatelessWidget {
  const WelcomeIllustrationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      height: 25.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppTheme.lightTheme.colorScheme.primaryContainer
            .withValues(alpha: 0.1),
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.05),
                    AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.05),
                  ],
                ),
              ),
            ),
          ),
          // Main illustration
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Students collaboration illustration
                Container(
                  width: 60.w,
                  height: 15.h,
                  child: CustomImageWidget(
                    imageUrl:
                        "https://images.unsplash.com/photo-1522202176988-66273c2fd55f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8c3R1ZGVudHMlMjBzdHVkeWluZ3xlbnwwfHwwfHx8MA%3D%3D",
                    width: 60.w,
                    height: 15.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 2.h),
                // Decorative elements
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStudyIcon(
                        'book', AppTheme.lightTheme.colorScheme.primary),
                    _buildStudyIcon(
                        'group', AppTheme.lightTheme.colorScheme.secondary),
                    _buildStudyIcon(
                        'chat', AppTheme.lightTheme.colorScheme.tertiary),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudyIcon(String iconName, Color color) {
    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.1),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: CustomIconWidget(
        iconName: iconName,
        color: color,
        size: 6.w,
      ),
    );
  }
}
