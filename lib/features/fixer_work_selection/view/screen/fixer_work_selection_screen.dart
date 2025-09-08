import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/core/services/firebase/user_profile/user_profile_service.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/repository/hire_request_repository.dart';
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
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: colorScheme.surface,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Work',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Choose work from ${fixerData.name.split(' ').first}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.0),
            child: Container(
              color: colorScheme.outline.withOpacity(0.2),
              height: 1.0,
            ),
          ),
        ),
        body: StreamBuilder<List<FixerWork>>(
          stream: FixerWorksRepository().getFixerWorks(fixerData.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingView(res);
            }

            if (snapshot.hasError) {
              return _buildErrorView(res, theme, snapshot.error.toString());
            }

            final works = snapshot.data ?? [];
            if (works.isEmpty) {
              return _buildEmptyView(res, theme);
            }

            return BlocConsumer<FixerWorkSelectionCubit, FixerWorkSelectionState>(
              listener: (context, state) {
                if (state is FixerWorkRequestSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Request sent to ${state.fixerName.split(" ").first} for "${state.workTitle}"',
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: theme.colorScheme.primary,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 4),
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
                      child: ListView.builder(
                        padding: EdgeInsets.all(res.wp(4)),
                        itemCount: works.length,
                        itemBuilder: (context, index) {
                          final work = works[index];
                          final isSelected = selectedWork?.id == work.id;

                          return Container(
                            margin: EdgeInsets.only(bottom: res.hp(2)),
                            child: InkWell(
                              onTap: () {
                                context.read<FixerWorkSelectionCubit>().emit(
                                  FixerWorkSelectionLoaded(
                                    works: works,
                                    selectedWork: isSelected ? null : work,
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: EdgeInsets.all(res.wp(4)),
                                decoration: BoxDecoration(
                                  color: colorScheme.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? colorScheme.primary
                                        : colorScheme.outline.withOpacity(0.2),
                                    width: isSelected ? 2 : 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    _buildWorkImage(work, res, colorScheme),
                                    SizedBox(width: res.wp(4)),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            work.title,
                                            style: theme.textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: isSelected
                                                  ? colorScheme.primary
                                                  : colorScheme.onSurface,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          if (work.description.isNotEmpty)
                                            Padding(
                                              padding: EdgeInsets.only(top: res.hp(0.5)),
                                              child: Text(
                                                work.description,
                                                style: theme.textTheme.bodyMedium?.copyWith(
                                                  color: colorScheme.onSurface.withOpacity(0.7),
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          SizedBox(height: res.hp(1)),
                                          Row(
                                            children: [
                                              _buildChip(
                                                res,
                                                colorScheme.primaryContainer,
                                                '\$${work.amount.toStringAsFixed(0)}',
                                                colorScheme.onPrimaryContainer,
                                                theme,
                                              ),
                                              SizedBox(width: res.wp(2)),
                                              if (work.time.isNotEmpty)
                                                _buildChip(
                                                  res,
                                                  colorScheme.secondaryContainer,
                                                  work.time,
                                                  colorScheme.onSecondaryContainer,
                                                  theme,
                                                ),
                                              Spacer(),
                                              if (isSelected)
                                                CircleAvatar(
                                                  radius: res.sp(12),
                                                  backgroundColor: colorScheme.primary,
                                                  child: Icon(
                                                    Icons.check,
                                                    color: colorScheme.onPrimary,
                                                    size: res.sp(16),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (selectedWork != null)
                      _buildBottomAction(
                        res,
                        colorScheme,
                        theme,
                        selectedWork,
                        isSubmitting,
                        context,
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildWorkImage(FixerWork work, Responsive res, ColorScheme colorScheme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: work.images.isNotEmpty
          ? Image.network(
              work.images.first,
              width: res.wp(20),
              height: res.wp(20),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildImagePlaceholder(res, colorScheme),
            )
          : _buildImagePlaceholder(res, colorScheme),
    );
  }

  Widget _buildChip(Responsive res, Color bg, String text, Color fg, ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: res.wp(2), vertical: res.wp(1)),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildBottomAction(
    Responsive res,
    ColorScheme colorScheme,
    ThemeData theme,
    FixerWork selectedWork,
    bool isSubmitting,
    BuildContext context,
  ) {
    return Container(
      padding: EdgeInsets.all(res.wp(4)),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outline.withOpacity(0.2))),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: res.hp(2)),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _messageController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Add a message for ${fixerData.name.split(" ").first} (optional)',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(res.wp(3)),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: res.hp(2)),
                ),
                onPressed: isSubmitting
                    ? null
                    : () {
                        context.read<FixerWorkSelectionCubit>().submitRequest(
                              work: selectedWork,
                              fixer: fixerData,
                              message: _messageController.text,
                            );
                      },
                child: isSubmitting
                    ? SizedBox(
                        height: res.sp(20),
                        width: res.sp(20),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(colorScheme.onPrimary),
                        ),
                      )
                    : Text(
                        'Send Request for "${selectedWork.title}"',
                        style: TextStyle(
                          fontSize: res.sp(16),
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onPrimary,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder(Responsive res, ColorScheme colorScheme) {
    return Container(
      width: res.wp(20),
      height: res.wp(20),
      color: colorScheme.outline.withOpacity(0.1),
      child: Icon(Icons.image_not_supported_outlined, color: colorScheme.outline, size: res.sp(24)),
    );
  }

  Widget _buildLoadingView(Responsive res) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: res.hp(2)),
            Text('Loading available works...', style: TextStyle(fontSize: res.sp(16), color: Colors.grey[600])),
          ],
        ),
      );

  Widget _buildErrorView(Responsive res, ThemeData theme, String error) => Center(
        child: Padding(
          padding: EdgeInsets.all(res.wp(8)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: res.sp(64), color: theme.colorScheme.error),
              SizedBox(height: res.hp(2)),
              Text('Unable to load works', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: res.hp(1)),
              Text('Please try again later',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7))),
            ],
          ),
        ),
      );

  Widget _buildEmptyView(Responsive res, ThemeData theme) => Center(
        child: Padding(
          padding: EdgeInsets.all(res.wp(8)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.work_off_outlined, size: res.sp(64), color: theme.colorScheme.outline),
              SizedBox(height: res.hp(2)),
              Text('No Works Available',
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: res.hp(1)),
              Text('${fixerData.name.split(" ").first} hasn\'t uploaded any works yet.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7))),
            ],
          ),
        ),
      );
}
