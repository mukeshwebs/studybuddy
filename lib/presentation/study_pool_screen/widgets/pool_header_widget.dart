import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PoolHeaderWidget extends StatelessWidget {
  final bool isInPool;
  final int onlineCount;
  final VoidCallback onTogglePool;
  final VoidCallback onShowFilters;
  final bool isOnlineMode;
  final VoidCallback onToggleMode;

  const PoolHeaderWidget({
    Key? key,
    required this.isInPool,
    required this.onlineCount,
    required this.onTogglePool,
    required this.onShowFilters,
    required this.isOnlineMode,
    required this.onToggleMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Pool Status and Controls
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isInPool
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isInPool
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context)
                              .colorScheme
                              .outline
                              .withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 3.w,
                        height: 3.w,
                        decoration: BoxDecoration(
                          color: isInPool ? AppTheme.successLight : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isInPool
                                  ? 'You\'re in the pool!'
                                  : 'Join the study pool',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: isInPool
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                  ),
                            ),
                            Text(
                              isInPool
                                  ? 'Finding compatible study partners...'
                                  : 'Start discovering study buddies',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: isInPool
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer
                                            .withValues(alpha: 0.7)
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: 0.6),
                                  ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: onTogglePool,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isInPool
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 1.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          isInPool ? 'Leave' : 'Join',
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Online Count and Controls
          Row(
            children: [
              // Online Count
              Expanded(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'people',
                        size: 20,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '$onlineCount students online',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(width: 3.w),

              // Mode Toggle
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    _buildModeButton(
                      context,
                      'Online',
                      'wifi',
                      isOnlineMode,
                      () => onToggleMode(),
                    ),
                    _buildModeButton(
                      context,
                      'Nearby',
                      'location_on',
                      !isOnlineMode,
                      () => onToggleMode(),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 3.w),

              // Filter Button
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: onShowFilters,
                  icon: CustomIconWidget(
                    iconName: 'tune',
                    size: 24,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  tooltip: 'Filter Options',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton(
    BuildContext context,
    String label,
    String iconName,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: iconName,
              size: 16,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
            ),
            SizedBox(width: 1.w),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
