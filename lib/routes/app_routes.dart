import 'package:flutter/material.dart';
import '../presentation/main_dashboard/main_dashboard.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/ai_companion_chat/ai_companion_chat.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/professional_counselor_booking/professional_counselor_booking.dart';
import '../presentation/peer_support_chat_lounge/peer_support_chat_lounge.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String mainDashboard = '/main-dashboard';
  static const String splash = '/splash-screen';
  static const String aiCompanionChat = '/ai-companion-chat';
  static const String onboardingFlow = '/onboarding-flow';
  static const String professionalCounselorBooking =
      '/professional-counselor-booking';
  static const String peerSupportChatLounge = '/peer-support-chat-lounge';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    mainDashboard: (context) => const MainDashboard(),
    splash: (context) => const SplashScreen(),
    aiCompanionChat: (context) => const AiCompanionChat(),
    onboardingFlow: (context) => const OnboardingFlow(),
    professionalCounselorBooking: (context) =>
        const ProfessionalCounselorBooking(),
    peerSupportChatLounge: (context) => const PeerSupportChatLounge(),
    // TODO: Add your other routes here
  };
}
