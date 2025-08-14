import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../models/study_buddy_models.dart';
import '../../../widgets/custom_icon_widget.dart';

class StudyPreferencesBottomSheet extends StatefulWidget {
  final StudyMode studyMode;
  final StudyIntent studyIntent;
  final AvailabilityDays availabilityDays;
  final List<TimeSlot> selectedTimeSlots;
  final bool onlineOnly;
  final int radiusKm;
  final int minCompatibility;
  final Function({
    StudyMode? studyMode,
    StudyIntent? studyIntent,
    AvailabilityDays? days,
    List<TimeSlot>? timeSlots,
    bool? onlineOnly,
    int? radiusKm,
    int? minCompatibility,
  }) onPreferencesChanged;

  const StudyPreferencesBottomSheet({
    Key? key,
    required this.studyMode,
    required this.studyIntent,
    required this.availabilityDays,
    required this.selectedTimeSlots,
    required this.onlineOnly,
    required this.radiusKm,
    required this.minCompatibility,
    required this.onPreferencesChanged,
  }) : super(key: key);

  @override
  State<StudyPreferencesBottomSheet> createState() =>
      _StudyPreferencesBottomSheetState();
}

class _StudyPreferencesBottomSheetState
    extends State<StudyPreferencesBottomSheet> {
  late StudyMode _studyMode;
  late StudyIntent _studyIntent;
  late AvailabilityDays _availabilityDays;
  late List<TimeSlot> _selectedTimeSlots;
  late bool _onlineOnly;
  late int _radiusKm;
  late int _minCompatibility;

  @override
  void initState() {
    super.initState();
    _studyMode = widget.studyMode;
    _studyIntent = widget.studyIntent;
    _availabilityDays = widget.availabilityDays;
    _selectedTimeSlots = List.from(widget.selectedTimeSlots);
    _onlineOnly = widget.onlineOnly;
    _radiusKm = widget.radiusKm;
    _minCompatibility = widget.minCompatibility;
  }

  void _savePreferences() {
    widget.onPreferencesChanged(
      studyMode: _studyMode,
      studyIntent: _studyIntent,
      days: _availabilityDays,
      timeSlots: _selectedTimeSlots,
      onlineOnly: _onlineOnly,
      radiusKm: _radiusKm,
      minCompatibility: _minCompatibility,
    );
    Navigator.pop(context);
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
              children: [
                CustomIconWidget(
                  iconName: 'tune',
                  size: 24,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Study Preferences',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    size: 24,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    'Study Mode',
                    'How do you prefer to study?',
                    _buildStudyModeOptions(),
                  ),
                  _buildSection(
                    'Study Intent',
                    'What\'s your primary goal?',
                    _buildStudyIntentOptions(),
                  ),
                  _buildSection(
                    'Availability',
                    'When are you available?',
                    _buildAvailabilityOptions(),
                  ),
                  _buildSection(
                    'Time Slots',
                    'Select your preferred time slots',
                    _buildTimeSlotsOptions(),
                  ),
                  _buildSection(
                    'Location Preferences',
                    'Study mode and distance',
                    _buildLocationOptions(),
                  ),
                  _buildSection(
                    'Compatibility',
                    'Minimum match compatibility ($_minCompatibility%)',
                    _buildCompatibilitySlider(),
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),

          // Footer
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _savePreferences,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
                child: const Text('Save Preferences'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String subtitle, Widget content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
          ),
          SizedBox(height: 1.h),
          content,
        ],
      ),
    );
  }

  Widget _buildStudyModeOptions() {
    return Column(
      children: StudyMode.values.map((mode) {
        return RadioListTile<StudyMode>(
          title: Text(mode.displayName),
          value: mode,
          groupValue: _studyMode,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _studyMode = value;
              });
            }
          },
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  Widget _buildStudyIntentOptions() {
    return Column(
      children: StudyIntent.values.map((intent) {
        return RadioListTile<StudyIntent>(
          title: Text(intent.displayName),
          value: intent,
          groupValue: _studyIntent,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _studyIntent = value;
              });
            }
          },
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  Widget _buildAvailabilityOptions() {
    return Column(
      children: AvailabilityDays.values.map((days) {
        return RadioListTile<AvailabilityDays>(
          title: Text(days.displayName),
          value: days,
          groupValue: _availabilityDays,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _availabilityDays = value;
              });
            }
          },
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  Widget _buildTimeSlotsOptions() {
    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: TimeSlot.values.map((slot) {
        final isSelected = _selectedTimeSlots.contains(slot);
        return FilterChip(
          label: Text(slot.displayName),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedTimeSlots.add(slot);
              } else {
                if (_selectedTimeSlots.length > 1) {
                  _selectedTimeSlots.remove(slot);
                }
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildLocationOptions() {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Online Only'),
          subtitle: const Text('Only match with users for online study'),
          value: _onlineOnly,
          onChanged: (value) {
            setState(() {
              _onlineOnly = value;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
        if (!_onlineOnly) ...[
          SizedBox(height: 2.h),
          Text(
            'Search Radius: ${_radiusKm}km',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Slider(
            value: _radiusKm.toDouble(),
            min: 1,
            max: 100,
            divisions: 99,
            label: '${_radiusKm}km',
            onChanged: (value) {
              setState(() {
                _radiusKm = value.toInt();
              });
            },
          ),
        ],
      ],
    );
  }

  Widget _buildCompatibilitySlider() {
    return Column(
      children: [
        Slider(
          value: _minCompatibility.toDouble(),
          min: 0,
          max: 100,
          divisions: 20,
          label: '$_minCompatibility%',
          onChanged: (value) {
            setState(() {
              _minCompatibility = value.toInt();
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '0%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                  ),
            ),
            Text(
              '100%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
