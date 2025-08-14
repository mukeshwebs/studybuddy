import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../models/study_buddy_models.dart';
import '../../../widgets/custom_icon_widget.dart';

class TrackSelectionCard extends StatelessWidget {
  final StudyTrack track;
  final bool isSelected;
  final VoidCallback onTap;

  const TrackSelectionCard({
    Key? key,
    required this.track,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  String _getTrackIcon(StudyTrack track) {
    switch (track) {
      case StudyTrack.class10:
      case StudyTrack.class11:
      case StudyTrack.class12:
        return 'school';
      case StudyTrack.iitJeeMain:
      case StudyTrack.iitJeeAdvanced:
        return 'engineering';
      case StudyTrack.neet:
        return 'local_hospital';
      case StudyTrack.ugcNetPaper1:
      case StudyTrack.ugcNetCS:
      case StudyTrack.ugcNetCommerce:
        return 'account_balance';
      case StudyTrack.sscCgl:
      case StudyTrack.sscChsl:
        return 'work';
      case StudyTrack.engineeringFirstYear:
        return 'precision_manufacturing';
      case StudyTrack.codingDsa:
        return 'code';
    }
  }

  Color _getTrackColor(StudyTrack track) {
    switch (track) {
      case StudyTrack.class10:
      case StudyTrack.class11:
      case StudyTrack.class12:
        return Colors.blue;
      case StudyTrack.iitJeeMain:
      case StudyTrack.iitJeeAdvanced:
        return Colors.orange;
      case StudyTrack.neet:
        return Colors.green;
      case StudyTrack.ugcNetPaper1:
      case StudyTrack.ugcNetCS:
      case StudyTrack.ugcNetCommerce:
        return Colors.purple;
      case StudyTrack.sscCgl:
      case StudyTrack.sscChsl:
        return Colors.red;
      case StudyTrack.engineeringFirstYear:
        return Colors.teal;
      case StudyTrack.codingDsa:
        return Colors.indigo;
    }
  }

  @override
  Widget build(BuildContext context) {
    final trackColor = _getTrackColor(track);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? trackColor.withValues(alpha: 0.1)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? trackColor
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: trackColor.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: isSelected
                      ? trackColor
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomIconWidget(
                  iconName: _getTrackIcon(track),
                  size: 6.w,
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.7),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                track.displayName,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? trackColor
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (isSelected) ...[
                SizedBox(height: 1.h),
                CustomIconWidget(
                  iconName: 'check_circle',
                  size: 5.w,
                  color: trackColor,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
