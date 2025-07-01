import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/poster_background_painter.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/poster_home_fixer_card.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/poster_home_quick_action_button.dart';
import 'package:quick_pitch_app/features/main/poster/view/components/poster_home_task_card.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/home/cubit/poster_home_cubit.dart';

class PosterHomeScreen extends StatefulWidget {
  const PosterHomeScreen({super.key});

  @override
  State<PosterHomeScreen> createState() => _PosterHomeScreenState();
}

class _PosterHomeScreenState extends State<PosterHomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PosterHomeCubit>().fetchProfileImage();
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return Container(
      decoration: const BoxDecoration(
        // If your background painter is just decoration, use BoxDecoration instead
        // else wrap with Stack + CustomPaint
        color: Colors.transparent,
      ),
      child: CustomPaint(
        painter: PosterBackgroundPainter(),
        child: SafeArea(
          bottom: true,
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: res.wp(5),
              vertical: res.hp(2),
            ),
            physics: const BouncingScrollPhysics(),
            children: [
              BlocBuilder<PosterHomeCubit, PosterHomeState>(
                builder: (context, state) {
                  if (state is PosterHomeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is PosterHomeLoaded) {
                    final imageUrl = state.profileImageUrl ??
                        'https://i.pravatar.cc/150?img=3';
                    return Row(
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
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover,
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/default_user.png',
                                      width: 64,
                                      height: 64,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
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
                              children: [
                                Icon(Icons.person_2,
                                    size: 16, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Text(
                                  state.role,
                                  style: TextStyle(
                                    fontSize: res.sp(14),
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),

              // 🟦 Task summary box
              Container(
                margin: EdgeInsets.symmetric(vertical: res.hp(2)),
                padding: EdgeInsets.all(res.hp(2)),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blueAccent, Colors.lightBlueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Tasks',
                          style: TextStyle(
                            fontSize: res.sp(18),
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '3 Active Tasks',
                          style: TextStyle(
                            fontSize: res.sp(13),
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.assignment_turned_in_rounded,
                        size: res.sp(32), color: Colors.white),
                  ],
                ),
              ),

              // 🟦 Task Cards
              SizedBox(
                height: res.hp(26),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    PosterHomeTaskCard(
                      res: res,
                      title: 'Task 1',
                      status: 'Completed',
                      imageUrl: 'https://i.pravatar.cc/150?img=1',
                      fixerName: 'Rahul',
                    ),
                    PosterHomeTaskCard(
                      res: res,
                      title: 'Task 2',
                      status: 'In Progress',
                      imageUrl: 'https://i.pravatar.cc/150?img=2',
                      fixerName: 'Anjali',
                    ),
                    PosterHomeTaskCard(
                      res: res,
                      title: 'Task 3',
                      status: 'Pending',
                      imageUrl: 'https://i.pravatar.cc/150?img=3',
                      fixerName: 'Not assigned',
                    ),
                  ],
                ),
              ),

              // 🟦 Fixers
              Padding(
                padding: EdgeInsets.only(top: res.hp(2)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recommended Fixers',
                      style: TextStyle(
                        fontSize: res.sp(16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: res.hp(1)),
                    SizedBox(
                      height: res.hp(15),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          poster_home_fixer_card(
                              res: res, name: 'Rahul', skill: 'Electrician'),
                          poster_home_fixer_card(
                              res: res, name: 'Anjali', skill: 'Painter'),
                          poster_home_fixer_card(
                              res: res, name: 'Manoj', skill: 'AC Technician'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 🟦 Quick Actions
              SizedBox(height: res.hp(2)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  poster_home_quick_action_button(
                      icon: Icons.chat, label: "Chats", res: res),
                  poster_home_quick_action_button(
                      icon: Icons.history, label: "My Tasks", res: res),
                  poster_home_quick_action_button(
                      icon: Icons.person_search, label: "Find Fixer", res: res),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

