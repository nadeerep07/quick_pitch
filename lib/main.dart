import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/auth/repository/auth_repository.dart';
import 'package:quick_pitch_app/features/auth/viewmodel/bloc/auth_bloc.dart';
import 'package:quick_pitch_app/features/auth/viewmodel/cubit/button_visibility_state.dart';
import 'package:quick_pitch_app/features/onboarding/viewmodel/bloc/onboarding_bloc.dart';
import 'package:quick_pitch_app/features/splash/view/splash_screen.dart';
import 'package:quick_pitch_app/shared/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/firebase/firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => OnboardingBloc(),
        ),
        BlocProvider(create: (context) => ButtonVisibilityCubit() ),
      BlocProvider(
        create: (context) => AuthBloc(authRepository: authRepository)
         ,
      )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'QuickPitch',
        theme: AppTheme.lightTheme ,
        home: SplashScreen(),
      ),
    );
    
   
  }
}