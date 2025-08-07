import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/auth/view/screens/login_screen.dart';
import 'package:quick_pitch_app/features/auth/view/screens/signup_screen.dart';
import 'package:quick_pitch_app/features/main/fixer/view/bottom_nav/fixer_bottom_nav.dart';
import 'package:quick_pitch_app/features/main/poster/view/nav_bar/poster_bottom_nav.dart';
import 'package:quick_pitch_app/features/poster_task/model/task_post_model.dart';
import 'package:quick_pitch_app/features/profile_completion/view/complete_profile_screen.dart';
import 'package:quick_pitch_app/features/poster_task/view/task_post_screen.dart';
import 'package:quick_pitch_app/features/task_pitching/view/screen/task_pitching_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String posterBottomNav = '/poster-home';
  static const String fixerBottomNav = '/fixer-home';
  static const String completeProfile = '/complete-profile';
  static const String posterTask = '/poster-task';
  static const String taskPicting ='/task-pitch';


  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());

      case posterBottomNav:
        return MaterialPageRoute(builder: (_) => const PosterBottomNav());

      case fixerBottomNav:
        return MaterialPageRoute(builder: (_) => const FixerBottomNav());

      case completeProfile:
        final role = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => CompleteProfileScreen(role: role,isEditMode: false,),
        );
      case posterTask:
        return MaterialPageRoute(builder: (_) => const TaskPostScreen());
      case taskPicting:
       final taskData = settings.arguments as TaskPostModel;
      return MaterialPageRoute(builder: (_)=> TaskPitchingScreen(taskData: taskData,));


      default:
        return MaterialPageRoute(
          builder:
              (_) =>
                  const Scaffold(body: Center(child: Text("No route found"))),
        );
    }
  }
}
