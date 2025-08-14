import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AppPreferencesWidget extends StatelessWidget {
  final String selectedLanguage;
  final String selectedTheme;
  final Map<String, bool> notificationSettings;
  final Function(String) onLanguageChanged;
  final Function(String) onThemeChanged;
  final Function(String, bool) onNotificationChanged;

  const AppPreferencesWidget({
    Key? key,
    required this.selectedLanguage,
    required this.selectedTheme,
    required this.notificationSettings,
    required this.onLanguageChanged,
    required this.onThemeChanged,
    required this.onNotificationChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> languages = [
      {'code': 'en', 'name': 'English'},
      {'code': 'hi', 'name': 'हिंदी'},
      {'code': 'bn', 'name': 'বাংলা'},
      {'code': 'mr', 'name': 'मराठी'},
      {'code': 'ta', 'name': 'தமிழ்'},
      {'code': 'te', 'name': 'తెలుగు'},
      {'code': 'kn', 'name': 'ಕನ್ನಡ'},
      {'code': 'gu', 'name': 'ગુજરાતી'},
      {'code': 'ur', 'name': 'اردو'},
    ];

    final List<Map<String, String>> themes = [
      {'value': 'light', 'name': 'Light'},
      {'value': 'dark', 'name': 'Dark'},
      {'value': 'system', 'name': 'System'},
    ];

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'App Preferences',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildLanguageSelector(languages),
            Divider(height: 3.h),
            _buildThemeSelector(themes),
            Divider(height: 3.h),
            _buildNotificationSettings(),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(List<Map<String, String>> languages) {
    return InkWell(
      onTap: () => _showLanguageDialog(languages),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: 'language',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Language',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    languages.firstWhere(
                      (lang) => lang['code'] == selectedLanguage,
                      orElse: () => {'name': 'English'},
                    )['name']!,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
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

  Widget _buildThemeSelector(List<Map<String, String>> themes) {
    return InkWell(
      onTap: () => _showThemeDialog(themes),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: 'palette',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Theme',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    themes.firstWhere(
                      (theme) => theme['value'] == selectedTheme,
                      orElse: () => {'name': 'Light'},
                    )['name']!,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
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

  Widget _buildNotificationSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'notifications',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Text(
              'Notifications',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        _buildNotificationToggle('matches', 'New Matches'),
        _buildNotificationToggle('messages', 'Messages'),
        _buildNotificationToggle('updates', 'App Updates'),
      ],
    );
  }

  Widget _buildNotificationToggle(String key, String title) {
    return Padding(
      padding: EdgeInsets.only(left: 9.w, top: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          Switch(
            value: notificationSettings[key] ?? true,
            onChanged: (value) => onNotificationChanged(key, value),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(List<Map<String, String>> languages) {
    // This would typically show a dialog with language options
    // For now, we'll just cycle through the first few languages
    final currentIndex =
        languages.indexWhere((lang) => lang['code'] == selectedLanguage);
    final nextIndex = (currentIndex + 1) % languages.length;
    onLanguageChanged(languages[nextIndex]['code']!);
  }

  void _showThemeDialog(List<Map<String, String>> themes) {
    // This would typically show a dialog with theme options
    // For now, we'll just cycle through themes
    final currentIndex =
        themes.indexWhere((theme) => theme['value'] == selectedTheme);
    final nextIndex = (currentIndex + 1) % themes.length;
    onThemeChanged(themes[nextIndex]['value']!);
  }
}
