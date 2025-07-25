import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/services/firebase/auth/auth_services.dart';
import 'package:quick_pitch_app/core/routes/app_routes.dart';
import 'package:quick_pitch_app/features/auth/view/components/custom_dialog.dart';
import 'package:quick_pitch_app/features/explore/poster/view/screen/poster_explore_screen.dart';
import 'package:quick_pitch_app/core/common/custom_bottom_nav.dart';
import 'package:quick_pitch_app/features/main/poster/view/nav_bar/components/poster_custom_drawer.dart';
import 'package:quick_pitch_app/features/main/poster/view/screens/poster_home_screen.dart';
import 'package:quick_pitch_app/features/main/poster/view/screens/requests_screen.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/bottom_nav/cubit/drawer_state_cubit.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/bottom_nav/cubit/poster_bottom_nav_cubit.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/home/cubit/poster_home_cubit.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/switch_role/cubit/role_switch_cubit.dart';
import 'package:quick_pitch_app/features/messages/fixer/view/screen/fixer_chat_list_screen.dart';
import 'package:quick_pitch_app/features/profile_completion/viewmodel/cubit/complete_profile_cubit.dart';
import 'package:quick_pitch_app/features/poster_task/view/components/task_post_wrapper.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/viewmodel/cubit/fixer_profile_cubit.dart';

class PosterBottomNav extends StatefulWidget {
  const PosterBottomNav({super.key});

  @override
  State<PosterBottomNav> createState() => _PosterBottomNavState();
}

class _PosterBottomNavState extends State<PosterBottomNav> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = const [
      PosterHomeScreen(),
      PosterExploreScreen(),
      FixerChatListScreen(),
      RequestsScreen(),
    ];

    //final authService = AuthServices();

    return BlocBuilder<PosterBottomNavCubit, int>(
      builder: (context, currentIndex) {
        return BlocBuilder<DrawerStateCubit, bool>(
          builder: (context, isDrawerOpen) {
            return BlocBuilder<PosterHomeCubit, PosterHomeState>(
              builder: (context, homeState) {
                return BlocListener<RoleSwitchCubit, RoleSwitchState>(
                  listener: (context, state) {
                    if (state is RoleSwitchSuccess) {
                      // Navigate based on role:
                      if (state.newRole == 'fixer') {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.fixerBottomNav,
                          (route) => false,
                        );
                      }
                    } else if (state is RoleSwitchIncompleteProfile) {
                      if (state.missingRole == 'fixer') {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.completeProfile,
                          arguments: 'fixer',
                        );
                      }
                    } else if (state is RoleSwitchError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: ${state.message}")),
                      );
                    }
                  },
                  child: Scaffold(
                    extendBody: true,
                    key: _scaffoldKey,
                    drawer: PosterCustomDrawer(
                      onLogout: () async {
                        await AuthServices().logout();
                        context.read<DrawerStateCubit>().setDrawerState(false);
                        context.read<CompleteProfileCubit>().resetProfileData();
                        context.read<FixerProfileCubit>().clear();


                        Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.login,
                          (route) => false,
                        );
                      },
                      onSwitchTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CustomDialog(
                              title: "Switch Role",
                              message:
                                  "Do you want to switch to the other role?",
                              icon: Icons.sync_alt,
                              iconColor: AppColors.primaryColor,
                              onConfirm: () async {
                                context.read<DrawerStateCubit>().setDrawerState(
                                  false,
                                );
                                Navigator.pop(context); // Close dialog first

                                context.read<RoleSwitchCubit>().switchRole();
                              },
                            );
                          },
                        );
                      },
                    ),
                    onDrawerChanged: (bool isOpen) {
                      context.read<DrawerStateCubit>().setDrawerState(isOpen);

                      if (!isOpen) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          context.read<DrawerStateCubit>().setDrawerState(
                            false,
                          );
                        });
                      }
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
                        (!isDrawerOpen)
                            ? GlassmorphicBottomNavBar(
                              currentIndex: currentIndex,
                              onTabSelected: (index) {
                                context.read<PosterBottomNavCubit>().changeTab(
                                  index,
                                );
                              },
                              onPostTapped: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const TaskPostWrapper(),
                                  ),
                                );

                                if (result == true) {
                                  context
                                      .read<PosterHomeCubit>()
                                      .streamPosterHomeData();

                                }
                              },
                              isFixer: false,
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
