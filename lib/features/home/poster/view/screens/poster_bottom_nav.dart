import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/firebase/auth/auth_services.dart';
import 'package:quick_pitch_app/core/routes/app_routes.dart';

class PosterBottomNav extends StatelessWidget {
  const PosterBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthServices();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Poster Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.logout();
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
            },
          ),
        ],
      ),

      body: Center(
        child: Text(
          'Poster Home',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: 0,
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }
}
