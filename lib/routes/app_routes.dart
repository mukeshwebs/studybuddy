import 'package:flutter/material.dart';
import '../presentation/profile_settings_screen/profile_settings_screen.dart';
import '../presentation/authentication_screen/authentication_screen.dart';
import '../presentation/individual_chat_screen/individual_chat_screen.dart';
import '../presentation/chat_list_screen/chat_list_screen.dart';
import '../presentation/onboarding_setup_screen/onboarding_setup_screen.dart';
import '../presentation/study_pool_screen/study_pool_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String profileSettings = '/profile-settings-screen';
  static const String authentication = '/authentication-screen';
  static const String individualChat = '/individual-chat-screen';
  static const String chatList = '/chat-list-screen';
  static const String onboardingSetup = '/onboarding-setup-screen';
  static const String studyPool = '/study-pool-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const OnboardingSetupScreen(),
    profileSettings: (context) => const ProfileSettingsScreen(),
    authentication: (context) => const AuthenticationScreen(),
    individualChat: (context) => const IndividualChatScreen(),
    chatList: (context) => const ChatListScreen(),
    onboardingSetup: (context) => const OnboardingSetupScreen(),
    studyPool: (context) => const StudyPoolScreen(),
    // TODO: Add your other routes here
  };
}
