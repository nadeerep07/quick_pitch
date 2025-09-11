import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/core/services/firebase/user_profile/user_profile_service.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/repository/hire_request_repository.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/view/components/empty_view.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/view/components/error_view.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/view/components/loading_view.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/view/widget/bottom_action_section.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/view/widget/fixer_work_appbar.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/view/widget/fixer_work_list.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/viewmodel/cubit/fixer_work_selection_cubit.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/repository/fixer_works_repository.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class FixerWorkSelectionScreen extends StatelessWidget {
  final UserProfileModel fixerData;
  final TextEditingController _messageController = TextEditingController();

  FixerWorkSelectionScreen({super.key, required this.fixerData});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocProvider(
      create: (_) => FixerWorkSelectionCubit(
        hireRequestRepository: HireRequestRepository(),
        userProfileService: UserProfileService(),
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: FixerWorkAppBar(fixerData: fixerData),
        body: Stack(
          children: [
            CustomPaint(
              size: Size(res.width, res.height),
              painter: MainBackgroundPainter(),
            ),
            StreamBuilder<List<FixerWork>>(
              stream: FixerWorksRepository().getFixerWorks(fixerData.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingView(res: res);
                }
            
                if (snapshot.hasError) {
                  return ErrorView(res: res, theme: theme);
                }
            
                final works = snapshot.data ?? [];
                if (works.isEmpty) {
                  return EmptyView(
                    res: res,
                    theme: theme,
                    fixerName: fixerData.name,
                  );
                }
            
                return BlocConsumer<FixerWorkSelectionCubit,
                    FixerWorkSelectionState>(
                  listener: (context, state) {
                    _handleStateListener(context, state, theme);
                  },
                  builder: (context, state) {
                    FixerWork? selectedWork;
                    bool isSubmitting = false;
            
                    if (state is FixerWorkSelectionLoaded) {
                      selectedWork = state.selectedWork;
                    } else if (state is FixerWorkSubmitting) {
                      selectedWork = state.selectedWork;
                      isSubmitting = true;
                    }
            
                    return Column(
                      children: [
                        Expanded(
                          child: FixerWorkList(
                            works: works,
                            selectedWork: selectedWork,
                            res: res,
                            theme: theme,
                            colorScheme: colorScheme,
                          ),
                        ),
                        if (selectedWork != null)
                          BottomActionSection(
                            res: res,
                            colorScheme: colorScheme,
                            theme: theme,
                            selectedWork: selectedWork,
                            isSubmitting: isSubmitting,
                            messageController: _messageController,
                            fixerData: fixerData,
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleStateListener(
    BuildContext context,
    FixerWorkSelectionState state,
    ThemeData theme,
  ) {
    if (state is FixerWorkRequestSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Request sent to ${state.fixerName.split(" ").first} for "${state.workTitle}"',
                ),
              ),
            ],
          ),
          backgroundColor: theme.colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
      Navigator.pop(context);
    }

    if (state is FixerWorkSelectionError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: theme.colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
