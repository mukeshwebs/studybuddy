import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/study_buddy_models.dart';
import '../services/study_buddy_service.dart';
import '../services/supabase_service.dart';

// Auth State Provider
final authStateProvider = StreamProvider<AuthState>((ref) {
  return SupabaseService.instance.client.auth.onAuthStateChange;
});

final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.whenData((state) => state.session?.user).value;
});

// Profile State Notifier
class ProfileNotifier extends AsyncNotifier<StudyBuddyProfile?> {
  final _service = StudyBuddyService.instance;

  @override
  Future<StudyBuddyProfile?> build() async {
    return await _loadProfile();
  }

  Future<StudyBuddyProfile?> _loadProfile() async {
    try {
      final profile = await _service.getCurrentUserProfile();
      return profile;
    } catch (e, stack) {
      throw e;
    }
  }

  Future<void> createOrUpdateProfile({
    required String displayName,
    required StudyTrack track,
    required List<String> subjects,
    required List<StudyLanguage> studyLanguages,
    String? avatarUrl,
    double? lat,
    double? lng,
    String? geohash,
  }) async {
    state = const AsyncValue.loading();
    try {
      final profile = await _service.createOrUpdateProfile(
        displayName: displayName,
        track: track,
        subjects: subjects,
        studyLanguages: studyLanguages,
        avatarUrl: avatarUrl,
        lat: lat,
        lng: lng,
        geohash: geohash,
      );
      state = AsyncValue.data(profile);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateOnlineStatus(bool isOnline) async {
    await _service.updateOnlineStatus(isOnline);
    ref.invalidateSelf();
  }

  Future<void> updateMatchingStatus(bool isLookingForMatch) async {
    await _service.updateMatchingStatus(isLookingForMatch);
    ref.invalidateSelf();
  }

  void refresh() => ref.invalidateSelf();
}

final profileProvider = AsyncNotifierProvider<ProfileNotifier, StudyBuddyProfile?>(
  () => ProfileNotifier(),
);

// Preferences State Notifier
class PreferencesNotifier extends AsyncNotifier<UserPreferences?> {
  final _service = StudyBuddyService.instance;

  @override
  Future<UserPreferences?> build() async {
    return await _loadPreferences();
  }

  Future<UserPreferences?> _loadPreferences() async {
    try {
      final preferences = await _service.getUserPreferences();
      return preferences;
    } catch (e, stack) {
      throw e;
    }
  }

  Future<void> createOrUpdatePreferences({
    required StudyMode studyMode,
    required StudyIntent intent,
    required List<StudyLanguage> languages,
    required AvailabilityDays days,
    required List<TimeSlot> timeSlots,
    required bool onlineOnly,
    required int radiusKm,
    required int minCompatibility,
  }) async {
    state = const AsyncValue.loading();
    try {
      final preferences = await _service.createOrUpdatePreferences(
        studyMode: studyMode,
        intent: intent,
        languages: languages,
        days: days,
        timeSlots: timeSlots,
        onlineOnly: onlineOnly,
        radiusKm: radiusKm,
        minCompatibility: minCompatibility,
      );
      state = AsyncValue.data(preferences);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final preferencesProvider = AsyncNotifierProvider<PreferencesNotifier, UserPreferences?>(
  () => PreferencesNotifier(),
);

// Study Pool State Notifier
class StudyPoolNotifier extends Notifier<StudyPoolState> {
  final _service = StudyBuddyService.instance;

  @override
  StudyPoolState build() {
    return StudyPoolState.initial();
  }

  Future<void> joinPool() async {
    state = state.copyWith(isLoading: true);

    try {
      final success = await _service.joinStudyPool();
      if (success) {
        state = state.copyWith(
          isInPool: true,
          isLoading: false,
          error: null,
        );
        await loadCandidates();
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to join study pool',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> leavePool() async {
    state = state.copyWith(isLoading: true);

    try {
      final success = await _service.leaveStudyPool();
      if (success) {
        state = state.copyWith(
          isInPool: false,
          isLoading: false,
          candidates: [],
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to leave study pool',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadCandidates({
    List<String>? subjectFilter,
    List<StudyLanguage>? languageFilter,
    StudyMode? modeFilter,
    int? maxDistance,
    int? minCompatibility,
  }) async {
    state = state.copyWith(isLoadingCandidates: true);

    try {
      final candidates = await _service.getPoolCandidates(
        subjectFilter: subjectFilter,
        languageFilter: languageFilter,
        modeFilter: modeFilter,
        maxDistance: maxDistance,
        minCompatibility: minCompatibility,
      );

      state = state.copyWith(
        candidates: candidates,
        isLoadingCandidates: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingCandidates: false,
        error: e.toString(),
      );
    }
  }

  Future<void> createMatch(StudyBuddyProfile candidate) async {
    try {
      final compatibilityScore = await _service.calculateCompatibilityScore(
        // You'd need current user profile here
        candidate, // Placeholder
        candidate,
      );

      await _service.createMatch(candidate.userId, compatibilityScore);

      // Remove candidate from list
      final updatedCandidates = List<StudyBuddyProfile>.from(state.candidates);
      updatedCandidates.removeWhere((c) => c.id == candidate.id);

      state = state.copyWith(candidates: updatedCandidates);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void applyFilters(StudyPoolFilters filters) {
    state = state.copyWith(filters: filters);
    loadCandidates(
      subjectFilter: filters.subjects,
      languageFilter: filters.languages,
      maxDistance: filters.maxDistance?.toInt(),
      minCompatibility: filters.minCompatibility?.toInt(),
    );
  }
}

// Study Pool State
class StudyPoolState {
  final bool isInPool;
  final bool isLoading;
  final bool isLoadingCandidates;
  final List<StudyBuddyProfile> candidates;
  final StudyPoolFilters filters;
  final String? error;

  StudyPoolState({
    required this.isInPool,
    required this.isLoading,
    required this.isLoadingCandidates,
    required this.candidates,
    required this.filters,
    this.error,
  });

  factory StudyPoolState.initial() {
    return StudyPoolState(
      isInPool: false,
      isLoading: false,
      isLoadingCandidates: false,
      candidates: [],
      filters: StudyPoolFilters.initial(),
    );
  }

  StudyPoolState copyWith({
    bool? isInPool,
    bool? isLoading,
    bool? isLoadingCandidates,
    List<StudyBuddyProfile>? candidates,
    StudyPoolFilters? filters,
    String? error,
  }) {
    return StudyPoolState(
      isInPool: isInPool ?? this.isInPool,
      isLoading: isLoading ?? this.isLoading,
      isLoadingCandidates: isLoadingCandidates ?? this.isLoadingCandidates,
      candidates: candidates ?? this.candidates,
      filters: filters ?? this.filters,
      error: error ?? this.error,
    );
  }
}

// Filters class
class StudyPoolFilters {
  final List<String> subjects;
  final List<StudyLanguage> languages;
  final List<StudyMode> studyModes;
  final List<TimeSlot> timeSlots;
  final double? maxDistance;
  final double? minCompatibility;
  final bool onlineOnly;

  StudyPoolFilters({
    required this.subjects,
    required this.languages,
    required this.studyModes,
    required this.timeSlots,
    this.maxDistance,
    this.minCompatibility,
    required this.onlineOnly,
  });

  factory StudyPoolFilters.initial() {
    return StudyPoolFilters(
      subjects: [],
      languages: [],
      studyModes: [],
      timeSlots: [],
      maxDistance: 25.0,
      minCompatibility: 50.0,
      onlineOnly: true,
    );
  }

  StudyPoolFilters copyWith({
    List<String>? subjects,
    List<StudyLanguage>? languages,
    List<StudyMode>? studyModes,
    List<TimeSlot>? timeSlots,
    double? maxDistance,
    double? minCompatibility,
    bool? onlineOnly,
  }) {
    return StudyPoolFilters(
      subjects: subjects ?? this.subjects,
      languages: languages ?? this.languages,
      studyModes: studyModes ?? this.studyModes,
      timeSlots: timeSlots ?? this.timeSlots,
      maxDistance: maxDistance ?? this.maxDistance,
      minCompatibility: minCompatibility ?? this.minCompatibility,
      onlineOnly: onlineOnly ?? this.onlineOnly,
    );
  }
}

final studyPoolProvider = NotifierProvider<StudyPoolNotifier, StudyPoolState>(
  () => StudyPoolNotifier(),
);

// Matches Provider
final matchesProvider = FutureProvider<List<StudyMatch>>((ref) async {
  return StudyBuddyService.instance.getUserMatches();
});

// Chat Rooms Provider
final chatRoomsProvider = FutureProvider<List<ChatRoom>>((ref) async {
  return StudyBuddyService.instance.getUserChatRooms();
});

// Chat Messages Provider
final chatMessagesProvider =
    FutureProvider.family<List<Message>, String>((ref, roomId) async {
  return StudyBuddyService.instance.getChatMessages(roomId);
});

// Online Users Count Provider
final onlineUsersCountProvider = FutureProvider<int>((ref) async {
  return StudyBuddyService.instance.getOnlineUsersCount();
});