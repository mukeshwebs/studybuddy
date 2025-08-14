import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../models/study_buddy_models.dart';
import '../../providers/study_buddy_providers.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/setup_summary_card.dart';
import './widgets/study_preferences_bottom_sheet.dart';
import './widgets/subject_chip.dart';
import './widgets/track_selection_card.dart';

class OnboardingSetupScreen extends ConsumerStatefulWidget {
  const OnboardingSetupScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<OnboardingSetupScreen> createState() =>
      _OnboardingSetupScreenState();
}

class _OnboardingSetupScreenState extends ConsumerState<OnboardingSetupScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();

  int _currentStep = 0;
  StudyTrack? _selectedTrack;
  List<String> _selectedSubjects = [];
  List<StudyLanguage> _selectedLanguages = [StudyLanguage.english];

  // Study preferences
  StudyMode _studyMode = StudyMode.oneOnOne;
  StudyIntent _studyIntent = StudyIntent.regularBuddy;
  AvailabilityDays _availabilityDays = AvailabilityDays.both;
  List<TimeSlot> _selectedTimeSlots = [TimeSlot.evening];
  bool _onlineOnly = true;
  int _radiusKm = 25;
  int _minCompatibility = 50;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkExistingProfile();
  }

  void _checkExistingProfile() async {
    final profile = await ref.read(profileProvider.notifier);
    // If user has existing profile, populate fields
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _completeSetup() async {
    if (_selectedTrack == null ||
        _selectedSubjects.length < 3 ||
        _nameController.text.trim().isEmpty) {
      _showSnackBar('Please complete all required fields', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create or update profile
      await ref.read(profileProvider.notifier).createOrUpdateProfile(
            displayName: _nameController.text.trim(),
            track: _selectedTrack!,
            subjects: _selectedSubjects,
            studyLanguages: _selectedLanguages,
            // Location would be added here if implemented
          );

      // Create or update preferences
      await ref.read(preferencesProvider.notifier).createOrUpdatePreferences(
          studyMode: _studyMode,
          intent: _studyIntent,
          languages: _selectedLanguages,
          days: _availabilityDays,
          timeSlots: _selectedTimeSlots,
          onlineOnly: _onlineOnly,
          radiusKm: _radiusKm,
          minCompatibility: _minCompatibility);

      _showSnackBar('Profile setup completed successfully!');

      // Navigate to main app
      Navigator.pushNamedAndRemoveUntil(
          context, '/study-pool-screen', (route) => false);
    } catch (e) {
      _showSnackBar('Setup failed: $e', isError: true);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primary));
  }

  void _showPreferencesSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => StudyPreferencesBottomSheet(
            studyMode: _studyMode,
            studyIntent: _studyIntent,
            availabilityDays: _availabilityDays,
            selectedTimeSlots: _selectedTimeSlots,
            onlineOnly: _onlineOnly,
            radiusKm: _radiusKm,
            minCompatibility: _minCompatibility,
            onPreferencesChanged: ({
              StudyMode? studyMode,
              StudyIntent? studyIntent,
              AvailabilityDays? days,
              List<TimeSlot>? timeSlots,
              bool? onlineOnly,
              int? radiusKm,
              int? minCompatibility,
            }) {
              setState(() {
                if (studyMode != null) _studyMode = studyMode;
                if (studyIntent != null) _studyIntent = studyIntent;
                if (days != null) _availabilityDays = days;
                if (timeSlots != null) _selectedTimeSlots = timeSlots;
                if (onlineOnly != null) _onlineOnly = onlineOnly;
                if (radiusKm != null) _radiusKm = radiusKm;
                if (minCompatibility != null)
                  _minCompatibility = minCompatibility;
              });
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
            title: Text('Profile Setup'),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: _currentStep > 0
                ? IconButton(
                    icon: CustomIconWidget(
                        iconName: 'arrow_back',
                        size: 24,
                        color: Theme.of(context).colorScheme.onSurface),
                    onPressed: _previousStep)
                : null),
        body: Column(children: [
          // Progress Indicator
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              child: ProgressIndicatorWidget(
                  currentStep: _currentStep, totalSteps: 4)),

          // Page Content
          Expanded(
              child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                _buildWelcomeStep(),
                _buildTrackSelectionStep(),
                _buildSubjectSelectionStep(),
                _buildSummaryStep(),
              ])),

          // Bottom Navigation
          Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5)),
                  ]),
              child: _buildBottomNavigation()),
        ]));
  }

  Widget _buildWelcomeStep() {
    return Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          CustomIconWidget(
              iconName: 'school',
              size: 25.w,
              color: Theme.of(context).colorScheme.primary),
          SizedBox(height: 4.h),
          Text('Welcome to StudyBuddy!',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.primary),
              textAlign: TextAlign.center),
          SizedBox(height: 2.h),
          Text('Let\'s set up your profile to find the perfect study partners',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
                  height: 1.5),
              textAlign: TextAlign.center),
          SizedBox(height: 4.h),
          TextField(
              controller: _nameController,
              decoration: InputDecoration(
                  labelText: 'Your Name *',
                  hintText: 'Enter your display name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  prefixIcon: CustomIconWidget(
                      iconName: 'person',
                      size: 20,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6))),
              textCapitalization: TextCapitalization.words),
        ]));
  }

  Widget _buildTrackSelectionStep() {
    return Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Select Your Study Track',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w600)),
          SizedBox(height: 1.h),
          Text('Choose the category that best matches your current studies',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7))),
          SizedBox(height: 3.h),
          Expanded(
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 3.w,
                      mainAxisSpacing: 2.h),
                  itemCount: StudyTrack.values.length,
                  itemBuilder: (context, index) {
                    final track = StudyTrack.values[index];
                    return TrackSelectionCard(
                        track: track,
                        isSelected: _selectedTrack == track,
                        onTap: () {
                          setState(() {
                            _selectedTrack = track;
                            _selectedSubjects =
                                []; // Reset subjects when track changes
                          });
                        });
                  })),
        ]));
  }

  Widget _buildSubjectSelectionStep() {
    final availableSubjects = _selectedTrack != null
        ? StudySubjects.getSubjectsForTrack(_selectedTrack!)
        : <String>[];

    return Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Choose Your Subjects',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w600)),
          SizedBox(height: 1.h),
          Text(
              'Select at least 3 subjects you want to study (${_selectedSubjects.length}/3 minimum)',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7))),
          SizedBox(height: 3.h),

          // Languages Selection
          Text('Preferred Languages',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          SizedBox(height: 1.h),
          Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: StudyLanguage.values.map((language) {
                final isSelected = _selectedLanguages.contains(language);
                return SubjectChip(
                    subject: language.toString().split('.').last,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          if (_selectedLanguages.length > 1) {
                            _selectedLanguages.remove(language);
                          }
                        } else {
                          _selectedLanguages.add(language);
                        }
                      });
                    });
              }).toList()),

          SizedBox(height: 3.h),

          Text('Study Subjects',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          SizedBox(height: 1.h),

          Expanded(
              child: availableSubjects.isEmpty
                  ? Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          CustomIconWidget(
                              iconName: 'warning',
                              size: 15.w,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.4)),
                          SizedBox(height: 2.h),
                          Text('Please select a study track first',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.6))),
                        ]))
                  : SingleChildScrollView(
                      child: Wrap(
                          spacing: 2.w,
                          runSpacing: 1.h,
                          children: availableSubjects.map((subject) {
                            final isSelected =
                                _selectedSubjects.contains(subject);
                            return SubjectChip(
                                subject: subject,
                                isSelected: isSelected,
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      _selectedSubjects.remove(subject);
                                    } else {
                                      _selectedSubjects.add(subject);
                                    }
                                  });
                                });
                          }).toList()))),
        ]));
  }

  Widget _buildSummaryStep() {
    return Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Setup Summary',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w600)),
          SizedBox(height: 1.h),
          Text('Review your profile information and study preferences',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7))),
          SizedBox(height: 3.h),
          Expanded(
              child: SingleChildScrollView(
                  child: Column(children: [
            SetupSummaryCard(
              setupData: {
                'name': _nameController.text.trim(),
                'track': _selectedTrack?.toString() ?? '',
                'subjects': _selectedSubjects,
                'languages': _selectedLanguages,
              },
            ),
            SizedBox(height: 2.h),
            SetupSummaryCard(
              setupData: {
                'studyMode': _studyMode.toString(),
                'intent': _studyIntent.toString(),
                'days': _availabilityDays.toString(),
                'timeSlots': _selectedTimeSlots,
                'onlineOnly': _onlineOnly,
                'radiusKm': _radiusKm,
                'minCompatibility': _minCompatibility,
              },
            ),
            SizedBox(height: 2.h),
            SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                    onPressed: _showPreferencesSheet,
                    icon: CustomIconWidget(
                        iconName: 'tune',
                        size: 20,
                        color: Theme.of(context).colorScheme.primary),
                    label: const Text('Customize Preferences'),
                    style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 2.h)))),
          ]))),
        ]));
  }

  Widget _buildBottomNavigation() {
    final canProceed = _getCanProceed();

    if (_currentStep == 3) {
      return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              onPressed: canProceed && !_isLoading ? _completeSetup : null,
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h)),
              child: _isLoading
                  ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white)),
                      SizedBox(width: 2.w),
                      Text('Setting up...'),
                    ])
                  : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('Complete Setup'),
                      SizedBox(width: 2.w),
                      CustomIconWidget(
                          iconName: 'check', size: 20, color: Colors.white),
                    ])));
    }

    return Row(children: [
      if (_currentStep > 0)
        Expanded(
            child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h)),
                child: const Text('Previous'))),
      if (_currentStep > 0) SizedBox(width: 4.w),
      Expanded(
          child: ElevatedButton(
              onPressed: canProceed ? _nextStep : null,
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h)),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(_currentStep == 0 ? 'Get Started' : 'Next'),
                SizedBox(width: 2.w),
                CustomIconWidget(
                    iconName: 'arrow_forward', size: 20, color: Colors.white),
              ]))),
    ]);
  }

  bool _getCanProceed() {
    switch (_currentStep) {
      case 0:
        return _nameController.text.trim().isNotEmpty;
      case 1:
        return _selectedTrack != null;
      case 2:
        return _selectedSubjects.length >= 3 && _selectedLanguages.isNotEmpty;
      case 3:
        return _selectedTrack != null &&
            _selectedSubjects.length >= 3 &&
            _nameController.text.trim().isNotEmpty &&
            _selectedLanguages.isNotEmpty;
      default:
        return false;
    }
  }
}