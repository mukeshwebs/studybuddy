import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/study_buddy_models.dart';
import './supabase_service.dart';

class StudyBuddyService {
  static StudyBuddyService? _instance;
  static StudyBuddyService get instance => _instance ??= StudyBuddyService._();

  StudyBuddyService._();

  SupabaseClient get _client => SupabaseService.instance.client;

  // Profile Management
  Future<StudyBuddyProfile?> getCurrentUserProfile() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return null;

      final response = await _client
          .from('profiles')
          .select()
          .eq('user_id', user.id)
          .single();

      return StudyBuddyProfile.fromMap(response);
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  Future<StudyBuddyProfile?> createOrUpdateProfile({
    required String displayName,
    required StudyTrack track,
    required List<String> subjects,
    required List<StudyLanguage> studyLanguages,
    String? avatarUrl,
    double? lat,
    double? lng,
    String? geohash,
  }) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final profileData = {
        'user_id': user.id,
        'display_name': displayName,
        'track': track.value,
        'subjects': subjects,
        'study_languages': studyLanguages.map((lang) => lang.value).toList(),
        'avatar_url': avatarUrl,
        'lat': lat,
        'lng': lng,
        'geohash': geohash,
        'is_online': true,
        'is_looking_for_match': false,
        'is_anonymous': false,
        'preferred_subjects': subjects,
      };

      final response =
          await _client.from('profiles').upsert(profileData).select().single();

