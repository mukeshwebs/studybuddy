import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/chat_message_widget.dart';
import './widgets/message_input_widget.dart';
import './widgets/quick_reply_widget.dart';
import './widgets/typing_indicator_widget.dart';

class IndividualChatScreen extends StatefulWidget {
  const IndividualChatScreen({super.key});

  @override
  State<IndividualChatScreen> createState() => _IndividualChatScreenState();
}

class _IndividualChatScreenState extends State<IndividualChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isPartnerTyping = false;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  final int _messagesPerPage = 50;

  // Mock partner data
  final Map<String, dynamic> _partnerData = {
    "id": "partner_123",
    "name": "StudyMate_47",
    "isOnline": true,
    "lastSeen": DateTime.now().subtract(const Duration(minutes: 2)),
    "avatar":
        "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
  };

  @override
  void initState() {
    super.initState();
    _loadInitialMessages();
    _scrollController.addListener(_onScroll);
    _simulatePartnerActivity();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialMessages() {
    final initialMessages = [
      {
        "id": "msg_1",
        "content":
            "Hey! I saw you're studying for JEE too. Need help with Physics problems?",
        "type": "text",
        "senderId": "partner_123",
        "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
        "status": "read",
      },
      {
        "id": "msg_2",
        "content":
            "Yes! I'm struggling with rotational mechanics. Do you have good notes?",
        "type": "text",
        "senderId": "current_user",
        "timestamp":
            DateTime.now().subtract(const Duration(hours: 1, minutes: 58)),
        "status": "read",
      },
      {
        "id": "msg_3",
        "content":
            "Perfect! I have detailed notes on moment of inertia and angular momentum.",
        "type": "text",
        "senderId": "partner_123",
        "timestamp":
            DateTime.now().subtract(const Duration(hours: 1, minutes: 55)),
        "status": "read",
      },
      {
        "id": "msg_4",
        "imageUrl":
            "https://images.pexels.com/photos/6238297/pexels-photo-6238297.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "caption": "Here's my handwritten notes on rotational dynamics",
        "type": "image",
        "senderId": "partner_123",
        "timestamp":
            DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
        "status": "read",
      },
      {
        "id": "msg_5",
        "content": "Wow! These are amazing notes. Thank you so much! 🙏",
        "type": "text",
        "senderId": "current_user",
        "timestamp":
            DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
        "status": "read",
      },
      {
        "id": "msg_6",
        "content": "No problem! Want to solve some practice problems together?",
        "type": "text",
        "senderId": "partner_123",
        "timestamp":
            DateTime.now().subtract(const Duration(hours: 1, minutes: 40)),
        "status": "read",
      },
      {
        "id": "msg_7",
        "content":
            "Absolutely! I have the HC Verma book. Should we start with chapter 10?",
        "type": "text",
        "senderId": "current_user",
        "timestamp":
            DateTime.now().subtract(const Duration(hours: 1, minutes: 35)),
        "status": "read",
      },
      {
        "id": "msg_8",
        "content":
            "Great choice! HC Verma has the best problems for JEE preparation.",
        "type": "text",
        "senderId": "partner_123",
        "timestamp":
            DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
        "status": "read",
      },
      {
        "id": "msg_9",
        "imageUrl":
            "https://images.pexels.com/photos/159711/books-bookstore-book-reading-159711.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "caption": "My study setup for today's physics session",
        "type": "image",
        "senderId": "current_user",
        "timestamp":
            DateTime.now().subtract(const Duration(hours: 1, minutes: 25)),
        "status": "delivered",
      },
      {
        "id": "msg_10",
        "content":
            "Nice setup! Let's start with problem 10.1. Have you attempted it?",
        "type": "text",
        "senderId": "partner_123",
        "timestamp": DateTime.now().subtract(const Duration(minutes: 15)),
        "status": "read",
      },
      {
        "id": "msg_11",
        "content":
            "I tried but got stuck at the integration part. Can you help?",
        "type": "text",
        "senderId": "current_user",
        "timestamp": DateTime.now().subtract(const Duration(minutes: 10)),
        "status": "sent",
      },
    ];

    setState(() {
      _messages.addAll(initialMessages.reversed);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _simulatePartnerActivity() {
    // Simulate partner typing after 30 seconds
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) {
        setState(() {
          _isPartnerTyping = true;
        });

        // Stop typing after 3 seconds and send a message
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _isPartnerTyping = false;
            });
            _receiveMessage(
                "Sure! For integration in rotational problems, you need to consider the limits carefully. Let me explain step by step...");
          }
        });
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      _loadMoreMessages();
    }
  }

  void _loadMoreMessages() {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    // Simulate loading more messages
    Future.delayed(const Duration(seconds: 1), () {
      final moreMessages = List.generate(20, (index) {
        final messageIndex = _messages.length + index + 1;
        return {
          "id": "msg_old_$messageIndex",
          "content":
              "This is an older message #$messageIndex from our previous study session.",
          "type": "text",
          "senderId": messageIndex % 2 == 0 ? "current_user" : "partner_123",
          "timestamp":
              DateTime.now().subtract(Duration(days: 1, hours: messageIndex)),
          "status": "read",
        };
      });

      if (mounted) {
        setState(() {
          _messages.insertAll(0, moreMessages.reversed);
          _isLoadingMore = false;
          _currentPage++;
        });
      }
    });
  }

  void _sendMessage(String content) {
    final newMessage = {
      "id": "msg_${DateTime.now().millisecondsSinceEpoch}",
      "content": content,
      "type": "text",
      "senderId": "current_user",
      "timestamp": DateTime.now(),
      "status": "sending",
    };

    setState(() {
      _messages.add(newMessage);
    });

    _scrollToBottom();

    // Simulate message status updates
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          newMessage["status"] = "sent";
        });
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          newMessage["status"] = "delivered";
        });
      }
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          newMessage["status"] = "read";
        });
      }
    });
  }

  void _sendImage(XFile image) {
    final newMessage = {
      "id": "msg_${DateTime.now().millisecondsSinceEpoch}",
      "imageUrl":
          "https://images.pexels.com/photos/4050315/pexels-photo-4050315.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "caption": "Shared an image",
      "type": "image",
      "senderId": "current_user",
      "timestamp": DateTime.now(),
      "status": "sending",
    };

    setState(() {
      _messages.add(newMessage);
    });

    _scrollToBottom();

    // Simulate upload and status updates
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          newMessage["status"] = "sent";
        });
      }
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          newMessage["status"] = "delivered";
        });
      }
    });
  }

  void _receiveMessage(String content) {
    final newMessage = {
      "id": "msg_${DateTime.now().millisecondsSinceEpoch}",
      "content": content,
      "type": "text",
      "senderId": "partner_123",
      "timestamp": DateTime.now(),
      "status": "read",
    };

    setState(() {
      _messages.add(newMessage);
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onTypingStart() {
    // Handle typing start - could send typing indicator to partner
  }

  void _onTypingStop() {
    // Handle typing stop - could stop typing indicator to partner
  }

  void _onQuickReply(String message) {
    _sendMessage(message);
  }

  void _showMessageOptions(Map<String, dynamic> message) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
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
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(1.w),
              ),
            ),
            SizedBox(height: 3.h),
            if (message['type'] == 'text') ...[
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'content_copy',
                  size: 5.w,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
                title: Text('Copy Text'),
                onTap: () {
                  Navigator.pop(context);
                  // Copy to clipboard logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Text copied to clipboard')),
                  );
                },
              ),
            ],
            if (message['senderId'] == 'current_user') ...[
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'delete',
                  size: 5.w,
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
                title: Text(
                  'Delete Message',
                  style:
                      TextStyle(color: AppTheme.lightTheme.colorScheme.error),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _messages.removeWhere((msg) => msg['id'] == message['id']);
                  });
                },
              ),
            ] else ...[
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'report',
                  size: 5.w,
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
                title: Text(
                  'Report Content',
                  style:
                      TextStyle(color: AppTheme.lightTheme.colorScheme.error),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Content reported')),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showChatOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
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
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(1.w),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Chat Options',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'settings',
                size: 5.w,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              title: const Text('Chat Settings'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Chat settings opened')),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'clear_all',
                size: 5.w,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              title: const Text('Clear History'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Clear Chat History'),
                    content: const Text(
                        'Are you sure you want to clear all messages? This action cannot be undone.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            _messages.clear();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Chat history cleared')),
                          );
                        },
                        child: Text(
                          'Clear',
                          style: TextStyle(
                              color: AppTheme.lightTheme.colorScheme.error),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'block',
                size: 5.w,
                color: AppTheme.lightTheme.colorScheme.error,
              ),
              title: Text(
                'Block User',
                style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
              ),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Block User'),
                    content: Text(
                        'Are you sure you want to block ${_partnerData['name']}? You won\'t receive messages from them anymore.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context); // Go back to chat list
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    '${_partnerData['name']} has been blocked')),
                          );
                        },
                        child: Text(
                          'Block',
                          style: TextStyle(
                              color: AppTheme.lightTheme.colorScheme.error),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            size: 6.w,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 4.w,
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  child: CustomIconWidget(
                    iconName: 'person',
                    size: 5.w,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
                if (_partnerData['isOnline'] as bool) ...[
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 2.5.w,
                      height: 2.5.w,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _partnerData['name'] as String,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    (_partnerData['isOnline'] as bool)
                        ? 'Online'
                        : 'Last seen ${_formatLastSeen(_partnerData['lastSeen'] as DateTime)}',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: (_partnerData['isOnline'] as bool)
                          ? Colors.green
                          : AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _showChatOptions,
            icon: CustomIconWidget(
              iconName: 'more_vert',
              size: 6.w,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
        ],
        elevation: 1,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      ),
      body: Column(
        children: [
          // Auto-deletion notice
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            color: AppTheme.lightTheme.colorScheme.primaryContainer
                .withValues(alpha: 0.3),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  size: 4.w,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Messages are automatically deleted after 30 days',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Quick replies
          QuickReplyWidget(onQuickReply: _onQuickReply),

          // Messages area
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _loadMoreMessages();
              },
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(vertical: 1.h),
                itemCount: _messages.length +
                    (_isLoadingMore ? 1 : 0) +
                    (_isPartnerTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isLoadingMore && index == 0) {
                    return Container(
                      padding: EdgeInsets.all(4.w),
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 6.w,
                        height: 6.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                      ),
                    );
                  }

                  final messageIndex = _isLoadingMore ? index - 1 : index;

                  if (_isPartnerTyping && messageIndex == _messages.length) {
                    return TypingIndicatorWidget(
                      partnerName: _partnerData['name'] as String,
                    );
                  }

                  if (messageIndex >= _messages.length)
                    return const SizedBox.shrink();

                  final message = _messages[messageIndex];
                  final isOutgoing = message['senderId'] == 'current_user';

                  return ChatMessageWidget(
                    message: message,
                    isOutgoing: isOutgoing,
                    onLongPress: () => _showMessageOptions(message),
                  );
                },
              ),
            ),
          ),

          // Message input
          MessageInputWidget(
            onSendMessage: _sendMessage,
            onSendImage: _sendImage,
            onTypingStart: _onTypingStart,
            onTypingStop: _onTypingStop,
          ),
        ],
      ),
    );
  }

  String _formatLastSeen(DateTime lastSeen) {
    final now = DateTime.now();
    final difference = now.difference(lastSeen);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }
}
