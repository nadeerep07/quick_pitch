import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/main/poster/view/nav_bar/components/drawer_content.dart';
import 'package:quick_pitch_app/features/user_profile/poster/viewmodel/cubit/poster_profile_cubit.dart';

class PosterCustomDrawer extends StatelessWidget {
  final VoidCallback onLogout;
  final VoidCallback onSwitchTap;

  const PosterCustomDrawer({
    super.key,
    required this.onLogout,
    required this.onSwitchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.78,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
      ),
      elevation: 10,
      child: BlocBuilder<PosterProfileCubit, PosterProfileState>(
        
        builder: (context, state) {
          final userData = state is PosterProfileLoaded ? state.posterProfile : null;
          return DrawerContent(
            userData: userData,
            onLogout: onLogout,
            onSwitchTap: onSwitchTap,
          );
        },
      ),
    );
  }
}
