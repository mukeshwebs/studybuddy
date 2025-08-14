import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ConversationCardWidget extends StatelessWidget {
  final Map<String, dynamic> conversation;
  final VoidCallback onTap;
  final VoidCallback onMarkAsRead;
  final VoidCallback onMute;
  final VoidCallback onDelete;
  final VoidCallback onBlock;
  final VoidCallback onClearHistory;
  final VoidCallback onExportNotes;

  const ConversationCardWidget({
    Key? key,
    required this.conversation,
    required this.onTap,
    required this.onMarkAsRead,
    required this.onMute,
    required this.onDelete,
    required this.onBlock,
    required this.onClearHistory,
    required this.onExportNotes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isOnline = conversation['isOnline'] ?? false;
    final int unreadCount = conversation['unreadCount'] ?? 0;
    final bool isTyping = conversation['isTyping'] ?? false;
    final bool isMuted = conversation['isMuted'] ?? false;

    return Dismissible(
      key: Key(conversation['id'].toString()),
      background: _buildSwipeBackground(context, isLeft: false),
      secondaryBackground: _buildSwipeBackground(context, isLeft: true),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          onMarkAsRead();
        } else {
          onDelete();
        }
      },
      child: GestureDetector(
        onTap: onTap,
        onLongPress: () => _showContextMenu(context),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.shadowColor,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              _buildAvatar(context, isOnline),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            conversation['partnerName'] ?? 'Study Partner',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: unreadCount > 0
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isMuted)
                              Padding(
                                padding: EdgeInsets.only(right: 1.w),
                                child: CustomIconWidget(
                                  iconName: 'volume_off',
                                  size: 16,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                            Text(
                              _formatTimestamp(conversation['lastMessageTime']),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: unreadCount > 0
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: 0.6),
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        Expanded(
                          child: isTyping
                              ? _buildTypingIndicator(context)
                              : Text(
                                  conversation['lastMessage'] ??
                                      'No messages yet',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: 0.7),
                                        fontWeight: unreadCount > 0
                                            ? FontWeight.w500
                                            : FontWeight.w400,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                        ),
                        if (unreadCount > 0)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            constraints: BoxConstraints(minWidth: 6.w),
                            child: Text(
                              unreadCount > 99 ? '99+' : unreadCount.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, bool isOnline) {
    return Stack(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: ClipOval(
            child: CustomImageWidget(
              imageUrl: conversation['partnerAvatar'] ??
                  'https://api.dicebear.com/7.x/avataaars/png?seed=${conversation['partnerName']}',
              width: 12.w,
              height: 12.w,
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (isOnline)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 3.w,
              height: 3.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).cardColor,
                  width: 1.5,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTypingIndicator(BuildContext context) {
    return Row(
      children: [
        Text(
          'Typing',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontStyle: FontStyle.italic,
              ),
        ),
        SizedBox(width: 1.w),
        SizedBox(
          width: 6.w,
          height: 2.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (index) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 600 + (index * 200)),
                curve: Curves.easeInOut,
                width: 1.w,
                height: 1.w,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildSwipeBackground(BuildContext context, {required bool isLeft}) {
    return Container(
      color: isLeft ? Colors.red : Colors.green,
      alignment: isLeft ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: isLeft ? 'delete' : 'mark_email_read',
            color: Colors.white,
            size: 24,
          ),
          SizedBox(height: 0.5.h),
          Text(
            isLeft ? 'Delete' : 'Mark Read',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            _buildContextMenuItem(
              context,
              icon: 'mark_email_read',
              title: 'Mark as Read',
              onTap: () {
                Navigator.pop(context);
                onMarkAsRead();
              },
            ),
            _buildContextMenuItem(
              context,
              icon: 'volume_off',
              title: 'Mute Notifications',
              onTap: () {
                Navigator.pop(context);
                onMute();
              },
            ),
            _buildContextMenuItem(
              context,
              icon: 'block',
              title: 'Block User',
              onTap: () {
                Navigator.pop(context);
                onBlock();
              },
              isDestructive: true,
            ),
            _buildContextMenuItem(
              context,
              icon: 'clear',
              title: 'Clear Chat History',
              onTap: () {
                Navigator.pop(context);
                onClearHistory();
              },
            ),
            _buildContextMenuItem(
              context,
              icon: 'download',
              title: 'Export Notes',
              onTap: () {
                Navigator.pop(context);
                onExportNotes();
              },
            ),
            _buildContextMenuItem(
              context,
              icon: 'delete',
              title: 'Delete Conversation',
              onTap: () {
                Navigator.pop(context);
                onDelete();
              },
              isDestructive: true,
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildContextMenuItem(
    BuildContext context, {
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: isDestructive
            ? Colors.red
            : Theme.of(context).colorScheme.onSurface,
        size: 24,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: isDestructive
                  ? Colors.red
                  : Theme.of(context).colorScheme.onSurface,
            ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return '';

    DateTime messageTime;
    if (timestamp is DateTime) {
      messageTime = timestamp;
    } else if (timestamp is String) {
      messageTime = DateTime.tryParse(timestamp) ?? DateTime.now();
    } else {
      return '';
    }

    final now = DateTime.now();
    final difference = now.difference(messageTime);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${messageTime.day}/${messageTime.month}';
    }
  }
}
