import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback onLogout;
  final VoidCallback onSwitchTap;
  final Map<String, dynamic> userData;

  const CustomDrawer({
    super.key,
    required this.onLogout,
    required this.onSwitchTap,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.deepPurpleAccent],
              ),
            ),
            child:
                userData['name'] != null
                    ? Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          backgroundImage:
                              (userData['profileImageUrl'] ?? '').isNotEmpty
                                  ? NetworkImage(userData['profileImageUrl'])
                                  : const AssetImage(
                                        'assets/images/default_user.png',
                                      )
                                      as ImageProvider,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hi, ${userData['name']}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "${userData['role']}",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                    : const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              // Implement or route to profile screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // Implement settings if needed
            },
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
      ),
    );
  }
}
