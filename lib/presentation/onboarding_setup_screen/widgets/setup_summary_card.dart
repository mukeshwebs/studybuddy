import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SetupSummaryCard extends StatelessWidget {
  final Map<String, dynamic> setupData;

  const SetupSummaryCard({
    super.key,
    required this.setupData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Setup Complete!',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Your profile is ready for matching',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Track Summary
          _buildSummarySection(
            'Educational Track',
            setupData['selectedTrack'] ?? 'Not selected',
            'school',
          ),

          SizedBox(height: 2.h),

          // Subjects Summary
          _buildSummarySection(
            'Selected Subjects',
            _formatSubjects(setupData['selectedSubjects'] ?? []),
            'book',
          ),

          SizedBox(height: 2.h),

          // Preferences Summary
          _buildSummarySection(
            'Study Preferences',
            _formatPreferences(setupData['studyPreferences'] ?? {}),
            'settings',
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(String title, String content, String iconName) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(1.5.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(6),
          ),
          child: CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.6),
            size: 4.w,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                content,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatSubjects(List<dynamic> subjects) {
    if (subjects.isEmpty) return 'No subjects selected';
    if (subjects.length <= 3) {
      return subjects.join(', ');
    }
    return '${subjects.take(3).join(', ')} and ${subjects.length - 3} more';
  }

  String _formatPreferences(Map<String, dynamic> preferences) {
    List<String> summary = [];

    if (preferences['studyModes'] != null &&
        (preferences['studyModes'] as List).isNotEmpty) {
      summary.add('${(preferences['studyModes'] as List).length} study modes');
    }

    if (preferences['languages'] != null &&
        (preferences['languages'] as List).isNotEmpty) {
      summary.add('${(preferences['languages'] as List).length} languages');
    }

    if (preferences['timeSlots'] != null &&
        (preferences['timeSlots'] as List).isNotEmpty) {
      summary.add('${(preferences['timeSlots'] as List).length} time slots');
    }

    return summary.isEmpty ? 'Basic preferences set' : summary.join(', ');
  }
}
