
// Enum classes for type safety
enum StudyTrack {
  class10('class_10', 'Class 10'),
  class11('class_11', 'Class 11'),
  class12('class_12', 'Class 12'),
  iitJeeMain('iit_jee_main', 'IIT-JEE Main'),
  iitJeeAdvanced('iit_jee_advanced', 'IIT-JEE Advanced'),
  neet('neet', 'NEET'),
  ugcNetPaper1('ugc_net_paper_1', 'UGC NET Paper 1'),
  ugcNetCS('ugc_net_cs', 'UGC NET CS'),
  ugcNetCommerce('ugc_net_commerce', 'UGC NET Commerce'),
  sscCgl('ssc_cgl', 'SSC CGL'),
  sscChsl('ssc_chsl', 'SSC CHSL'),
  engineeringFirstYear('engineering_first_year', 'Engineering 1st Year'),
  codingDsa('coding_dsa', 'Coding/DSA');

  const StudyTrack(this.value, this.displayName);
  final String value;
  final String displayName;

  static StudyTrack fromString(String value) {
    return StudyTrack.values.firstWhere(
      (track) => track.value == value,
      orElse: () => StudyTrack.class10,
    );
  }
}

enum StudyMode {
  oneOnOne('one_on_one', '1-on-1'),
  smallGroup('small_group', 'Small Group (3-5)'),
  silentCoStudy('silent_co_study', 'Silent Co-study'),
  problemSolving('problem_solving', 'Problem Solving');

  const StudyMode(this.value, this.displayName);
  final String value;
  final String displayName;

  static StudyMode fromString(String value) {
    return StudyMode.values.firstWhere(
      (mode) => mode.value == value,
      orElse: () => StudyMode.oneOnOne,
    );
  }
}

enum StudyIntent {
  quickDoubts('quick_doubts', 'Quick Doubts'),
  regularBuddy('regular_buddy', 'Regular Study Buddy'),
  mockTests('mock_tests', 'Mock Tests'),
  notesExchange('notes_exchange', 'Notes Exchange');

  const StudyIntent(this.value, this.displayName);
  final String value;
  final String displayName;

  static StudyIntent fromString(String value) {
    return StudyIntent.values.firstWhere(
      (intent) => intent.value == value,
      orElse: () => StudyIntent.regularBuddy,
    );
  }
}

enum StudyLanguage {
  english('english', 'English'),
  hindi('hindi', 'Hindi'),
  bengali('bengali', 'Bengali'),
  marathi('marathi', 'Marathi'),
  tamil('tamil', 'Tamil'),
  telugu('telugu', 'Telugu'),
  kannada('kannada', 'Kannada'),
  gujarati('gujarati', 'Gujarati'),
  urdu('urdu', 'Urdu');

  const StudyLanguage(this.value, this.displayName);
  final String value;
  final String displayName;

  static StudyLanguage fromString(String value) {
    return StudyLanguage.values.firstWhere(
      (lang) => lang.value == value,
      orElse: () => StudyLanguage.english,
    );
  }

  static List<StudyLanguage> fromStringList(List<String> values) {
    return values.map((value) => StudyLanguage.fromString(value)).toList();
  }
}

enum TimeSlot {
  earlyMorning('early_morning', 'Early Morning (5-8 AM)'),
  morning('morning', 'Morning (8-12 PM)'),
  afternoon('afternoon', 'Afternoon (12-5 PM)'),
  evening('evening', 'Evening (5-9 PM)'),
  lateNight('late_night', 'Late Night (9 PM+)');

  const TimeSlot(this.value, this.displayName);
  final String value;
  final String displayName;

  static TimeSlot fromString(String value) {
    return TimeSlot.values.firstWhere(
      (slot) => slot.value == value,
      orElse: () => TimeSlot.evening,
    );
  }

  static List<TimeSlot> fromStringList(List<String> values) {
    return values.map((value) => TimeSlot.fromString(value)).toList();
  }
}

enum AvailabilityDays {
  weekdaysOnly('weekdays_only', 'Weekdays Only'),
  weekendsOnly('weekends_only', 'Weekends Only'),
  both('both', 'Both');

  const AvailabilityDays(this.value, this.displayName);
  final String value;
  final String displayName;

  static AvailabilityDays fromString(String value) {
    return AvailabilityDays.values.firstWhere(
      (days) => days.value == value,
      orElse: () => AvailabilityDays.both,
    );
  }
}

enum MatchStatus {
  pending('pending', 'Pending'),
  accepted('accepted', 'Accepted'),
  expired('expired', 'Expired'),
  rejected('rejected', 'Rejected');

  const MatchStatus(this.value, this.displayName);
  final String value;
  final String displayName;

  static MatchStatus fromString(String value) {
    return MatchStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => MatchStatus.pending,
    );
  }
}

