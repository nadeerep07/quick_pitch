import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/routes/app_routes.dart';
import 'package:quick_pitch_app/core/services/firebase/auth/auth_services.dart';
import 'package:quick_pitch_app/features/earnings/view/screen/earning_screen.dart';
import 'package:quick_pitch_app/features/explore/fixer/view/screen/fixer_explore_screen.dart';
import 'package:quick_pitch_app/features/auth/view/components/custom_dialog.dart';
import 'package:quick_pitch_app/features/main/fixer/view/screens/fixer_home_screen.dart';
import 'package:quick_pitch_app/features/main/fixer/viewmodel/cubit/fixer_home_cubit.dart'
    show FixerHomeCubit, FixerHomeState, FixerHomeLoaded;
import 'package:quick_pitch_app/core/common/glass_morphic_bottom_nav_bar.dart';
import 'package:quick_pitch_app/features/main/fixer/view/bottom_nav/components/fixer_custom_drawer.dart';
import 'package:quick_pitch_app/features/requests_pitches/fixer/view/screen/fixer_request_screen.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/bottom_nav/cubit/drawer_state_cubit.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/bottom_nav/cubit/poster_bottom_nav_cubit.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/switch_role/cubit/role_switch_cubit.dart';
import 'package:quick_pitch_app/features/chat/view/screen/chat_list_screen.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/viewmodel/cubit/fixer_profile_cubit.dart';

class FixerBottomNavContent extends StatelessWidget {
  const FixerBottomNavContent({super.key});

  @override
  Widget build(BuildContext context)  {
    final scaffoldKey = GlobalKey<ScaffoldState>();
  final fixerId =  FirebaseAuth.instance.currentUser!.uid;
    final screens = [
      FixerHomeScreen(scaffoldKey: scaffoldKey),
      const FixerExploreScreen(),
      const ChatListScreen(),
      const FixerRequestScreen(),
      EarningScreen(fixerId: fixerId),
    ];

    return BlocListener<RoleSwitchCubit, RoleSwitchState>(
      listener: (context, state) {
        //   print('[UI] RoleSwitchState changed: $state');
 if (state is RoleSwitchLoading) {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      // Always close loading dialog if open
      Navigator.of(context, rootNavigator: true).pop();
    }
        if (state is RoleSwitchSuccess) {
          context.read<DrawerStateCubit>().setDrawerState(false);
          //     print('[UI] About to navigate to posterBottomNav');
        
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.posterBottomNav,
            (route) => false,
          );
        } else if (state is RoleSwitchIncompleteProfile) {
          //     print('[UI] Incomplete profile, navigating to complete profile');

          Navigator.pushNamed(
            context,
            AppRoutes.completeProfile,
            arguments: 'poster',
          );
        } else if (state is RoleSwitchError) {
     //     print('[UI] Role switch error: ${state.message}');
        }
      },
      child: BlocBuilder<PosterBottomNavCubit, int>(
        builder: (context, currentIndex) {
          return BlocBuilder<DrawerStateCubit, bool>(
            builder: (context, isDrawerOpen) {
              return BlocBuilder<FixerHomeCubit, FixerHomeState>(
                builder: (context, homeState) {
                  return Scaffold(
                    key: scaffoldKey,
                    extendBody: true,
                    drawer:
                        homeState is FixerHomeLoaded
                            ? FixerCustomDrawer(
                              onLogout: () async {
                                context.read<DrawerStateCubit>().setDrawerState(
                                  false,
                                );
                                context.read<PosterBottomNavCubit>().changeTab(
                                  0,
                                );
                                context.read<FixerProfileCubit>().clear();

                                await AuthServices().logout();
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  AppRoutes.login,
                                  (route) => false,
                                );
                              },
                              onSwitchTap: () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => CustomDialog(
                                        title: "Switch Role",
                                        message:
                                            "Do you want to switch to the other role?",
                                        icon: Icons.sync_alt,
                                        iconColor: AppColors.primaryColor,
                                        onConfirm: () {
                                          context
                                              .read<DrawerStateCubit>()
                                              .setDrawerState(false);
                                          Navigator.pop(context);
                                          context
                                              .read<RoleSwitchCubit>()
                                              .switchRole();
                                        },
                                      ),
                                );
                              },
                            )
                            : null,
                    onDrawerChanged: (isOpen) {
                      context.read<DrawerStateCubit>().setDrawerState(isOpen);
                    },
                    body: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: IndexedStack(
                        key: ValueKey(currentIndex),
                        index: currentIndex,
                        children: screens,
                      ),
                    ),
                    bottomNavigationBar:
                        !isDrawerOpen
                            ? GlassmorphicBottomNavBar(
                              currentIndex: currentIndex,
                              onTabSelected: (index) {
                                context.read<PosterBottomNavCubit>().changeTab(
                                  index,
                                );
                              },
                              onPostTapped: () {},
                              isFixer: true,
                            )
                            : const SizedBox.shrink(),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
