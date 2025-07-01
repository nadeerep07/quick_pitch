import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/poster_background_painter.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/home/cubit/poster_home_cubit.dart';

class FixerHomeScreen extends StatefulWidget {
  const FixerHomeScreen({super.key});

  @override
  State<FixerHomeScreen> createState() => _FixerHomeScreenState();
}

class _FixerHomeScreenState extends State<FixerHomeScreen> {
   @override
  void initState() {
    super.initState();
    context.read<PosterHomeCubit>().fetchProfileImage();
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return Stack(
      children: [
        CustomPaint(painter: PosterBackgroundPainter(), size: Size.infinite),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: res.wp(5),
              vertical: res.hp(2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<PosterHomeCubit, PosterHomeState>(
                  builder: (context, state) {
                    if (state is PosterHomeLoading) {
                      return const CircularProgressIndicator();
                    }

                    if (state is PosterHomeLoaded) {
                      final imageUrl =
                          state.profileImageUrl ??
                          'https://i.pravatar.cc/150?img=3'; // fallback image
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Scaffold.of(context).openDrawer();
                            },
                            child: Hero(
                              tag: 'profile_avatar',
                              child: CircleAvatar(
                                radius: 32,
                                backgroundColor: Colors.grey.shade200,
                                child: ClipOval(
                                  child: FadeInImage.assetNetwork(
                                    placeholder:
                                        'assets/images/default_user.png',
                                    image: imageUrl,
                                    fit: BoxFit.cover,
                                    width: 64,
                                    height: 64,
                                    imageErrorBuilder: (
                                      context,
                                      error,
                                      stackTrace,
                                    ) {
                                      return Image.asset(
                                        'assets/images/default_user.png',
                                        fit: BoxFit.cover,
                                        width: 64,
                                        height: 64,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hi ${state.name} 👋',
                                style: TextStyle(
                                  fontSize: res.sp(20),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.person_2,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      state.role,
                                      style: TextStyle(
                                        fontSize: res.sp(14),
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    }

                    return const SizedBox(); // fallback
                  },
                ),

                //  My Tasks
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Tasks',
                      style: TextStyle(
                        fontSize: res.sp(18),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Go to MyTasks page
                      },
                      child: const Text('See All'),
                    ),
                  ],
                ),

                //  Task Cards
                Expanded(
                  child: ListView(
                    children: [
                      _taskCard(res, title: 'Fix my AC', status: 'Pending'),
                      _taskCard(
                        res,
                        title: 'Need Electrician',
                        status: 'In Progress',
                      ),
                      _taskCard(
                        res,
                        title: 'Wall Painting',
                        status: 'Completed',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _taskCard(
    Responsive res, {
    required String title,
    required String status,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: res.hp(2)),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.home_repair_service_outlined),
        title: Text(title),
        subtitle: Text('Status: $status'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Navigate to Task Detail
        },
      ),
    );
  }
}