// Model classes
class StudyBuddyProfile {
  final String id;
  final String userId;
  final String? displayName;
  final bool isOnline;
  final StudyTrack? track;
  final List<String> subjects;
  final List<StudyLanguage> studyLanguages;
  final String? geohash;
  final double? lat;
  final double? lng;
  final String? avatarUrl;
  final List<String> preferredSubjects;
  final bool isLookingForMatch;
  final bool isAnonymous;
  final String? currentRoomId;
  final DateTime createdAt;
  final DateTime updatedAt;

  StudyBuddyProfile({
    required this.id,
    required this.userId,
    this.displayName,
    required this.isOnline,
    this.track,
    required this.subjects,
    required this.studyLanguages,
    this.geohash,
    this.lat,
    this.lng,
    this.avatarUrl,
    required this.preferredSubjects,
    required this.isLookingForMatch,
    required this.isAnonymous,
    this.currentRoomId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StudyBuddyProfile.fromMap(Map<String, dynamic> map) {
    return StudyBuddyProfile(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      displayName: map['display_name'],
      isOnline: map['is_online'] ?? false,
      track: map['track'] != null ? StudyTrack.fromString(map['track']) : null,
      subjects: List<String>.from(map['subjects'] ?? []),
      studyLanguages: map['study_languages'] != null
          ? StudyLanguage.fromStringList(
              List<String>.from(map['study_languages']))
          : [],
      geohash: map['geohash'],
      lat: map['lat']?.toDouble(),
      lng: map['lng']?.toDouble(),
      avatarUrl: map['avatar_url'],
      preferredSubjects: List<String>.from(map['preferred_subjects'] ?? []),
      isLookingForMatch: map['is_looking_for_match'] ?? false,
      isAnonymous: map['is_anonymous'] ?? true,
      currentRoomId: map['current_room_id'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'display_name': displayName,
      'is_online': isOnline,
      'track': track?.value,
      'subjects': subjects,
      'study_languages': studyLanguages.map((lang) => lang.value).toList(),
      'geohash': geohash,
      'lat': lat,
      'lng': lng,
      'avatar_url': avatarUrl,
      'preferred_subjects': preferredSubjects,
      'is_looking_for_match': isLookingForMatch,
      'is_anonymous': isAnonymous,
      'current_room_id': currentRoomId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class UserPreferences {
  final String id;
  final String userId;
  final StudyMode studyMode;
  final StudyIntent intent;
  final List<StudyLanguage> languages;
  final AvailabilityDays days;
  final List<TimeSlot> timeSlots;
  final bool onlineOnly;
  final int radiusKm;
  final int minCompatibility;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserPreferences({
    required this.id,
    required this.userId,
    required this.studyMode,
    required this.intent,
    required this.languages,
    required this.days,
    required this.timeSlots,
    required this.onlineOnly,
    required this.radiusKm,
    required this.minCompatibility,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      studyMode: StudyMode.fromString(map['study_mode'] ?? 'one_on_one'),
      intent: StudyIntent.fromString(map['intent'] ?? 'regular_buddy'),
      languages: map['languages'] != null
          ? StudyLanguage.fromStringList(List<String>.from(map['languages']))
          : [],
      days: AvailabilityDays.fromString(map['days'] ?? 'both'),
      timeSlots: map['time_slots'] != null
          ? TimeSlot.fromStringList(List<String>.from(map['time_slots']))
          : [],
      onlineOnly: map['online_only'] ?? true,
      radiusKm: map['radius_km'] ?? 25,
      minCompatibility: map['min_compatibility'] ?? 50,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'study_mode': studyMode.value,
      'intent': intent.value,
      'languages': languages.map((lang) => lang.value).toList(),
      'days': days.value,
      'time_slots': timeSlots.map((slot) => slot.value).toList(),
      'online_only': onlineOnly,
      'radius_km': radiusKm,
      'min_compatibility': minCompatibility,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class StudyPoolMember {
  final String id;
  final String poolKey;
  final String userId;
  final StudyTrack track;
  final List<String> subjects;
  final List<StudyLanguage> languages;
  final String? geohash;
  final StudyIntent intent;
  final DateTime joinedAt;
  final DateTime expiresAt;
  final bool isActive;

  StudyPoolMember({
    required this.id,
    required this.poolKey,
    required this.userId,
    required this.track,
    required this.subjects,
    required this.languages,
    this.geohash,
    required this.intent,
    required this.joinedAt,
    required this.expiresAt,
    required this.isActive,
  });

  factory StudyPoolMember.fromMap(Map<String, dynamic> map) {
    return StudyPoolMember(
      id: map['id'] ?? '',
      poolKey: map['pool_key'] ?? '',
      userId: map['user_id'] ?? '',
      track: StudyTrack.fromString(map['track'] ?? 'class_10'),
      subjects: List<String>.from(map['subjects'] ?? []),
      languages: map['languages'] != null
          ? StudyLanguage.fromStringList(List<String>.from(map['languages']))
          : [],
      geohash: map['geohash'],
      intent: StudyIntent.fromString(map['intent'] ?? 'regular_buddy'),
      joinedAt: DateTime.parse(map['joined_at']),
      expiresAt: DateTime.parse(map['expires_at']),
      isActive: map['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pool_key': poolKey,
      'user_id': userId,
      'track': track.value,
      'subjects': subjects,
      'languages': languages.map((lang) => lang.value).toList(),
      'geohash': geohash,
      'intent': intent.value,
      'joined_at': joinedAt.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
      'is_active': isActive,
    };
  }
}

class StudyMatch {
  final String id;
  final String user1Id;
  final String user2Id;
  final int compatibilityScore;
  final MatchStatus status;
  final DateTime matchedAt;
  final DateTime expiresAt;
  final String? chatRoomId;

  StudyMatch({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.compatibilityScore,
    required this.status,
    required this.matchedAt,
    required this.expiresAt,
    this.chatRoomId,
  });

  factory StudyMatch.fromMap(Map<String, dynamic> map) {
    return StudyMatch(
      id: map['id'] ?? '',
      user1Id: map['user1_id'] ?? '',
      user2Id: map['user2_id'] ?? '',
      compatibilityScore: map['compatibility_score'] ?? 0,
      status: MatchStatus.fromString(map['status'] ?? 'pending'),
      matchedAt: DateTime.parse(map['matched_at']),
      expiresAt: DateTime.parse(map['expires_at']),
      chatRoomId: map['chat_room_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user1_id': user1Id,
      'user2_id': user2Id,
      'compatibility_score': compatibilityScore,
      'status': status.value,
      'matched_at': matchedAt.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
      'chat_room_id': chatRoomId,
    };
  }
}

class ChatRoom {
  final String id;
  final String user1Id;
  final String user2Id;
  final String subject;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? endedAt;

  ChatRoom({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.subject,
    required this.isActive,
    required this.createdAt,
    this.endedAt,
  });

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      id: map['id'] ?? '',
      user1Id: map['user1_id'] ?? '',
      user2Id: map['user2_id'] ?? '',
      subject: map['subject'] ?? '',
      isActive: map['is_active'] ?? true,
      createdAt: DateTime.parse(map['created_at']),
      endedAt: map['ended_at'] != null ? DateTime.parse(map['ended_at']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user1_id': user1Id,
      'user2_id': user2Id,
      'subject': subject,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'ended_at': endedAt?.toIso8601String(),
    };
  }
}

class Message {
  final String id;
  final String roomId;
  final String senderId;
  final String content;
  final String messageType;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.content,
    required this.messageType,
    required this.createdAt,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] ?? '',
      roomId: map['room_id'] ?? '',
      senderId: map['sender_id'] ?? '',
      content: map['content'] ?? '',
      messageType: map['message_type'] ?? 'text',
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'room_id': roomId,
      'sender_id': senderId,
      'content': content,
      'message_type': messageType,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

// Static data for subjects by track
class StudySubjects {
  static const Map<StudyTrack, List<String>> subjectsByTrack = {
    StudyTrack.class10: [
      'Maths',
      'Science',
      'English',
      'Social Science',
      'Hindi'
    ],
    StudyTrack.class11: [
      'Physics',
      'Chemistry',
      'Maths',
      'Biology',
      'Computer Science'
    ],
    StudyTrack.class12: [
      'Physics',
      'Chemistry',
      'Maths',
      'Biology',
      'Computer Science',
      'English'
    ],
    StudyTrack.iitJeeMain: ['Physics', 'Chemistry', 'Maths'],
    StudyTrack.iitJeeAdvanced: ['Physics', 'Chemistry', 'Maths'],
    StudyTrack.neet: ['Physics', 'Chemistry', 'Biology'],
    StudyTrack.ugcNetPaper1: [
      'Teaching Aptitude',
      'Research Aptitude',
      'Reasoning',
      'Comprehension',
      'ICT',
      'Higher Education'
    ],
    StudyTrack.ugcNetCS: [
      'Discrete Mathematics',
      'Data Structures & Algorithms',
      'Theory of Computation',
      'Database Management',
      'Operating Systems',
      'Computer Networks',
      'Artificial Intelligence'
    ],
    StudyTrack.ugcNetCommerce: [
      'Accounting',
      'Economics',
      'Business Studies',
      'Finance',
      'Marketing'
    ],
    StudyTrack.sscCgl: [
      'Quantitative Aptitude',
      'Reasoning',
      'English',
      'General Knowledge',
      'Current Affairs'
    ],
    StudyTrack.sscChsl: [
      'Quantitative Aptitude',
      'Reasoning',
      'English',
      'General Knowledge'
    ],
    StudyTrack.engineeringFirstYear: [
      'Mathematics I',
      'Physics',
      'Basic Electrical',
      'Programming in C',
      'Engineering Drawing'
    ],
    StudyTrack.codingDsa: [
      'Arrays',
      'Strings',
      'Trees',
      'Graphs',
      'Dynamic Programming',
      'Python',
      'Java',
      'C++',
      'Web Development'
    ],
  };

  static List<String> getSubjectsForTrack(StudyTrack track) {
    return subjectsByTrack[track] ?? [];
  }
}
