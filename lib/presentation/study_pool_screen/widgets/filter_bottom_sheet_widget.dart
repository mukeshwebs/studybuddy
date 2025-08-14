import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersApplied;

  const FilterBottomSheetWidget({
    Key? key,
    required this.currentFilters,
    required this.onFiltersApplied,
  }) : super(key: key);

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, dynamic> _filters;

  final List<String> _subjects = [
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'English',
    'Hindi',
    'History',
    'Geography',
    'Economics',
    'Computer Science',
    'Data Structures',
    'Algorithms',
    'Programming',
    'Web Development'
  ];

  final List<String> _studyModes = [
    '1-on-1',
    'Small Group',
    'Silent Co-study',
    'Problem Solving',
    'Mock Tests',
    'Notes Exchange',
    'Quick Doubts'
  ];

  final List<String> _languages = [
    'English',
    'Hindi',
    'Bengali',
    'Marathi',
    'Tamil',
    'Telugu',
    'Kannada',
    'Gujarati',
    'Urdu'
  ];

  final List<String> _timeSlots = [
    'Early Morning (5-8 AM)',
    'Morning (8-12 PM)',
    'Afternoon (12-4 PM)',
    'Evening (4-8 PM)',
    'Night (8-11 PM)',
    'Late Night (11 PM-2 AM)'
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle
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

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Study Partners',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                TextButton(
                  onPressed: _clearAllFilters,
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Filter Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSubjectsFilter(),
                  SizedBox(height: 3.h),
                  _buildStudyModesFilter(),
                  SizedBox(height: 3.h),
                  _buildLanguagesFilter(),
                  SizedBox(height: 3.h),
                  _buildTimeSlotsFilter(),
                  SizedBox(height: 3.h),
                  _buildDistanceFilter(),
                  SizedBox(height: 3.h),
                  _buildCompatibilityFilter(),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),

          // Apply Button
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowColor,
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                  child: Text(
                    'Apply Filters',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectsFilter() {
    final selectedSubjects =
        (_filters['subjects'] as List?)?.cast<String>() ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subjects',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _subjects.map((subject) {
            final isSelected = selectedSubjects.contains(subject);
            return FilterChip(
              label: Text(subject),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedSubjects.add(subject);
                  } else {
                    selectedSubjects.remove(subject);
                  }
                  _filters['subjects'] = selectedSubjects;
                });
              },
              selectedColor: Theme.of(context).colorScheme.primaryContainer,
              checkmarkColor: Theme.of(context).colorScheme.primary,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStudyModesFilter() {
    final selectedModes =
        (_filters['studyModes'] as List?)?.cast<String>() ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Study Modes',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _studyModes.map((mode) {
            final isSelected = selectedModes.contains(mode);
            return FilterChip(
              label: Text(mode),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedModes.add(mode);
                  } else {
                    selectedModes.remove(mode);
                  }
                  _filters['studyModes'] = selectedModes;
                });
              },
              selectedColor: Theme.of(context).colorScheme.secondaryContainer,
              checkmarkColor: Theme.of(context).colorScheme.secondary,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLanguagesFilter() {
    final selectedLanguages =
        (_filters['languages'] as List?)?.cast<String>() ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Languages',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _languages.map((language) {
            final isSelected = selectedLanguages.contains(language);
            return FilterChip(
              label: Text(language),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedLanguages.add(language);
                  } else {
                    selectedLanguages.remove(language);
                  }
                  _filters['languages'] = selectedLanguages;
                });
              },
              selectedColor: Theme.of(context).colorScheme.tertiaryContainer,
              checkmarkColor: Theme.of(context).colorScheme.tertiary,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTimeSlotsFilter() {
    final selectedTimeSlots =
        (_filters['timeSlots'] as List?)?.cast<String>() ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Time Slots',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _timeSlots.map((timeSlot) {
            final isSelected = selectedTimeSlots.contains(timeSlot);
            return FilterChip(
              label: Text(timeSlot),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedTimeSlots.add(timeSlot);
                  } else {
                    selectedTimeSlots.remove(timeSlot);
                  }
                  _filters['timeSlots'] = selectedTimeSlots;
                });
              },
              selectedColor: Theme.of(context).colorScheme.primaryContainer,
              checkmarkColor: Theme.of(context).colorScheme.primary,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDistanceFilter() {
    final maxDistance = (_filters['maxDistance'] as double?) ?? 25.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Maximum Distance',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(
              '${maxDistance.round()} km',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Slider(
          value: maxDistance,
          min: 1.0,
          max: 50.0,
          divisions: 49,
          onChanged: (value) {
            setState(() {
              _filters['maxDistance'] = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildCompatibilityFilter() {
    final minCompatibility = (_filters['minCompatibility'] as double?) ?? 50.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Minimum Compatibility',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(
              '${minCompatibility.round()}%',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Slider(
          value: minCompatibility,
          min: 0.0,
          max: 100.0,
          divisions: 20,
          onChanged: (value) {
            setState(() {
              _filters['minCompatibility'] = value;
            });
          },
        ),
      ],
    );
  }

  void _clearAllFilters() {
    setState(() {
      _filters = {
        'subjects': <String>[],
        'studyModes': <String>[],
        'languages': <String>[],
        'timeSlots': <String>[],
        'maxDistance': 25.0,
        'minCompatibility': 50.0,
      };
    });
  }

  void _applyFilters() {
    widget.onFiltersApplied(_filters);
    Navigator.pop(context);
  }
}
