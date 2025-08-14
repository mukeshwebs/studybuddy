import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AvatarSelectionWidget extends StatelessWidget {
  final String selectedAvatar;
  final Function(String) onAvatarSelected;

  const AvatarSelectionWidget({
    Key? key,
    required this.selectedAvatar,
    required this.onAvatarSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> avatarOptions = [
      'https://api.dicebear.com/7.x/avataaars/png?seed=Felix&backgroundColor=b6e3f4',
      'https://api.dicebear.com/7.x/avataaars/png?seed=Aneka&backgroundColor=c0aede',
      'https://api.dicebear.com/7.x/avataaars/png?seed=Garfield&backgroundColor=d1d4f9',
      'https://api.dicebear.com/7.x/avataaars/png?seed=Mittens&backgroundColor=ffd93d',
      'https://api.dicebear.com/7.x/avataaars/png?seed=Fluffy&backgroundColor=ffb3ba',
      'https://api.dicebear.com/7.x/avataaars/png?seed=Shadow&backgroundColor=bae1ff',
      'https://api.dicebear.com/7.x/avataaars/png?seed=Whiskers&backgroundColor=a8e6cf',
      'https://api.dicebear.com/7.x/avataaars/png?seed=Tiger&backgroundColor=ffc3a0',
    ];

    return Container(
      height: 40.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Text(
              'Choose Avatar',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(4.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 3.w,
                mainAxisSpacing: 2.h,
                childAspectRatio: 1.0,
              ),
              itemCount: avatarOptions.length,
              itemBuilder: (context, index) {
                final avatar = avatarOptions[index];
                final isSelected = avatar == selectedAvatar;

                return GestureDetector(
                  onTap: () => onAvatarSelected(avatar),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                        width: isSelected ? 3 : 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CustomImageWidget(
                        imageUrl: avatar,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
