import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/core/services/firebase/user_profile/user_profile_service.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/repository/hire_request_repository.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/model/fixer_work_upload_model.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/repository/fixer_works_repository.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class FixerWorkSelectionScreen extends StatefulWidget {
  final UserProfileModel fixerData;

  const FixerWorkSelectionScreen({
    super.key,
    required this.fixerData,
  });

  @override
  State<FixerWorkSelectionScreen> createState() => _FixerWorkSelectionScreenState();
}

class _FixerWorkSelectionScreenState extends State<FixerWorkSelectionScreen> {
  FixerWork? selectedWork;
  bool isSubmitting = false;
  final HireRequestRepository _hireRequestRepository = HireRequestRepository();
  final UserProfileService _userProfileService = UserProfileService();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
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
              'Choose work from ${widget.fixerData.name.split(' ').first}',
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
        stream: FixerWorksRepository().getFixerWorks(widget.fixerData.uid),
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
                          setState(() {
                            selectedWork = isSelected ? null : work;
                          });
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
                              // Work image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: work.images.isNotEmpty
                                    ? Image.network(
                                        work.images.first,
                                        width: res.wp(20),
                                        height: res.wp(20),
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return _buildImagePlaceholder(res, colorScheme);
                                        },
                                      )
                                    : _buildImagePlaceholder(res, colorScheme),
                              ),
                              SizedBox(width: res.wp(4)),
                              // Work details
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
                                    SizedBox(height: res.hp(0.5)),
                                    if (work.description.isNotEmpty)
                                      Text(
                                        work.description,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: colorScheme.onSurface.withOpacity(0.7),
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    SizedBox(height: res.hp(1)),
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: res.wp(2),
                                            vertical: res.wp(1),
                                          ),
                                          decoration: BoxDecoration(
                                            color: colorScheme.primaryContainer,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            '\$${work.amount.toStringAsFixed(0)}',
                                            style: theme.textTheme.labelSmall?.copyWith(
                                              color: colorScheme.onPrimaryContainer,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: res.wp(2)),
                                        if (work.time.isNotEmpty)
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: res.wp(2),
                                              vertical: res.wp(1),
                                            ),
                                            decoration: BoxDecoration(
                                              color: colorScheme.secondaryContainer,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              work.time,
                                              style: theme.textTheme.labelSmall?.copyWith(
                                                color: colorScheme.onSecondaryContainer,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        Spacer(),
                                        if (isSelected)
                                          Container(
                                            padding: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: colorScheme.primary,
                                              shape: BoxShape.circle,
                                            ),
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
              // Bottom action bar
              if (selectedWork != null)
                Container(
                  padding: EdgeInsets.all(res.wp(4)),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    border: Border(
                      top: BorderSide(
                        color: colorScheme.outline.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Optional message input
                        Container(
                          margin: EdgeInsets.only(bottom: res.hp(2)),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceVariant.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: colorScheme.outline.withOpacity(0.2),
                            ),
                          ),
                          child: TextField(
                            controller: _messageController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: 'Add a message for ${widget.fixerData.name.split(' ').first} (optional)',
                              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
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
                            onPressed: isSubmitting ? null : _submitRequest,
                            child: isSubmitting
                                ? SizedBox(
                                    height: res.sp(20),
                                    width: res.sp(20),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        colorScheme.onPrimary,
                                      ),
                                    ),
                                  )
                                : Text(
                                    'Send Request for "${selectedWork!.title}"',
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
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildImagePlaceholder(Responsive res, ColorScheme colorScheme) {
    return Container(
      width: res.wp(20),
      height: res.wp(20),
      color: colorScheme.outline.withOpacity(0.1),
      child: Icon(
        Icons.image_not_supported_outlined,
        color: colorScheme.outline,
        size: res.sp(24),
      ),
    );
  }

  Widget _buildLoadingView(Responsive res) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: res.hp(2)),
          Text(
            'Loading available works...',
            style: TextStyle(
              fontSize: res.sp(16),
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(Responsive res, ThemeData theme, String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(res.wp(8)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: res.sp(64),
              color: theme.colorScheme.error,
            ),
            SizedBox(height: res.hp(2)),
            Text(
              'Unable to load works',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: res.hp(1)),
            Text(
              'Please try again later',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: res.hp(3)),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {});
              },
              icon: Icon(Icons.refresh),
              label: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView(Responsive res, ThemeData theme) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(res.wp(8)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.work_off_outlined,
              size: res.sp(64),
              color: theme.colorScheme.outline,
            ),
            SizedBox(height: res.hp(2)),
            Text(
              'No Works Available',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: res.hp(1)),
            Text(
              '${widget.fixerData.name.split(' ').first} hasn\'t uploaded any works yet.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitRequest() async {
    if (selectedWork == null) return;

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      _showErrorSnackBar('Please login to send request');
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      // Check if request already exists
      final hasExisting = await _hireRequestRepository.hasExistingRequest(
        workId: selectedWork!.id,
        posterId: currentUser.uid,
      );

      if (hasExisting) {
        _showErrorSnackBar('You have already sent a request for this work');
        return;
      }

      // Get current user profile
      final posterProfile = await _userProfileService.getProfile(
        currentUser.uid, 
        'poster', // Assuming the person hiring is a poster
      );

      if (posterProfile == null) {
        _showErrorSnackBar('Unable to load your profile. Please complete your profile first.');
        return;
      }

      // Create hire request
      await _hireRequestRepository.createHireRequest(
        work: selectedWork!,
        fixer: widget.fixerData,
        poster: posterProfile,
        message: _messageController.text.trim().isEmpty 
            ? null 
            : _messageController.text.trim(),
      );

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Request sent to ${widget.fixerData.name.split(' ').first} for "${selectedWork!.title}"',
                  ),
                ),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 4),
          ),
        );
        
        // Navigate back
        Navigator.pop(context);
      }
    } catch (error) {
      _showErrorSnackBar('Failed to send request: ${error.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}