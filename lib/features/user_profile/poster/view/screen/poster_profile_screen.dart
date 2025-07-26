import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/profile_completion/view/complete_profile_screen.dart';
import 'package:quick_pitch_app/features/user_profile/poster/view/components/poster_profile_details.dart';
import 'package:quick_pitch_app/features/user_profile/poster/view/components/poster_profile_header.dart';
import 'package:quick_pitch_app/features/user_profile/poster/view/components/poster_profile_shimmer.dart';
import 'package:quick_pitch_app/features/user_profile/poster/view/components/poster_profile_stats_section.dart';
import 'package:quick_pitch_app/features/user_profile/poster/viewmodel/cubit/poster_profile_cubit.dart';

class PosterProfileScreen extends StatelessWidget {
  const PosterProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PosterProfileCubit()..loadPosterProfile(),
      child: const PosterProfileView(),
    );
  }
}

class PosterProfileView extends StatelessWidget {
  const PosterProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: colorScheme.primary),
            onPressed: () => _navigateToEditProfile(context, 'poster'),
          ),
        ],
      ),
      body: BlocBuilder<PosterProfileCubit, PosterProfileState>(
        builder: (context, state) {
          if (state is PosterProfileLoading) {
            return const PosterProfileShimmer();
          }

          if (state is PosterProfileError) {
            return Center(child: Text(state.message));
          }

          if (state is PosterProfileLoaded) {
            final profile = state.posterProfile;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SizedBox(height: res.hp(2)),
                      // Profile Header
                      PosterProfileHeader(res: res, profile: profile, colorScheme: colorScheme),
                      SizedBox(height: res.hp(3)),
                    ],
                  ),
                ),
                
                // Profile Details
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: res.wp(4)),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      PosterProfileDetails(res: res, profile: profile, theme: theme, colorScheme: colorScheme),
                      SizedBox(height: res.hp(2)),
                      PosterProfileStatsSection(res: res, profile: profile, colorScheme: colorScheme),
                      SizedBox(height: res.hp(4)),
                    ]),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

void _navigateToEditProfile(BuildContext context, String role) {
  final cubit = context.read<PosterProfileCubit>();
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BlocProvider.value(
        value: cubit,
        child: CompleteProfileScreen(role: role, isEditMode: true),
      ),
    ),
  );
}

}