      return StudyBuddyProfile.fromMap(response);
    } catch (e) {
      print('Error creating/updating profile: $e');
      rethrow;
    }
  }

  Future<void> updateOnlineStatus(bool isOnline) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return;

      await _client
          .from('profiles')
          .update({'is_online': isOnline}).eq('user_id', user.id);
    } catch (e) {
      print('Error updating online status: $e');
    }
  }

  Future<void> updateMatchingStatus(bool isLookingForMatch) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return;

      await _client.from('profiles').update(
          {'is_looking_for_match': isLookingForMatch}).eq('user_id', user.id);
    } catch (e) {
      print('Error updating matching status: $e');
    }
  }

  // User Preferences Management
  Future<UserPreferences?> getUserPreferences() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return null;

      final response = await _client
          .from('user_preferences')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      if (response == null) return null;
      return UserPreferences.fromMap(response);
    } catch (e) {
      print('Error fetching user preferences: $e');
      return null;
    }
  }

  Future<UserPreferences> createOrUpdatePreferences({
    required StudyMode studyMode,
    required StudyIntent intent,
    required List<StudyLanguage> languages,
    required AvailabilityDays days,
    required List<TimeSlot> timeSlots,
    required bool onlineOnly,
    required int radiusKm,
    required int minCompatibility,
  }) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final preferencesData = {
        'user_id': user.id,
        'study_mode': studyMode.value,
        'intent': intent.value,
        'languages': languages.map((lang) => lang.value).toList(),
        'days': days.value,
        'time_slots': timeSlots.map((slot) => slot.value).toList(),
        'online_only': onlineOnly,
        'radius_km': radiusKm,
        'min_compatibility': minCompatibility,
      };

      final response = await _client
          .from('user_preferences')
          .upsert(preferencesData)
          .select()
          .single();

      return UserPreferences.fromMap(response);
    } catch (e) {
      print('Error creating/updating preferences: $e');
      rethrow;
    }
  }

  // Study Pool Management
  Future<bool> joinStudyPool() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final profile = await getCurrentUserProfile();
      if (profile == null || profile.track == null) {
        throw Exception('Profile not complete');
      }

      // Generate pool key
      final primaryLanguage = profile.studyLanguages.isNotEmpty
          ? profile.studyLanguages.first.value
          : 'english';

      final poolKey =
          '${profile.track!.value}_${profile.geohash ?? 'global'}_$primaryLanguage';

      final poolData = {
        'pool_key': poolKey,
        'user_id': user.id,
        'track': profile.track!.value,
        'subjects': profile.subjects,
        'languages': profile.studyLanguages.map((lang) => lang.value).toList(),
        'geohash': profile.geohash,
        'intent': 'regular_buddy', // Default intent
        'is_active': true,
      };

      await _client.from('study_pools').insert(poolData);
      await updateMatchingStatus(true);

      return true;
    } catch (e) {
      print('Error joining study pool: $e');
      return false;
    }
  }

  Future<bool> leaveStudyPool() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return false;

      await _client.from('study_pools').delete().eq('user_id', user.id);

      await updateMatchingStatus(false);
      return true;
    } catch (e) {
      print('Error leaving study pool: $e');
      return false;
    }
  }

  Future<List<StudyBuddyProfile>> getPoolCandidates({
    List<String>? subjectFilter,
    List<StudyLanguage>? languageFilter,
    StudyMode? modeFilter,
    int? maxDistance,
    int? minCompatibility,
  }) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return [];

      final currentProfile = await getCurrentUserProfile();
      if (currentProfile == null) return [];

      // Get active pool members excluding current user
      var query = _client
          .from('study_pools')
          .select('*, profiles!inner(*)')
          .eq('is_active', true)
          .neq('user_id', user.id)
          .gte('expires_at', DateTime.now().toIso8601String());

      // Apply track filter (same track only)
      if (currentProfile.track != null) {
        query = query.eq('track', currentProfile.track!.value);
      }

      final response = await query;

      List<StudyBuddyProfile> candidates = [];

      for (final item in response) {
        final profileData = item['profiles'];
        if (profileData != null) {
          final candidate = StudyBuddyProfile.fromMap(profileData);

          // Calculate compatibility score
          final compatibilityScore =
              await calculateCompatibilityScore(currentProfile, candidate);

          // Apply filters
          if (minCompatibility != null &&
              compatibilityScore < minCompatibility) {
            continue;
          }

          if (subjectFilter != null && subjectFilter.isNotEmpty) {
            final hasCommonSubject = candidate.subjects
                .any((subject) => subjectFilter.contains(subject));
            if (!hasCommonSubject) continue;
          }

          if (languageFilter != null && languageFilter.isNotEmpty) {
            final hasCommonLanguage = candidate.studyLanguages
                .any((lang) => languageFilter.contains(lang));
            if (!hasCommonLanguage) continue;
          }

          candidates.add(candidate);
        }
      }

      // Sort by compatibility score (highest first)
      candidates.sort((a, b) {
        // For now, return as-is. In a real implementation, you'd store/calculate scores
        return 0;
      });

      return candidates.take(20).toList(); // Limit to 20 candidates
    } catch (e) {
      print('Error fetching pool candidates: $e');
      return [];
    }
  }

  Future<int> calculateCompatibilityScore(
      StudyBuddyProfile user1, StudyBuddyProfile user2) async {
    try {
      if (user1.track == null || user2.track == null) return 0;

      final response = await _client.rpc('calculate_compatibility', params: {
        'user1_track': user1.track!.value,
        'user1_subjects': user1.subjects,
        'user1_languages': user1.studyLanguages.map((l) => l.value).toList(),
        'user2_track': user2.track!.value,
        'user2_subjects': user2.subjects,
        'user2_languages': user2.studyLanguages.map((l) => l.value).toList(),
      });

      return response ?? 0;
    } catch (e) {
      print('Error calculating compatibility: $e');
      return 0;
    }
  }

  // Matching System
  Future<StudyMatch?> createMatch(
      String otherUserId, int compatibilityScore) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Create chat room first
      final chatRoomData = {
        'user1_id': user.id,
        'user2_id': otherUserId,
        'subject': 'general', // Default subject
        'is_active': true,
      };

      final chatRoomResponse = await _client
          .from('chat_rooms')
          .insert(chatRoomData)
          .select()
          .single();

      // Create match
      final matchData = {
        'user1_id': user.id,
        'user2_id': otherUserId,
        'compatibility_score': compatibilityScore,
        'status': 'pending',
        'chat_room_id': chatRoomResponse['id'],
      };

      final response =
          await _client.from('matches').insert(matchData).select().single();

      return StudyMatch.fromMap(response);
    } catch (e) {
      print('Error creating match: $e');
      rethrow;
    }
  }

  Future<List<StudyMatch>> getUserMatches() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return [];

      final response = await _client
          .from('matches')
          .select()
          .or('user1_id.eq.${user.id},user2_id.eq.${user.id}')
          .order('matched_at', ascending: false);

      return response
          .map<StudyMatch>((match) => StudyMatch.fromMap(match))
          .toList();
    } catch (e) {
      print('Error fetching user matches: $e');
      return [];
    }
  }

  Future<bool> acceptMatch(String matchId) async {
    try {
      await _client
          .from('matches')
          .update({'status': 'accepted'}).eq('id', matchId);

      return true;
    } catch (e) {
      print('Error accepting match: $e');
      return false;
    }
  }

  Future<bool> rejectMatch(String matchId) async {
    try {
      await _client
          .from('matches')
          .update({'status': 'rejected'}).eq('id', matchId);

      return true;
    } catch (e) {
      print('Error rejecting match: $e');
      return false;
    }
  }

  // Chat Management
  Future<List<ChatRoom>> getUserChatRooms() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return [];

      final response = await _client
          .from('chat_rooms')
          .select()
          .or('user1_id.eq.${user.id},user2_id.eq.${user.id}')
          .eq('is_active', true)
          .order('created_at', ascending: false);

      return response.map<ChatRoom>((room) => ChatRoom.fromMap(room)).toList();
    } catch (e) {
      print('Error fetching chat rooms: $e');
      return [];
    }
  }

  Future<List<Message>> getChatMessages(String roomId, {int limit = 50}) async {
    try {
      final response = await _client
          .from('messages')
          .select()
          .eq('room_id', roomId)
          .order('created_at', ascending: false)
          .limit(limit);

      return response.map<Message>((msg) => Message.fromMap(msg)).toList();
    } catch (e) {
      print('Error fetching chat messages: $e');
      return [];
    }
  }

  Future<Message?> sendMessage(String roomId, String content,
      {String messageType = 'text'}) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final messageData = {
        'room_id': roomId,
        'sender_id': user.id,
        'content': content,
        'message_type': messageType,
      };

      final response =
          await _client.from('messages').insert(messageData).select().single();

      return Message.fromMap(response);
    } catch (e) {
      print('Error sending message: $e');
      rethrow;
    }
  }

  // Real-time subscriptions
  RealtimeChannel subscribeToMatches(Function(StudyMatch) onNewMatch) {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    return _client
        .channel('matches:${user.id}')
        .onPostgresChanges(
            event: PostgresChangeEvent.insert,
            schema: 'public',
            table: 'matches',
            callback: (payload) {
              final match = StudyMatch.fromMap(payload.newRecord);
              onNewMatch(match);
            })
        .subscribe();
  }

  RealtimeChannel subscribeToChat(
      String roomId, Function(Message) onNewMessage) {
    return _client
        .channel('chat:$roomId')
        .onPostgresChanges(
            event: PostgresChangeEvent.insert,
            schema: 'public',
            table: 'messages',
            filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'room_id',
                value: roomId),
            callback: (payload) {
              final message = Message.fromMap(payload.newRecord);
              onNewMessage(message);
                        })
        .subscribe();
  }

  // Utility methods
  Future<void> cleanupExpiredData() async {
    try {
      await _client.rpc('cleanup_expired_data');
    } catch (e) {
      print('Error cleaning up expired data: $e');
    }
  }

  Future<int> getOnlineUsersCount() async {
    try {
      final response =
          await _client.from('profiles').select().eq('is_online', true).count();

      return response.count ?? 0;
    } catch (e) {
      print('Error fetching online users count: $e');
      return 0;
    }
  }
}