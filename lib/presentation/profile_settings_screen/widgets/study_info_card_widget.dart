import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class StudyInfoCardWidget extends StatelessWidget {
  final Map<String, dynamic> studyInfo;
  final VoidCallback onEditPressed;

  const StudyInfoCardWidget({
    Key? key,
    required this.studyInfo,
    required this.onEditPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Study Information',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: onEditPressed,
                  child: Text('Edit'),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            _buildInfoRow('Track', studyInfo['track'] ?? 'Not selected'),
            SizedBox(height: 1.h),
            _buildInfoRow('Subjects', _formatSubjects(studyInfo['subjects'])),
            SizedBox(height: 1.h),
            _buildInfoRow(
                'Study Mode', studyInfo['studyMode'] ?? 'Not selected'),
            SizedBox(height: 1.h),
            _buildInfoRow(
                'Languages', _formatLanguages(studyInfo['languages'])),
            SizedBox(height: 1.h),
            _buildInfoRow(
                'Time Slots', studyInfo['timeSlots'] ?? 'Not selected'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 25.w,
          child: Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  String _formatSubjects(dynamic subjects) {
    if (subjects == null) return 'Not selected';
    if (subjects is List) {
      return (subjects).join(', ');
    }
    return subjects.toString();
  }

  String _formatLanguages(dynamic languages) {
    if (languages == null) return 'Not selected';
    if (languages is List) {
      return (languages).join(', ');
    }
    return languages.toString();
  }
}
