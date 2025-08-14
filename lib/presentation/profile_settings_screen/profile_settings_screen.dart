import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/about_section_widget.dart';
import './widgets/account_section_widget.dart';
import './widgets/app_preferences_widget.dart';
import './widgets/avatar_selection_widget.dart';
import './widgets/location_settings_widget.dart';
import './widgets/privacy_safety_card_widget.dart';
import './widgets/study_info_card_widget.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _nameController = TextEditingController();
  bool _isEditingName = false;

  // Mock user data
  String _selectedAvatar =
      'https://api.dicebear.com/7.x/avataaars/png?seed=Felix&backgroundColor=b6e3f4';
  String _displayName = 'StudyBuddy_2024';
  bool _isGoogleLinked = false;
  String? _linkedEmail;
  String _selectedLanguage = 'en';
  String _selectedTheme = 'light';
  bool _isLocationEnabled = true;

  final Map<String, dynamic> _studyInfo = {
    'track': 'IIT-JEE',
    'subjects': ['Mathematics', 'Physics', 'Chemistry'],
    'studyMode': '1-on-1, Problem Solving',
    'languages': ['English', 'Hindi'],
    'timeSlots': 'Evening (6-9 PM)',
  };

  final Map<String, bool> _notificationSettings = {
    'matches': true,
    'messages': true,
    'updates': false,
  };

  final List<Map<String, dynamic>> _blockedUsers = [
    {
      'id': 'user1',
      'name': 'Anonymous_User_123',
      'avatar':
          'https://api.dicebear.com/7.x/avataaars/png?seed=Blocked1&backgroundColor=ffb3ba',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 2);
    _nameController.text = _displayName;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Settings'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: CustomIconWidget(
                iconName: 'groups',
                size: 20,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              text: 'Study Pool',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'chat',
                size: 20,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              text: 'Chats',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'person',
                size: 20,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              text: 'Profile',
            ),
          ],
          onTap: (index) {
            if (index != 2) {
              _navigateToTab(index);
            }
          },
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildPlaceholderTab('Study Pool'),
            _buildPlaceholderTab('Chats'),
            _buildProfileTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderTab(String tabName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'construction',
            size: 48,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: 2.h),
          Text(
            '$tabName Coming Soon',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(),
          SizedBox(height: 2.h),
          StudyInfoCardWidget(
            studyInfo: _studyInfo,
            onEditPressed: _showStudyInfoEditSheet,
          ),
          AccountSectionWidget(
            isLinked: _isGoogleLinked,
            linkedEmail: _linkedEmail,
            onLinkAccount: _handleGoogleAccountLink,
          ),
          PrivacySafetyCardWidget(
            blockedUsers: _blockedUsers,
            onUnblockUser: _handleUnblockUser,
            onReportIssue: _handleReportIssue,
            onDataDeletion: _handleDataDeletion,
          ),
          AppPreferencesWidget(
            selectedLanguage: _selectedLanguage,
            selectedTheme: _selectedTheme,
            notificationSettings: _notificationSettings,
            onLanguageChanged: _handleLanguageChange,
            onThemeChanged: _handleThemeChange,
            onNotificationChanged: _handleNotificationChange,
          ),
          LocationSettingsWidget(
            isLocationEnabled: _isLocationEnabled,
            onManageLocation: _handleManageLocation,
          ),
          AboutSectionWidget(
            appVersion: '1.0.0 (Build 1)',
            onPrivacyPolicy: _handlePrivacyPolicy,
            onTermsOfService: _handleTermsOfService,
            onFeedback: _handleFeedback,
          ),
          SizedBox(height: 2.h),
          _buildLogoutButton(),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: _showAvatarSelection,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(_selectedAvatar),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(1.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: CustomIconWidget(
                            iconName: 'edit',
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: _isEditingName
                      ? TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: 'Enter display name',
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: _saveDisplayName,
                                  icon: CustomIconWidget(
                                    iconName: 'check',
                                    size: 20,
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                  ),
                                ),
                                IconButton(
                                  onPressed: _cancelEditName,
                                  icon: CustomIconWidget(
                                    iconName: 'close',
                                    size: 20,
                                    color:
                                        AppTheme.lightTheme.colorScheme.error,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          autofocus: true,
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _displayName,
                                    style: AppTheme
                                        .lightTheme.textTheme.titleMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    'Anonymous Profile',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: _startEditName,
                              icon: CustomIconWidget(
                                iconName: 'edit',
                                size: 20,
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: _handleLogout,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.lightTheme.colorScheme.error,
            side: BorderSide(color: AppTheme.lightTheme.colorScheme.error),
            padding: EdgeInsets.symmetric(vertical: 1.5.h),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'logout',
                size: 20,
                color: AppTheme.lightTheme.colorScheme.error,
              ),
              SizedBox(width: 2.w),
              Text('Logout'),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToTab(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/study-pool-screen');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/chat-list-screen');
        break;
    }
  }

  void _showAvatarSelection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AvatarSelectionWidget(
        selectedAvatar: _selectedAvatar,
        onAvatarSelected: (avatar) {
          setState(() {
            _selectedAvatar = avatar;
          });
          Navigator.pop(context);
          _showSuccessToast('Avatar updated successfully');
        },
      ),
    );
  }

  void _startEditName() {
    setState(() {
      _isEditingName = true;
      _nameController.text = _displayName;
    });
  }

  void _saveDisplayName() {
    if (_nameController.text.trim().isNotEmpty) {
      setState(() {
        _displayName = _nameController.text.trim();
        _isEditingName = false;
      });
      _showSuccessToast('Display name updated');
    }
  }

  void _cancelEditName() {
    setState(() {
      _isEditingName = false;
      _nameController.text = _displayName;
    });
  }

  void _showStudyInfoEditSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: 50.h,
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            Text(
              'Edit Study Information',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: Center(
                child: Text(
                  'Study information editing will be available in the next update',
                  textAlign: TextAlign.center,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleGoogleAccountLink() async {
    // Simulate Google account linking
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _isGoogleLinked = true;
      _linkedEmail = 'user@gmail.com';
    });
    _showSuccessToast('Google account linked successfully');
  }

  void _handleUnblockUser(String userId) {
    setState(() {
      _blockedUsers.removeWhere((user) => user['id'] == userId);
    });
    _showSuccessToast('User unblocked');
  }

  void _handleReportIssue() {
    _showSuccessToast('Report submitted. Thank you for your feedback!');
  }

  void _handleDataDeletion() {
    _showSuccessToast('Data deletion request submitted');
  }

  void _handleLanguageChange(String language) {
    setState(() {
      _selectedLanguage = language;
    });
    _showSuccessToast('Language updated');
  }

  void _handleThemeChange(String theme) {
    setState(() {
      _selectedTheme = theme;
    });
    _showSuccessToast('Theme updated');
  }

  void _handleNotificationChange(String key, bool value) {
    setState(() {
      _notificationSettings[key] = value;
    });
    _showSuccessToast('Notification settings updated');
  }

  void _handleManageLocation() {
    setState(() {
      _isLocationEnabled = !_isLocationEnabled;
    });
    _showSuccessToast(_isLocationEnabled
        ? 'Location access enabled'
        : 'Location access disabled');
  }

  void _handlePrivacyPolicy() {
    _showSuccessToast('Opening Privacy Policy...');
  }

  void _handleTermsOfService() {
    _showSuccessToast('Opening Terms of Service...');
  }

  void _handleFeedback() {
    _showSuccessToast('Opening feedback form...');
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text(
            'Are you sure you want to logout? You will need to sign in again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/authentication-screen');
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showSuccessToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      textColor: Colors.white,
    );
  }
}
