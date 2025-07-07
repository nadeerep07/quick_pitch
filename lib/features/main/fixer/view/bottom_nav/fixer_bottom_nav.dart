import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/services/firebase/auth/auth_services.dart';
import 'package:quick_pitch_app/features/main/fixer/repository/fixer_repository.dart';
import 'package:quick_pitch_app/features/main/fixer/view/bottom_nav/components/fixer_bottom_nav_content.dart';
import 'package:quick_pitch_app/features/main/fixer/viewmodel/cubit/fixer_home_cubit.dart';

class FixerBottomNav extends StatelessWidget {
  const FixerBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FixerHomeCubit(FixerRepository())
        ..loadFixerHomeData(AuthServices().currentUser!.uid),
      child: const FixerBottomNavContent(),
    );
  }
}
