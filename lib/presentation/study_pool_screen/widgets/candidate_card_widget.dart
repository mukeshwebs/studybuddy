import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CandidateCardWidget extends StatelessWidget {
  final Map<String, dynamic> candidate;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onTap;

  const CandidateCardWidget({
    Key? key,
    required this.candidate,
    this.onAccept,
    this.onReject,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final compatibilityScore = candidate['compatibilityScore'] ?? 0;
    final subjects = (candidate['subjects'] as List?)?.cast<String>() ?? [];
    final studyModes = (candidate['studyModes'] as List?)?.cast<String>() ?? [];

    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showQuickPreview(context),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowColor,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Compatibility Score Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color:
                    _getScoreColor(compatibilityScore).withValues(alpha: 0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Compatibility Score',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getScoreColor(compatibilityScore),
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: _getScoreColor(compatibilityScore),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$compatibilityScore%',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar and Basic Info
                  Row(
                    children: [
                      Container(
                        width: 15.w,
                        height: 15.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.1),
                        ),
                        child: CustomImageWidget(
                          imageUrl: candidate['avatar'] ?? '',
                          width: 15.w,
                          height: 15.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              candidate['name'] ?? 'Anonymous',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 0.5.h),
                            Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'school',
                                  size: 16,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.6),
                                ),
                                SizedBox(width: 1.w),
                                Expanded(
                                  child: Text(
                                    candidate['track'] ?? 'General',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: 0.6),
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          CustomIconWidget(
                            iconName: 'location_on',
                            size: 16,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.6),
                          ),
                          Text(
                            '${candidate['distance'] ?? 0}km',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Shared Subjects
                  if (subjects.isNotEmpty) ...[
                    Text(
                      'Shared Subjects',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    SizedBox(height: 1.h),
                    Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: subjects
                          .take(3)
                          .map((subject) => Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  subject,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ))
                          .toList(),
                    ),
                    SizedBox(height: 2.h),
                  ],

                  // Study Modes
                  if (studyModes.isNotEmpty) ...[
                    Text(
                      'Preferred Study Modes',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                    SizedBox(height: 1.h),
                    Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: studyModes
                          .take(2)
                          .map((mode) => Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  mode,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ))
                          .toList(),
                    ),
                    SizedBox(height: 2.h),
                  ],

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onReject,
                          icon: CustomIconWidget(
                            iconName: 'close',
                            size: 18,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          label: Text(
                            'Pass',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.error,
                            ),
                            padding: EdgeInsets.symmetric(vertical: 1.5.h),
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onAccept,
                          icon: CustomIconWidget(
                            iconName: 'favorite',
                            size: 18,
                            color: Colors.white,
                          ),
                          label: const Text('Connect'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 1.5.h),
                          ),
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
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return AppTheme.successLight;
    if (score >= 60) return AppTheme.warningLight;
    return AppTheme.errorLight;
  }

  void _showQuickPreview(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 1.h),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Preview',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: 2.h),
                    _buildPreviewItem(
                        context,
                        'Languages',
                        (candidate['languages'] as List?)?.join(', ') ??
                            'Not specified'),
                    _buildPreviewItem(context, 'Study Intent',
                        candidate['studyIntent'] ?? 'Not specified'),
                    _buildPreviewItem(context, 'Availability',
                        candidate['availability'] ?? 'Not specified'),
                    _buildPreviewItem(
                        context,
                        'Time Slots',
                        (candidate['timeSlots'] as List?)?.join(', ') ??
                            'Not specified'),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              onReject?.call();
                            },
                            child: const Text('Pass'),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              onAccept?.call();
                            },
                            child: const Text('Connect'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewItem(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 25.w,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
