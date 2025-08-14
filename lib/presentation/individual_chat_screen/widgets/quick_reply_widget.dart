import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class QuickReplyWidget extends StatelessWidget {
  final Function(String) onQuickReply;

  const QuickReplyWidget({
    super.key,
    required this.onQuickReply,
  });

  @override
  Widget build(BuildContext context) {
    final quickReplies = [
      'Thanks for help! 🙏',
      'Let\'s study together 📚',
      'Can you explain this? 🤔',
      'Got it! ✅',
      'Need more time ⏰',
      'Share notes? 📝',
    ];

    return Container(
      height: 6.h,
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: quickReplies.length,
        separatorBuilder: (context, index) => SizedBox(width: 2.w),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onQuickReply(quickReplies[index]),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(5.w),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Text(
                quickReplies[index],
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
