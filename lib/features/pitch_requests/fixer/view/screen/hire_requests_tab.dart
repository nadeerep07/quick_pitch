import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/core/utils/status_color_util.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/repository/hire_request_repository.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/view/screens/hire_request_detail_screen.dart';
import 'package:quick_pitch_app/features/pitch_requests/fixer/viewmodel/bloc/hire_requests_bloc.dart';
import 'package:quick_pitch_app/features/pitch_requests/fixer/viewmodel/bloc/hire_requests_event.dart';
import 'package:quick_pitch_app/features/pitch_requests/fixer/viewmodel/bloc/hire_requests_state.dart';

class HireRequestsTab extends StatelessWidget {
  const HireRequestsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final currentUser = FirebaseAuth.instance.currentUser;
        final bloc = HireRequestsBloc(
          hireRequestRepository: HireRequestRepository(),
        );
        if (currentUser != null) {
          bloc.add(LoadHireRequests(currentUser.uid));
        }
        return bloc;
      },
      child: const HireRequestsView(),
    );
  }
}

class HireRequestsView extends StatelessWidget {
  const HireRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return _buildLoginRequired(res, theme);
    }

    return BlocListener<HireRequestsBloc, HireRequestsState>(
      listener: (context, state) {
        if (state is RequestProcessingSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    state.message.contains('accepted') ? Icons.check_circle : Icons.info,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(state.message)),
                ],
              ),
              backgroundColor: state.message.contains('accepted') ? Colors.green : Colors.orange,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is RequestProcessingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Column(
        children: [
          // Header with filter
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: res.wp(4),
              vertical: res.wp(3),
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Hire Requests',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                BlocBuilder<HireRequestsBloc, HireRequestsState>(
                  builder: (context, state) {
                    HireRequestStatus? selectedFilter;
                    if (state is HireRequestsLoaded) {
                      selectedFilter = state.selectedFilter;
                    } else if (state is HireRequestsEmpty) {
                      selectedFilter = state.selectedFilter;
                    } else if (state is RequestProcessingSuccess) {
                      selectedFilter = state.selectedFilter;
                    } else if (state is RequestProcessingError) {
                      selectedFilter = state.selectedFilter;
                    }
                    
                    return _buildFilterButton(res, theme, selectedFilter, context);
                  },
                ),
              ],
            ),
          ),

          // Requests list
          Expanded(
            child: BlocBuilder<HireRequestsBloc, HireRequestsState>(
              builder: (context, state) {
                if (state is HireRequestsLoading) {
                  return _buildLoadingView(res);
                }

                if (state is HireRequestsError) {
                  return _buildErrorView(res, theme, state.message, context);
                }

                if (state is HireRequestsEmpty) {
                  return _buildEmptyView(res, theme, state.selectedFilter, context);
                }

                if (state is HireRequestsLoaded ||
                    state is RequestProcessingSuccess ||
                    state is RequestProcessingError) {
                  
                  List<HireRequest> filteredRequests = [];
                  bool isProcessing = false;
                  
                  if (state is HireRequestsLoaded) {
                    filteredRequests = state.filteredRequests;
                    isProcessing = state.isProcessing;
                  } else if (state is RequestProcessingSuccess) {
                    filteredRequests = state.filteredRequests;
                  } else if (state is RequestProcessingError) {
                    filteredRequests = state.filteredRequests;
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<HireRequestsBloc>().add(RefreshRequests(currentUser.uid));
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.all(res.wp(2)),
                      itemCount: filteredRequests.length,
                      itemBuilder: (context, index) {
                        final request = filteredRequests[index];
                        return _buildRequestCard(request, res, theme, context, isProcessing);
                      },
                    ),
                  );
                }

                return _buildEmptyView(res, theme, null, context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(
    Responsive res,
    ThemeData theme,
    HireRequestStatus? selectedFilter,
    BuildContext context,
  ) {
    return PopupMenuButton<HireRequestStatus?>(
      icon: Icon(
        Icons.filter_list,
        size: res.wp(6),
        color: selectedFilter != null
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface,
      ),
      onSelected: (status) {
        context.read<HireRequestsBloc>().add(FilterRequests(status));
      },
      itemBuilder: (context) => [
        PopupMenuItem<HireRequestStatus?>(
          value: null,
          child: Row(
            children: [
              Icon(
                selectedFilter == null ? Icons.check : null,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              const Text('All Requests'),
            ],
          ),
        ),
        ...HireRequestStatus.values
            .map(
              (status) => PopupMenuItem(
                value: status,
                child: Row(
                  children: [
                    Icon(
                      selectedFilter == status ? Icons.check : null,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(status.displayName),
                  ],
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  Widget _buildRequestCard(
    HireRequest request,
    Responsive res,
    ThemeData theme,
    BuildContext context,
    bool isProcessing,
  ) {
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        // Navigate to detail screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: context.read<HireRequestsBloc>(),
              child: HireRequestDetailScreen(request: request),
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: res.wp(3),
          vertical: res.wp(1.5),
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(res.wp(3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(res.wp(4)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with client info and status
              Row(
                children: [
                  CircleAvatar(
                    radius: res.wp(5),
                    backgroundImage: request.posterImage.isNotEmpty
                        ? NetworkImage(request.posterImage)
                        : null,
                    child: request.posterImage.isEmpty
                        ? Icon(Icons.person, size: res.wp(5))
                        : null,
                  ),
                  SizedBox(width: res.wp(3)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.posterName,
                          style: TextStyle(
                            fontSize: res.sp(16),
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: res.wp(0.5)),
                        Text(
                          _formatDate(request.createdAt),
                          style: TextStyle(
                            fontSize: res.sp(12),
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: res.wp(3),
                      vertical: res.wp(1),
                    ),
                    decoration: BoxDecoration(
                      color: StatusColorUtil.getStatusColor(
                        request.status.displayName,
                        theme,
                      ).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      request.status.displayName,
                      style: TextStyle(
                        fontSize: res.sp(12),
                        color: StatusColorUtil.getStatusColor(
                          request.status.displayName,
                          theme,
                        ),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: res.wp(3)),

              // Work details
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Work image
                  if (request.workImages.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        request.workImages.first,
                        width: res.wp(16),
                        height: res.wp(16),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: res.wp(16),
                            height: res.wp(16),
                            color: colorScheme.outline.withOpacity(0.1),
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: colorScheme.outline,
                            ),
                          );
                        },
                      ),
                    ),
                  SizedBox(width: res.wp(3)),

                  // Work info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.workTitle,
                          style: TextStyle(
                            fontSize: res.sp(16),
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (request.workDescription.isNotEmpty) ...[
                          SizedBox(height: res.wp(1)),
                          Text(
                            request.workDescription,
                            style: TextStyle(
                              fontSize: res.sp(14),
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        SizedBox(height: res.wp(2)),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: res.wp(2),
                                vertical: res.wp(0.5),
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '₹${request.workAmount.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: res.sp(14),
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                            if (request.workTime.isNotEmpty) ...[
                              SizedBox(width: res.wp(2)),
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: res.wp(2),
                                    vertical: res.wp(0.5),
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.secondaryContainer,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    request.workTime,
                                    style: TextStyle(
                                      fontSize: res.sp(12),
                                      color: colorScheme.onSecondaryContainer,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Message if available (truncated)
              if (request.message != null && request.message!.isNotEmpty) ...[
                SizedBox(height: res.wp(3)),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(res.wp(3)),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Message:',
                        style: TextStyle(
                          fontSize: res.sp(12),
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      SizedBox(height: res.wp(1)),
                      Text(
                        request.message!,
                        style: TextStyle(
                          fontSize: res.sp(14),
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],

              // Quick action buttons for pending requests only
              if (request.status.canRespond) ...[
                SizedBox(height: res.wp(3)),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: colorScheme.outline),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: res.wp(2.5)),
                        ),
                        onPressed: isProcessing
                            ? null
                            : () => _showDeclineDialog(request, context),
                        child: Text(
                          'Decline',
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: res.wp(3)),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: res.wp(2.5)),
                        ),
                        onPressed: isProcessing
                            ? null
                            : () => context
                                .read<HireRequestsBloc>()
                                .add(AcceptRequest(request.id)),
                        child: isProcessing
                            ? SizedBox(
                                height: res.sp(16),
                                width: res.sp(16),
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Accept',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ],

              // Tap to view more hint
              SizedBox(height: res.wp(2)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.touch_app,
                    size: res.sp(14),
                    color: colorScheme.onSurface.withOpacity(0.5),
                  ),
                  SizedBox(width: res.wp(1)),
                  Text(
                    'Tap for details',
                    style: TextStyle(
                      fontSize: res.sp(12),
                      color: colorScheme.onSurface.withOpacity(0.5),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingView(Responsive res) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: res.hp(2)),
          Text(
            'Loading hire requests...',
            style: TextStyle(fontSize: res.sp(16), color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(Responsive res, ThemeData theme, String error, BuildContext context) {
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
              'Unable to load requests',
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
                final currentUser = FirebaseAuth.instance.currentUser;
                if (currentUser != null) {
                  context.read<HireRequestsBloc>().add(LoadHireRequests(currentUser.uid));
                }
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView(Responsive res, ThemeData theme, HireRequestStatus? selectedFilter, BuildContext context) {
    final filterText = selectedFilter == null
        ? 'hire requests'
        : '${selectedFilter.displayName.toLowerCase()} requests';

    return Center(
      child: Padding(
        padding: EdgeInsets.all(res.wp(8)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: res.sp(64),
              color: theme.colorScheme.outline,
            ),
            SizedBox(height: res.hp(2)),
            Text(
              'No Requests',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: res.hp(1)),
            Text(
              'You don\'t have any $filterText yet.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            if (selectedFilter != null) ...[
              SizedBox(height: res.hp(2)),
              TextButton(
                onPressed: () {
                  context.read<HireRequestsBloc>().add(const FilterRequests(null));
                },
                child: const Text('View All Requests'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoginRequired(Responsive res, ThemeData theme) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(res.wp(8)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.login,
              size: res.sp(64),
              color: theme.colorScheme.outline,
            ),
            SizedBox(height: res.hp(2)),
            Text(
              'Please Login',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: res.hp(1)),
            Text(
              'You need to be logged in to view hire requests.',
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

  void _showDeclineDialog(HireRequest request, BuildContext context) {
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Decline Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to decline this request from ${request.posterName}?',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: messageController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Optional: Add a reason for declining',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<HireRequestsBloc>().add(
                DeclineRequest(
                  request.id,
                  message: messageController.text.trim().isEmpty 
                      ? null 
                      : messageController.text.trim(),
                ),
              );
            },
            child: const Text('Decline', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}
