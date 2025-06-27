import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/auth/view/screens/login_screen.dart';
import 'package:quick_pitch_app/features/auth/view/screens/signup_screen.dart';
import 'package:quick_pitch_app/features/home/fixer/view/fixer_bottom_nav.dart';
import 'package:quick_pitch_app/features/home/poster/view/screens/poster_bottom_nav.dart';
import 'package:quick_pitch_app/features/profile_completion/view/complete_profile_screen.dart';


class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String posterHome = '/poster-home';
  static const String fixerHome = '/fixer-home';
  static const String completeProfile = '/complete-profile';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());

      case posterHome:
        return MaterialPageRoute(builder: (_) => const PosterBottomNav());

      case fixerHome:
        return MaterialPageRoute(builder: (_) => const FixerBottomNav());

      case completeProfile:
        final role = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => CompleteProfileScreen(role: role),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("No route found")),
          ),
        );
    }
  }
}
