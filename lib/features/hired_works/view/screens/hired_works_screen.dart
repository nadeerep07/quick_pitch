import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/services/firebase/user_profile/user_profile_service.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';

import 'package:quick_pitch_app/features/hired_works/view/widgets/hired_listing/hire_request_list.dart';


class HiredWorksScreen extends StatefulWidget {
  const HiredWorksScreen({super.key});

  @override
  State<HiredWorksScreen> createState() => _HiredWorksScreenState();
}

class _HiredWorksScreenState extends State<HiredWorksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? currentUserId;
  final UserProfileService userProfileService = UserProfileService();

  String userPhone = '';
  String userName = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    currentUserId = FirebaseAuth.instance.currentUser?.uid;
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    if (currentUserId != null) {
      try {
        final userDoc = await userProfileService.getProfileDocument(
          currentUserId!,
          'poster',
        );
        final userData = userDoc.data() as Map<String, dynamic>?;
        if (userData != null) {
          setState(() {
            userName = userData['name'] ?? 'User';
            userPhone = userData['phone'] ?? '';
          });
        }
      } catch (e) {
     //   print('Error loading user info: $e');
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hired Works',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.blue.shade700,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue.shade700,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'Accepted'),
            Tab(text: 'Completed'),
            Tab(text: 'Declined'),
          ],
        ),
      ),
      body: Stack(
        children: [
          CustomPaint(
            painter: MainBackgroundPainter(),
           size: Size.infinite,
          ),
          currentUserId == null
              ? const Center(
                  child: Text(
                    'Please log in to view your hired works',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    HireRequestList(status: null, currentUserId: currentUserId!, userPhone: userPhone, userName: userName),
                    HireRequestList(status: HireRequestStatus.pending, currentUserId: currentUserId!, userPhone: userPhone, userName: userName),
                    HireRequestList(status: HireRequestStatus.accepted, currentUserId: currentUserId!, userPhone: userPhone, userName: userName),
                    HireRequestList(status: HireRequestStatus.completed, currentUserId: currentUserId!, userPhone: userPhone, userName: userName),
                    HireRequestList(status: HireRequestStatus.declined, currentUserId: currentUserId!, userPhone: userPhone, userName: userName),
                  ],
                ),
        ],
      ),
    );
  }
}
