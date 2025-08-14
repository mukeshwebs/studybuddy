import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../models/study_buddy_models.dart';
import '../../providers/study_buddy_providers.dart';
import './widgets/candidate_card_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/pool_header_widget.dart';

class StudyPoolScreen extends ConsumerStatefulWidget {
  const StudyPoolScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<StudyPoolScreen> createState() => _StudyPoolScreenState();
}

class _StudyPoolScreenState extends ConsumerState<StudyPoolScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _togglePool() {
    final poolState = ref.read(studyPoolProvider);

    if (poolState.isInPool) {
      ref.read(studyPoolProvider.notifier).leavePool();
    } else {
      ref.read(studyPoolProvider.notifier).joinPool();
    }
  }

  void _showFilters() {
    final currentFilters = ref.read(studyPoolProvider).filters;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: {
          'subjects': currentFilters.subjects,
          'languages':
              currentFilters.languages.map((l) => l.displayName).toList(),
          'studyModes':
              currentFilters.studyModes.map((m) => m.displayName).toList(),
          'timeSlots':
              currentFilters.timeSlots.map((t) => t.displayName).toList(),
          'maxDistance': currentFilters.maxDistance ?? 25.0,
          'minCompatibility': currentFilters.minCompatibility ?? 50.0,
          'onlineOnly': currentFilters.onlineOnly,
        },
        onFiltersApplied: (filters) {
          final newFilters = StudyPoolFilters(
            subjects: List<String>.from(filters['subjects'] ?? []),
            languages: (filters['languages'] as List<String>? ?? [])
                .map((name) => StudyLanguage.values.firstWhere(
                      (lang) => lang.displayName == name,
                      orElse: () => StudyLanguage.english,
                    ))
                .toList(),
            studyModes: (filters['studyModes'] as List<String>? ?? [])
                .map((name) => StudyMode.values.firstWhere(
                      (mode) => mode.displayName == name,
                      orElse: () => StudyMode.oneOnOne,
                    ))
                .toList(),
            timeSlots: (filters['timeSlots'] as List<String>? ?? [])
                .map((name) => TimeSlot.values.firstWhere(
                      (slot) => slot.displayName == name,
                      orElse: () => TimeSlot.evening,
                    ))
                .toList(),
            maxDistance: filters['maxDistance'] ?? 25.0,
            minCompatibility: filters['minCompatibility'] ?? 50.0,
            onlineOnly: filters['onlineOnly'] ?? true,
          );

          ref.read(studyPoolProvider.notifier).applyFilters(newFilters);
        },
      ),
    );
  }

  void _acceptCandidate(StudyBuddyProfile candidate) {
    HapticFeedback.lightImpact();

    ref.read(studyPoolProvider.notifier).createMatch(candidate);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'favorite',
              size: 20,
              color: AppTheme.successLight,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                  'Match request sent to ${candidate.displayName ?? 'Anonymous'}!'),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _rejectCandidate(StudyBuddyProfile candidate) {
    HapticFeedback.selectionClick();
    // Remove from candidates list is handled in the provider
    final currentCandidates =
        List<StudyBuddyProfile>.from(ref.read(studyPoolProvider).candidates);
    currentCandidates.removeWhere((c) => c.id == candidate.id);

    // This would ideally be handled through the provider
    // For now, we trigger a refresh
    ref.read(studyPoolProvider.notifier).loadCandidates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'StudyBuddy',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        centerTitle: true,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Study Pool'),
            Tab(text: 'Chats'),
            Tab(text: 'Profile'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStudyPoolTab(),
          _buildChatsTab(),
          _buildProfileTab(),
        ],
      ),
    );
  }

  Widget _buildStudyPoolTab() {
    final poolState = ref.watch(studyPoolProvider);
    final onlineCountAsync = ref.watch(onlineUsersCountProvider);

    return Column(
      children: [
        PoolHeaderWidget(
          isInPool: poolState.isInPool,
          onlineCount: onlineCountAsync.when(
            data: (count) => count,
            loading: () => 0,
            error: (_, __) => 0,
          ),
          onTogglePool: _togglePool,
          onShowFilters: _showFilters,
          isOnlineMode: poolState.filters.onlineOnly,
          onToggleMode: () {
            final currentFilters = poolState.filters;
            final newFilters = currentFilters.copyWith(
              onlineOnly: !currentFilters.onlineOnly,
            );
            ref.read(studyPoolProvider.notifier).applyFilters(newFilters);
          },
        ),
        Expanded(
          child: poolState.isInPool
              ? _buildCandidatesList(poolState)
              : _buildJoinPoolPrompt(),
        ),
      ],
    );
  }

  Widget _buildJoinPoolPrompt() {
    return EmptyStateWidget(
      title: 'Ready to Find Study Partners?',
      subtitle:
          'Join the study pool to discover compatible study buddies based on your subjects, preferences, and location.',
      iconName: 'people',
      buttonText: 'Join Study Pool',
      onButtonPressed: _togglePool,
    );
  }

  Widget _buildCandidatesList(StudyPoolState poolState) {
    if (poolState.isLoading || poolState.isLoadingCandidates) {
      return _buildLoadingState();
    }

    if (poolState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${poolState.error}'),
            SizedBox(height: 2.h),
            ElevatedButton(
              onPressed: () =>
                  ref.read(studyPoolProvider.notifier).loadCandidates(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (poolState.candidates.isEmpty) {
      return EmptyStateWidget(
        title: 'No Study Partners Found',
        subtitle:
            'Try adjusting your filters or check back later for new study buddies in your area.',
        iconName: 'search_off',
        buttonText: 'Adjust Filters',
        onButtonPressed: _showFilters,
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(studyPoolProvider.notifier).loadCandidates();
      },
      child: ListView.builder(
        padding: EdgeInsets.only(top: 2.h, bottom: 10.h),
        itemCount: poolState.candidates.length,
        itemBuilder: (context, index) {
          final candidate = poolState.candidates[index];
          // Convert StudyBuddyProfile to the expected Map format for compatibility
          final candidateMap = {
            'id': candidate.id,
            'name': candidate.displayName ?? 'Anonymous',
            'avatar': candidate.avatarUrl ?? '',
            'track': candidate.track?.displayName ?? '',
            'subjects': candidate.subjects,
            'studyModes': ['1-on-1'], // Default for now
            'languages':
                candidate.studyLanguages.map((l) => l.displayName).toList(),
            'studyIntent': 'Regular Buddy', // Default for now
            'availability': 'Flexible', // Default for now
            'timeSlots': ['Evening'], // Default for now
            'distance': 2.5, // Default for now
            'compatibilityScore': 85, // Would be calculated
            'isOnline': candidate.isOnline,
          };

          return CandidateCardWidget(
            candidate: candidateMap,
            onAccept: () => _acceptCandidate(candidate),
            onReject: () => _rejectCandidate(candidate),
            onTap: () => _showCandidateDetails(candidateMap),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 2.h),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          height: 25.h,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Container(
                height: 6.h,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 15.w,
                            height: 15.w,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .outline
                                  .withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 2.h,
                                  width: 40.w,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outline
                                        .withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Container(
                                  height: 1.5.h,
                                  width: 25.w,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outline
                                        .withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 5.h,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outline
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Container(
                              height: 5.h,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outline
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
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
        );
      },
    );
  }

  void _showCandidateDetails(Map<String, dynamic> candidate) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
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
                    // Header
                    Row(
                      children: [
                        Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                          child: CustomImageWidget(
                            imageUrl: candidate['avatar'] ?? '',
                            width: 20.w,
                            height: 20.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                candidate['name'] ?? 'Anonymous',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              Text(
                                candidate['track'] ?? 'General',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                              ),
                              SizedBox(height: 1.h),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: _getScoreColor(
                                      candidate['compatibilityScore'] ?? 0),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${candidate['compatibilityScore']}% Match',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 4.h),

                    // Details
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailSection(
                                'Subjects',
                                (candidate['subjects'] as List?)?.join(', ') ??
                                    ''),
                            _buildDetailSection(
                                'Study Modes',
                                (candidate['studyModes'] as List?)
                                        ?.join(', ') ??
                                    ''),
                            _buildDetailSection(
                                'Languages',
                                (candidate['languages'] as List?)?.join(', ') ??
                                    ''),
                            _buildDetailSection(
                                'Study Intent', candidate['studyIntent'] ?? ''),
                            _buildDetailSection('Availability',
                                candidate['availability'] ?? ''),
                            _buildDetailSection(
                                'Time Slots',
                                (candidate['timeSlots'] as List?)?.join(', ') ??
                                    ''),
                            _buildDetailSection(
                                'Distance', '${candidate['distance']} km away'),
                          ],
                        ),
                      ),
                    ),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              // Convert back to StudyBuddyProfile for rejection
                              final candidateProfile = ref
                                  .read(studyPoolProvider)
                                  .candidates
                                  .firstWhere((c) => c.id == candidate['id']);
                              _rejectCandidate(candidateProfile);
                            },
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
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              // Convert back to StudyBuddyProfile for acceptance
                              final candidateProfile = ref
                                  .read(studyPoolProvider)
                                  .candidates
                                  .firstWhere((c) => c.id == candidate['id']);
                              _acceptCandidate(candidateProfile);
                            },
                            icon: CustomIconWidget(
                              iconName: 'favorite',
                              size: 18,
                              color: Colors.white,
                            ),
                            label: const Text('Connect'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                            ),
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

  Widget _buildDetailSection(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            content.isNotEmpty ? content : 'Not specified',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: content.isNotEmpty
                      ? Theme.of(context).colorScheme.onSurface
                      : Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return AppTheme.successLight;
    if (score >= 60) return AppTheme.warningLight;
    return AppTheme.errorLight;
  }

  Widget _buildChatsTab() {
    final chatRoomsAsync = ref.watch(chatRoomsProvider);

    return chatRoomsAsync.when(
      data: (chatRooms) {
        if (chatRooms.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'chat',
                  size: 20.w,
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.6),
                ),
                SizedBox(height: 2.h),
                Text(
                  'No Active Chats',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Start connecting with study partners to begin chatting',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                      ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 3.h),
                ElevatedButton(
                  onPressed: () {
                    _tabController.animateTo(0);
                  },
                  child: const Text('Find Study Partners'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: chatRooms.length,
          itemBuilder: (context, index) {
            final chatRoom = chatRooms[index];
            return ListTile(
              leading: CircleAvatar(
                child: Text(chatRoom.subject[0].toUpperCase()),
              ),
              title: Text('Study Chat'),
              subtitle: Text('Subject: ${chatRoom.subject}'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/individual-chat-screen',
                  arguments: chatRoom.id,
                );
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $error'),
            ElevatedButton(
              onPressed: () => ref.refresh(chatRoomsProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    final profileAsync = ref.watch(profileProvider);

    return profileAsync.when(
      data: (profile) {
        if (profile == null || profile.isAnonymous) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: CustomIconWidget(
                    iconName: 'person',
                    size: 15.w,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  profile?.displayName ?? 'Anonymous User',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Complete your profile setup to get better matches',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                      ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4.h),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/onboarding-setup-screen');
                  },
                  icon: CustomIconWidget(
                    iconName: 'settings',
                    size: 18,
                    color: Colors.white,
                  ),
                  label: const Text('Setup Profile'),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              // Profile Header
              Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: profile.avatarUrl != null
                    ? CustomImageWidget(
                        imageUrl: profile.avatarUrl!,
                        width: 30.w,
                        height: 30.w,
                        fit: BoxFit.cover,
                      )
                    : CustomIconWidget(
                        iconName: 'person',
                        size: 15.w,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
              ),
              SizedBox(height: 2.h),
              Text(
                profile.displayName ?? 'Anonymous',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                profile.track?.displayName ?? 'No track selected',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                    ),
              ),
              SizedBox(height: 3.h),

              // Profile Details
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileSection(
                        'Subjects',
                        profile.subjects.join(', '),
                      ),
                      _buildProfileSection(
                        'Languages',
                        profile.studyLanguages
                            .map((l) => l.displayName)
                            .join(', '),
                      ),
                      _buildProfileSection(
                        'Status',
                        profile.isLookingForMatch
                            ? 'Looking for matches'
                            : 'Not looking for matches',
                      ),
                      _buildProfileSection(
                        'Online Status',
                        profile.isOnline ? 'Online' : 'Offline',
                      ),
                    ],
                  ),
                ),
              ),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, '/profile-settings-screen');
                      },
                      icon: CustomIconWidget(
                        iconName: 'settings',
                        size: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      label: const Text('Settings'),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, '/onboarding-setup-screen');
                      },
                      icon: CustomIconWidget(
                        iconName: 'edit',
                        size: 18,
                        color: Colors.white,
                      ),
                      label: const Text('Edit Profile'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error loading profile: $error'),
            ElevatedButton(
              onPressed: () => ref.read(profileProvider.notifier).refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            content.isNotEmpty ? content : 'Not specified',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: content.isNotEmpty
                      ? Theme.of(context).colorScheme.onSurface
                      : Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                ),
          ),
        ],
      ),
    );
  }
}
