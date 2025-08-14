import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChatMessageWidget extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isOutgoing;
  final VoidCallback? onLongPress;

  const ChatMessageWidget({
    super.key,
    required this.message,
    required this.isOutgoing,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final messageType = message['type'] as String? ?? 'text';
    final timestamp = message['timestamp'] as DateTime? ?? DateTime.now();
    final status = message['status'] as String? ?? 'sent';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
      child: Row(
        mainAxisAlignment:
            isOutgoing ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isOutgoing) ...[
            CircleAvatar(
              radius: 2.5.w,
              backgroundColor: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              child: CustomIconWidget(
                iconName: 'person',
                size: 3.w,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
            SizedBox(width: 2.w),
          ],
          Flexible(
            child: GestureDetector(
              onLongPress: onLongPress,
              child: Container(
                constraints: BoxConstraints(maxWidth: 70.w),
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: isOutgoing
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.w),
                    topRight: Radius.circular(4.w),
                    bottomLeft: Radius.circular(isOutgoing ? 4.w : 1.w),
                    bottomRight: Radius.circular(isOutgoing ? 1.w : 4.w),
                  ),
                  border: !isOutgoing
                      ? Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.2),
                          width: 1,
                        )
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (messageType == 'image') ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2.w),
                        child: CustomImageWidget(
                          imageUrl: message['imageUrl'] as String,
                          width: 60.w,
                          height: 30.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (message['caption'] != null &&
                          (message['caption'] as String).isNotEmpty) ...[
                        SizedBox(height: 1.h),
                        Text(
                          message['caption'] as String,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: isOutgoing
                                ? Colors.white
                                : AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ] else ...[
                      Text(
                        message['content'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: isOutgoing
                              ? Colors.white
                              : AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                    SizedBox(height: 0.5.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(timestamp),
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: isOutgoing
                                ? Colors.white.withValues(alpha: 0.7)
                                : AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                            fontSize: 10.sp,
                          ),
                        ),
                        if (isOutgoing) ...[
                          SizedBox(width: 1.w),
                          CustomIconWidget(
                            iconName: _getStatusIcon(status),
                            size: 3.w,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isOutgoing) SizedBox(width: 2.w),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${timestamp.day}/${timestamp.month}';
    } else if (difference.inHours > 0) {
      return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else {
      return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }

  String _getStatusIcon(String status) {
    switch (status) {
      case 'sending':
        return 'access_time';
      case 'sent':
        return 'check';
      case 'delivered':
        return 'done_all';
      case 'read':
        return 'done_all';
      default:
        return 'check';
    }
  }
}
