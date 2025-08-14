import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconName;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyStateWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.iconName,
    this.buttonText,
    this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  size: 20.w,
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.6),
                ),
              ),
            ),

            SizedBox(height: 4.h),

            // Title
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            // Subtitle
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),

            if (buttonText != null && onButtonPressed != null) ...[
              SizedBox(height: 4.h),

              // Action Button
              ElevatedButton.icon(
                onPressed: onButtonPressed,
                icon: CustomIconWidget(
                  iconName: 'tune',
                  size: 18,
                  color: Colors.white,
                ),
                label: Text(buttonText!),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
