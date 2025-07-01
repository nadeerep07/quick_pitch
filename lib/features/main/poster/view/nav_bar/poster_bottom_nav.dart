import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/firebase/auth/auth_services.dart';
import 'package:quick_pitch_app/core/routes/app_routes.dart';
// import 'package:quick_pitch_app/core/firebase/auth/auth_services.dart';
// import 'package:quick_pitch_app/core/routes/app_routes.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/custom_bottom_nav.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/custom_drawer.dart';
import 'package:quick_pitch_app/features/main/poster/view/screens/chat_screen.dart';
import 'package:quick_pitch_app/features/main/poster/view/screens/explore_screen.dart';
import 'package:quick_pitch_app/features/main/poster/view/screens/poster_home_screen.dart';
import 'package:quick_pitch_app/features/main/poster/view/screens/requests_screen.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/bottom_nav/cubit/drawer_state_cubit.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/bottom_nav/cubit/poster_bottom_nav_cubit.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/switch_role/cubit/role_switch_cubit.dart';

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
                  if (state.newRole == 'fixer') {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.fixerBottomNav,
                      (route) => false,
                    );
                  } else {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.posterBottomNav,
                      (route) => false,
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
                    context.read<DrawerStateCubit>().setDrawerState(false);

                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.login,
                      (route) => false,
                    );
                  },
                  onSwitchTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Switch Role"),
                          content: const Text(
                            "Do you want to switch to the other role?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                 context.read<DrawerStateCubit>().setDrawerState(false);
                                Navigator.pop(context); // Close dialog first

                                context.read<RoleSwitchCubit>().switchRole();
                              },
                              child: const Text("Switch"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                onDrawerChanged: (bool isOpen) {
                  context.read<DrawerStateCubit>().setDrawerState(isOpen);

                  if (!isOpen) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.read<DrawerStateCubit>().setDrawerState(false);
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
                          onPostTapped: () {
                            // Task posting navigation if any
                          },
                        )
                        : const SizedBox.shrink(),
              ),
            );
          },
        );
      },
    );
  }
}
