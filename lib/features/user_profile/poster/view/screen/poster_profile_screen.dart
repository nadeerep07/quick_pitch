import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/profile_completion/view/complete_profile_screen.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToEditProfile(context,'poster'),
          ),
        ],
      ),
      body: BlocBuilder<PosterProfileCubit, PosterProfileState>(
        builder: (context, state) {
          if (state is PosterProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PosterProfileError) {
            return Center(child: Text(state.message));
          }

          if (state is PosterProfileLoaded) {
            final profile = state.posterProfile;

            return SingleChildScrollView(
              padding: EdgeInsets.all(res.wp(4)),
              child: Column(
                children: [
                  // Profile Header
                  _buildProfileHeader(res, profile),
                  SizedBox(height: res.hp(3)),

                  // Profile Details
                  _buildProfileDetails(res, profile, theme),
                  SizedBox(height: res.hp(3)),

                  // Stats Section
                  _buildStatsSection(res, profile),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildProfileHeader(Responsive res, UserProfileModel profile) {
    return Column(
      children: [
        CircleAvatar(
          radius: res.wp(15),
          backgroundImage: profile.profileImageUrl != null
              ? NetworkImage(profile.profileImageUrl!)
              : const AssetImage('assets/images/avatar_photo_placeholder.jpg') as ImageProvider,
        ),
        SizedBox(height: res.hp(1.5)),
        Text(
          profile.name,
          style: TextStyle(
            fontSize: res.sp(20),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: res.hp(0.5)),
        Text(
          profile.role,
          style: TextStyle(
            fontSize: res.sp(14),
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileDetails(Responsive res, UserProfileModel profile, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(res.wp(4)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Information',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: res.hp(2)),
          _buildDetailRow(res, Icons.phone, profile.phone),
          SizedBox(height: res.hp(1.5)),
          _buildDetailRow(res, Icons.location_on, profile.location),
          SizedBox(height: res.hp(2)),
          Text(
            'About',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: res.hp(1.5)),
          Text(
            profile.posterData?.bio ?? 'No bio added',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(Responsive res, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: res.sp(18), color: AppColors.primaryColor),
        SizedBox(width: res.wp(3)),
        Text(
          text,
          style: TextStyle(fontSize: res.sp(15)),
        ),
      ],
    );
  }

  Widget _buildStatsSection(Responsive res, UserProfileModel profile) {
    return Container(
      padding: EdgeInsets.all(res.wp(4)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
            //  _buildStatItem(res, 'Posts', '${profile.posterData?.totalPosts ?? 0}'),
              _buildStatItem(res, 'Completed', '12'), // Example data
              _buildStatItem(res, 'Rating', '4.8'), // Example data
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(Responsive res, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: res.sp(18),
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        SizedBox(height: res.hp(0.5)),
        Text(
          label,
          style: TextStyle(
            fontSize: res.sp(12),
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _navigateToEditProfile(BuildContext context,String role) {
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

class EditPosterProfileScreen extends StatelessWidget {
  const EditPosterProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Implement your edit profile screen here
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: const Center(
        child: Text('Edit Profile Screen'),
      ),
    );
  }
}