import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/conversation_card_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/tab_navigation_widget.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  String _searchQuery = '';
  bool _isLoading = false;
  List<Map<String, dynamic>> _conversations = [];
  List<Map<String, dynamic>> _filteredConversations = [];

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  void _loadConversations() {
    // Mock conversation data
    _conversations = [
      {
        'id': 1,
        'partnerName': 'Arjun Sharma',
        'partnerAvatar':
            'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=400',
        'lastMessage':
            'Thanks for explaining the calculus problem! Really helped me understand derivatives better.',
        'lastMessageTime': DateTime.now().subtract(const Duration(minutes: 15)),
        'unreadCount': 2,
        'isOnline': true,
        'isTyping': false,
        'isMuted': false,
      },
      {
        'id': 2,
        'partnerName': 'Priya Patel',
        'partnerAvatar':
            'https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400',
        'lastMessage':
            'Can we discuss the organic chemistry reactions tomorrow?',
        'lastMessageTime': DateTime.now().subtract(const Duration(hours: 2)),
        'unreadCount': 0,
        'isOnline': false,
        'isTyping': false,
        'isMuted': false,
      },
      {
        'id': 3,
        'partnerName': 'Rohit Kumar',
        'partnerAvatar':
            'https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=400',
        'lastMessage':
            'The physics mock test was challenging. How did you find the electromagnetic induction questions?',
        'lastMessageTime': DateTime.now().subtract(const Duration(hours: 5)),
        'unreadCount': 1,
        'isOnline': true,
        'isTyping': true,
        'isMuted': false,
      },
      {
        'id': 4,
        'partnerName': 'Sneha Reddy',
        'partnerAvatar':
            'https://images.pexels.com/photos/1130626/pexels-photo-1130626.jpeg?auto=compress&cs=tinysrgb&w=400',
        'lastMessage':
            'Great study session today! The group discussion on Indian history was very insightful.',
        'lastMessageTime': DateTime.now().subtract(const Duration(days: 1)),
        'unreadCount': 0,
        'isOnline': false,
        'isTyping': false,
        'isMuted': true,
      },
      {
        'id': 5,
        'partnerName': 'Vikram Singh',
        'partnerAvatar':
            'https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg?auto=compress&cs=tinysrgb&w=400',
        'lastMessage':
            'Could you share your notes on data structures? I missed the last class.',
        'lastMessageTime': DateTime.now().subtract(const Duration(days: 2)),
        'unreadCount': 5,
        'isOnline': true,
        'isTyping': false,
        'isMuted': false,
      },
    ];

    _filteredConversations = List.from(_conversations);
  }

  void _filterConversations(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredConversations = List.from(_conversations);
      } else {
        _filteredConversations = _conversations.where((conversation) {
          final partnerName =
              (conversation['partnerName'] as String).toLowerCase();
          final lastMessage =
              (conversation['lastMessage'] as String).toLowerCase();
          final searchLower = query.toLowerCase();

          return partnerName.contains(searchLower) ||
              lastMessage.contains(searchLower);
        }).toList();
      }
    });
  }

  Future<void> _refreshConversations() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    _loadConversations();
    _filterConversations(_searchQuery);

    setState(() {
      _isLoading = false;
    });
  }

  void _markAsRead(int conversationId) {
    setState(() {
      final index =
          _conversations.indexWhere((conv) => conv['id'] == conversationId);
      if (index != -1) {
        _conversations[index]['unreadCount'] = 0;
        _filterConversations(_searchQuery);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Conversation marked as read'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _muteConversation(int conversationId) {
    setState(() {
      final index =
          _conversations.indexWhere((conv) => conv['id'] == conversationId);
      if (index != -1) {
        _conversations[index]['isMuted'] =
            !(_conversations[index]['isMuted'] ?? false);
        _filterConversations(_searchQuery);
      }
    });

    final isMuted = _conversations
        .firstWhere((conv) => conv['id'] == conversationId)['isMuted'];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(isMuted ? 'Notifications muted' : 'Notifications enabled'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _deleteConversation(int conversationId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Conversation'),
        content: const Text(
            'Are you sure you want to delete this conversation? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _conversations
                    .removeWhere((conv) => conv['id'] == conversationId);
                _filterConversations(_searchQuery);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Conversation deleted'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _blockUser(int conversationId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Block User'),
        content: const Text(
            'Are you sure you want to block this user? They will no longer be able to send you messages.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _conversations
                    .removeWhere((conv) => conv['id'] == conversationId);
                _filterConversations(_searchQuery);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('User blocked successfully'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Block'),
          ),
        ],
      ),
    );
  }

  void _clearChatHistory(int conversationId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat History'),
        content: const Text(
            'Are you sure you want to clear all messages in this conversation?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                final index = _conversations
                    .indexWhere((conv) => conv['id'] == conversationId);
                if (index != -1) {
                  _conversations[index]['lastMessage'] = 'No messages yet';
                  _conversations[index]['unreadCount'] = 0;
                  _filterConversations(_searchQuery);
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Chat history cleared'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _exportNotes(int conversationId) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notes exported successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _openChat(Map<String, dynamic> conversation) {
    Navigator.pushNamed(
      context,
      '/individual-chat-screen',
      arguments: conversation,
    );
  }

  void _startNewChat() {
    Navigator.pushNamed(context, '/study-pool-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'StudyBuddy',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          IconButton(
            onPressed: _refreshConversations,
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: Theme.of(context).colorScheme.onSurface,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/profile-settings-screen');
            },
            icon: CustomIconWidget(
              iconName: 'settings',
              color: Theme.of(context).colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          SearchBarWidget(
            onSearchChanged: _filterConversations,
            hintText: 'Search conversations...',
          ),

          // Conversations List
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _filteredConversations.isEmpty
                    ? _searchQuery.isNotEmpty
                        ? _buildNoSearchResults()
                        : EmptyStateWidget(onStartChat: _startNewChat)
                    : RefreshIndicator(
                        onRefresh: _refreshConversations,
                        child: ListView.builder(
                          itemCount: _filteredConversations.length,
                          itemBuilder: (context, index) {
                            final conversation = _filteredConversations[index];
                            return ConversationCardWidget(
                              conversation: conversation,
                              onTap: () => _openChat(conversation),
                              onMarkAsRead: () =>
                                  _markAsRead(conversation['id']),
                              onMute: () =>
                                  _muteConversation(conversation['id']),
                              onDelete: () =>
                                  _deleteConversation(conversation['id']),
                              onBlock: () => _blockUser(conversation['id']),
                              onClearHistory: () =>
                                  _clearChatHistory(conversation['id']),
                              onExportNotes: () =>
                                  _exportNotes(conversation['id']),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      bottomNavigationBar: TabNavigationWidget(
        currentIndex: 1, // Chats tab is active
        onTabChanged: (index) {
          // Tab change handled in widget
        },
      ),
      floatingActionButton: _filteredConversations.isNotEmpty
          ? FloatingActionButton(
              onPressed: _startNewChat,
              child: CustomIconWidget(
                iconName: 'add',
                color: Theme.of(context).colorScheme.onPrimary,
                size: 24,
              ),
            )
          : null,
    );
  }

  Widget _buildNoSearchResults() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              size: 64,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.4),
            ),
            SizedBox(height: 2.h),
            Text(
              'No Results Found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Try searching with different keywords or check your spelling.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            TextButton(
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _filteredConversations = List.from(_conversations);
                });
              },
              child: const Text('Clear Search'),
            ),
          ],
        ),
      ),
    );
  }
}
