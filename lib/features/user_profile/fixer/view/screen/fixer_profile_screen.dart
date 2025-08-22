import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/view/components/fixer_profile_app_bar.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/view/components/fixer_profile_content.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/view/components/fixer_profile_header.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/view/components/fixer_profile_shimmer.dart';
import 'package:quick_pitch_app/features/user_profile/fixer/viewmodel/cubit/fixer_profile_cubit.dart';

class FixerProfileScreen extends StatelessWidget {
  const FixerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FixerProfileCubit()..loadFixerProfile(),
      child: const _FixerProfileView(),
    );
  }
}

class _FixerProfileView extends StatelessWidget {
  const _FixerProfileView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final res = Responsive(context);

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: BlocConsumer<FixerProfileCubit, FixerProfileState>(
        listener: _handleStateChanges,
        builder: (context, state) {
          if (state is FixerProfileInitial || state is FixerProfileLoading) {
            return const FixerProfileShimmer();
          }

          if (state is FixerProfileError) {
            return Center(child: Text(state.message));
          }

          if (state is FixerProfileLoaded) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                FixerProfileAppBar(profile: state.fixerProfile, res: res),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: res.wp(5)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        FixerProfileHeader(profile: state.fixerProfile, theme: theme, res: res),
                        const SizedBox(height: 24),
                        FixerProfileContent(profile: state.fixerProfile, theme: theme,
                          onUpdateCertificate: state.fixerProfile.fixerData?.certificateStatus.toLowerCase() == 'rejected'
                              ? () => context.read<FixerProfileCubit>().updateCertificate()
                              : null,
                              isOwner: true,
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
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

  void _handleStateChanges(BuildContext context, FixerProfileState state) {
    if (state is FixerProfileError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }
}