// poster_home_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/home/cubit/poster_home_cubit.dart';

class PosterHomeHeader extends StatelessWidget {
  const PosterHomeHeader({super.key, required this.res});

  final Responsive res;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PosterHomeCubit, PosterHomeState>(
      builder: (context, state) {
        if (state is PosterHomeLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PosterHomeLoaded) {
          final imageUrl =
              (state.profileImageUrl?.isNotEmpty ?? false)
                  ? state.profileImageUrl!
                  : 'https://i.pravatar.cc/150?img=3';

          return Row(
            children: [
              GestureDetector(
                onTap: () => Scaffold.of(context).openDrawer(),
                child: Hero(
                  tag: 'profile_avatar',
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.grey.shade200,
                    child: ClipOval(
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/default_user.png',
                        image: imageUrl,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        imageErrorBuilder:
                            (_, __, ___) => Image.asset(
                              'assets/images/default_user.png',
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                            ),
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
                    ' ${state.name} ',
                    style: TextStyle(
                      fontSize: res.sp(20),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 4),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          ' ${state.role} ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: res.sp(12),
                            fontWeight: FontWeight.w500,
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

        return const SizedBox.shrink();
      },
    );
  }
}
