import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/firebase/auth/auth_services.dart';
import 'package:quick_pitch_app/core/routes/app_routes.dart';
import 'package:quick_pitch_app/features/auth/view/components/custom_dialog.dart';
import 'package:quick_pitch_app/features/main/fixer/view/screens/fixer_home_screen.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/custom_bottom_nav.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/custom_drawer.dart';
import 'package:quick_pitch_app/features/main/poster/view/screens/chat_screen.dart';
import 'package:quick_pitch_app/features/main/poster/view/screens/explore_screen.dart';
import 'package:quick_pitch_app/features/main/poster/view/screens/requests_screen.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/bottom_nav/cubit/drawer_state_cubit.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/bottom_nav/cubit/poster_bottom_nav_cubit.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/switch_role/cubit/role_switch_cubit.dart';

class FixerBottomNav extends StatefulWidget {
  const FixerBottomNav({super.key});

  @override
  State<FixerBottomNav> createState() => _FixerBottomNavState();
}

class _FixerBottomNavState extends State<FixerBottomNav> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = const [
      FixerHomeScreen(),
      ExploreScreen(),
      ChatScreen(),
      RequestsScreen(),
    ];

    //final authService = AuthServices();

    return BlocBuilder<PosterBottomNavCubit, int>(
      builder: (context, currentIndex) {
        return BlocBuilder<DrawerStateCubit, bool>(
          builder: (context, isDrawerOpen) {
            return BlocListener<RoleSwitchCubit, RoleSwitchState>(
              listener: (context, state) {
                if (state is RoleSwitchSuccess) {
                  // Navigate based on role:
                  if (state.newRole == 'poster') {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.posterBottomNav,
                      (route) => false,
                    );
                  }
                } else if (state is RoleSwitchIncompleteProfile) {
                  if (state.missingRole == 'poster') {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.completeProfile,
                      arguments: 'poster',
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
                drawer: CustomDrawer(
                  onLogout: () async {
                    await AuthServices().logout();
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
                          message: "Do you want to switch to the other role?",
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
                  print("Drawer is open: $isOpen");

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
                    isDrawerOpen
                        ? const SizedBox.shrink()
                        : GlassmorphicBottomNavBar(
                          currentIndex: currentIndex,
                          onTabSelected: (index) {
                            context.read<PosterBottomNavCubit>().changeTab(
                              index,
                            );
                          },
                          onPostTapped: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (_) => const TaskPostScreen(),
                            //   ),
                            // );
                          },
                        ),
              ),
            );
          },
        );
      },
    );
  }
}
