import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/view/screen/fixer_profile_screen.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/viewmodel/cubit/fixer_profile_cubit.dart';

class FixerCustomDrawer extends StatelessWidget {
  final VoidCallback onLogout;
  final VoidCallback onSwitchTap;

  const FixerCustomDrawer({
    super.key,
    required this.onLogout,
    required this.onSwitchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocBuilder<FixerProfileCubit, FixerProfileState>(
        builder: (context, state) {
          final userData =
              state is FixerProfileLoaded ? state.fixerProfile : null;
          //  print('User data is ${userData}');
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 140,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background (cover image or painter)
                    if (userData?.fixerData?.coverImageUrl != null &&
                        userData!.fixerData!.coverImageUrl!.isNotEmpty)
                      Image.network(
                        userData.fixerData!.coverImageUrl!,
                        fit: BoxFit.cover,
                      )
                    else
                      CustomPaint(painter: MainBackgroundPainter()),

                    // Foreground (avatar + name)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                (userData?.profileImageUrl ?? '').isNotEmpty
                                    ? NetworkImage(userData!.profileImageUrl!)
                                    : const AssetImage(
                                          'assets/images/default_user.png',
                                        )
                                        as ImageProvider,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hi, ${userData?.name ?? ''}",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                userData?.role ?? 'N/A',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () async {
                  if (userData?.role == 'fixer') {
                    // Show loading indicator
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder:
                          (_) =>
                              const Center(child: CircularProgressIndicator()),
                    );

                    Navigator.of(context).pop(); 

                    await Future.delayed(
                      const Duration(milliseconds: 300),
                    ); 

                    
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FixerProfileScreen(),
                      ),
                    );

                    
                    context.read<FixerProfileCubit>().loadFixerProfile();
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: onLogout,
              ),
              ListTile(
                leading: const Icon(Icons.sync_alt),
                title: const Text('Switch Role'),
                onTap: onSwitchTap,
              ),
            ],
          );
        },
      ),
    );
  }
}
