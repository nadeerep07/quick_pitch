import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/routes/app_routes.dart';
import 'package:quick_pitch_app/core/services/firebase/auth/auth_services.dart';
import 'package:quick_pitch_app/features/earnings/fixer/view/screen/earning_screen.dart';
import 'package:quick_pitch_app/features/explore/fixer/view/screen/explore_screen.dart';
import 'package:quick_pitch_app/features/auth/view/components/custom_dialog.dart';
import 'package:quick_pitch_app/features/main/fixer/view/screens/fixer_home_screen.dart';
import 'package:quick_pitch_app/features/main/fixer/viewmodel/cubit/fixer_home_cubit.dart' show FixerHomeCubit, FixerHomeState, FixerHomeLoaded;
import 'package:quick_pitch_app/core/common/custom_bottom_nav.dart';
import 'package:quick_pitch_app/features/main/fixer/view/bottom_nav/components/fixer_custom_drawer.dart';
import 'package:quick_pitch_app/features/main/poster/view/screens/requests_screen.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/bottom_nav/cubit/drawer_state_cubit.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/bottom_nav/cubit/poster_bottom_nav_cubit.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/switch_role/cubit/role_switch_cubit.dart';
import 'package:quick_pitch_app/features/messages/fixer/view/screen/fixer_chat_list_screen.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/viewmodel/cubit/fixer_profile_cubit.dart';

class FixerBottomNavContent extends StatelessWidget {
  const FixerBottomNavContent({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    final screens = [
      FixerHomeScreen(scaffoldKey: scaffoldKey),
      const ExploreScreen(),
      const FixerChatListScreen(),
      const RequestsScreen(),
      EarningScreen()
    ];

    return BlocBuilder<PosterBottomNavCubit, int>(
      builder: (context, currentIndex) {
        return BlocBuilder<DrawerStateCubit, bool>(
          builder: (context, isDrawerOpen) {
            return BlocBuilder<FixerHomeCubit, FixerHomeState>(
              builder: (context, homeState) {
                return BlocListener<RoleSwitchCubit, RoleSwitchState>(
                  listener: (context, state) {
                    if (state is RoleSwitchSuccess) {
                      context.read<DrawerStateCubit>().setDrawerState(false);
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.posterBottomNav,
                        (route) => false,
                      );
                    } else if (state is RoleSwitchIncompleteProfile) {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.completeProfile,
                        arguments: 'poster',
                      );
                    } else if (state is RoleSwitchError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: ${state.message}")),
                      );
                    }
                  },
                  child: Scaffold(
                    key: scaffoldKey,
                    extendBody: true,
                    drawer: homeState is FixerHomeLoaded
                        ? FixerCustomDrawer(
                      
                            onLogout: () async {
                              context.read<DrawerStateCubit>().setDrawerState(false);
                              context.read<PosterBottomNavCubit>().changeTab(0);
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
                                builder: (context) => CustomDialog(
                                  title: "Switch Role",
                                  message: "Do you want to switch to the other role?",
                                  icon: Icons.sync_alt,
                                  iconColor: AppColors.primaryColor,
                                  onConfirm: () {
                                    context.read<DrawerStateCubit>().setDrawerState(false);
                                    Navigator.pop(context);
                                    context.read<RoleSwitchCubit>().switchRole();
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
                    bottomNavigationBar: !isDrawerOpen
                        ? GlassmorphicBottomNavBar(
                            currentIndex: currentIndex,
                            onTabSelected: (index) {
                              context.read<PosterBottomNavCubit>().changeTab(index);
                            },
                            onPostTapped: () {},
                            isFixer: true,
                          )
                        : const SizedBox.shrink(),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
