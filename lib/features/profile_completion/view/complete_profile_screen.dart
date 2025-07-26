import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/common/backgroun_painter.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/core/errors/auth_error_mapper.dart';
import 'package:quick_pitch_app/core/routes/app_routes.dart';
import 'package:quick_pitch_app/features/auth/view/components/custom_dialog.dart';
import 'package:quick_pitch_app/features/profile_completion/view/components/certification_section.dart';
import 'package:quick_pitch_app/features/profile_completion/view/components/fixer_skill_section.dart';
import 'package:quick_pitch_app/features/profile_completion/view/components/profile_head_section.dart';
import 'package:quick_pitch_app/features/profile_completion/view/components/profile_info_section.dart';
import 'package:quick_pitch_app/features/profile_completion/view/components/submit_button.dart';
import 'package:quick_pitch_app/features/profile_completion/viewmodel/cubit/complete_profile_cubit.dart';

class CompleteProfileScreen extends StatefulWidget {
  final String role;
  final bool isEditMode;

  const CompleteProfileScreen({
    super.key,
    required this.role,
    required this.isEditMode,
  });

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  @override
  void initState() {
    super.initState();
    _initializeProfileData();
  }

  void _initializeProfileData() {
    final cubit = context.read<CompleteProfileCubit>();
    cubit.loadSkillsFromAdmin();
    if (widget.isEditMode) cubit.loadProfileDataForEdit(widget.role);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) {
          context.read<CompleteProfileCubit>().resetProfileData();
        }
      },
      child: Scaffold(
        appBar: widget.isEditMode ? _buildAppBar() : null,
        body: Stack(
          children: [
            CustomPaint(painter: BackgroundPainter(), size: Size.infinite),
            _buildMainContent(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: BackButton(),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  Widget _buildMainContent() {
    return SafeArea(
      child: BlocListener<CompleteProfileCubit, CompleteProfileState>(
        listener: _handleStateChanges,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: Responsive(context).wp(6)),
          child: BlocBuilder<CompleteProfileCubit, CompleteProfileState>(
            builder: (context, state) {
              final cubit = context.read<CompleteProfileCubit>();
              return Form(
                key: cubit.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    _buildProfileSections(cubit),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSections(CompleteProfileCubit cubit) {
    return Column(
      children: [
        ProfileHeaderSection(cubit: cubit, isEditMode: widget.isEditMode),
        PersonalInfoSection(cubit: cubit),
        if (widget.role == 'fixer') SkillsSection(cubit: cubit),
        if (widget.role == 'fixer') CertificationSection(cubit: cubit),
        SubmitButtonSection(
          cubit: cubit,
          role: widget.role,
          isEditMode: widget.isEditMode,
        ),
      ],
    );
  }

  void _handleStateChanges(BuildContext context, CompleteProfileState state) {
    if (state is CompleteProfileSuccess) {
      _navigateAfterSuccess();
    } else if (state is CompleteProfileError) {
      _showErrorDialog(state.message);
    }
  }

  void _navigateAfterSuccess() {
    final route =
        widget.role == 'poster'
            ? AppRoutes.posterBottomNav
            : AppRoutes.fixerBottomNav;
    widget.isEditMode
        ? Navigator.pop(context)
        : Navigator.pushReplacementNamed(context, route);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => CustomDialog(
            title: "Signup Failed",
            message: mapFirebaseError(message),
            icon: Icons.error_outline,
            iconColor: Colors.red,
            onConfirm: () => Navigator.of(context).pop(),
          ),
    );
  }
}
