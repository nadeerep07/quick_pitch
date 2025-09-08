import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/core/utils/status_color_util.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/repository/hire_request_repository.dart';

class HireRequestsTab extends StatefulWidget {
  const HireRequestsTab({super.key});

  @override
  State<HireRequestsTab> createState() => _HireRequestsTabState();
}

class _HireRequestsTabState extends State<HireRequestsTab> {
  final HireRequestRepository _hireRequestRepository = HireRequestRepository();
  HireRequestStatus? _selectedFilter;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return _buildLoginRequired(res, theme);
    }

    return Column(
      children: [
        // Header with filter
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: res.wp(4),
            vertical: res.wp(3),
          ),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outline.withOpacity(0.2),
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
              Spacer(),
              _buildFilterButton(res, theme),
            ],
          ),
        ),

        // Requests list
        Expanded(
          child: StreamBuilder<List<HireRequest>>(
            stream: _hireRequestRepository.getFixerHireRequests(
              currentUser.uid,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingView(res);
              }

              if (snapshot.hasError) {
                return _buildErrorView(res, theme, snapshot.error.toString());
              }

              final allRequests = snapshot.data ?? [];
              final filteredRequests =
                  _selectedFilter == null
                      ? allRequests
                      : allRequests
                          .where((r) => r.status == _selectedFilter)
                          .toList();

              if (filteredRequests.isEmpty) {
                return _buildEmptyView(res, theme);
              }

              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                },
                child: ListView.builder(
                  padding: EdgeInsets.all(res.wp(2)),
                  itemCount: filteredRequests.length,
                  itemBuilder: (context, index) {
                    final request = filteredRequests[index];
                    return _buildRequestCard(request, res, theme);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterButton(Responsive res, ThemeData theme) {
    return PopupMenuButton<HireRequestStatus?>(
      icon: Icon(
        Icons.filter_list,
        size: res.wp(6),
        color:
            _selectedFilter != null
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
      ),
      onSelected: (status) {
        setState(() {
          _selectedFilter = status;
        });
      },
      itemBuilder:
          (context) => [
            PopupMenuItem<HireRequestStatus?>(
              value: null,
              child: Row(
                children: [
                  Icon(
                    _selectedFilter == null ? Icons.check : null,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  SizedBox(width: 8),
                  Text('All Requests'),
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
                          _selectedFilter == status ? Icons.check : null,
                          size: 20,
                          color: theme.colorScheme.primary,
                        ),
                        SizedBox(width: 8),
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
  ) {
    final colorScheme = theme.colorScheme;

    return Container(
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
                  backgroundImage:
                      request.posterImage.isNotEmpty
                          ? NetworkImage(request.posterImage)
                          : null,
                  child:
                      request.posterImage.isEmpty
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
                              '${request.workAmount.toStringAsFixed(0)}',
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
                              // 👈 This prevents overflow
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
                                  overflow:
                                      TextOverflow
                                          .ellipsis, // 👈 truncates long text
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

            // Message if available
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
                    ),
                  ],
                ),
              ),
            ],

            // Action buttons for pending requests
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
                      onPressed:
                          _isProcessing
                              ? null
                              : () => _showDeclineDialog(request),
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
                      onPressed:
                          _isProcessing ? null : () => _acceptRequest(request),
                      child:
                          _isProcessing
                              ? SizedBox(
                                height: res.sp(16),
                                width: res.sp(16),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                              : Text(
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
          ],
        ),
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
            'Loading hire requests...',
            style: TextStyle(fontSize: res.sp(16), color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(Responsive res, ThemeData theme, String error) {
    print(error);
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
    final filterText =
        _selectedFilter == null
            ? 'hire requests'
            : '${_selectedFilter!.displayName.toLowerCase()} requests';

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
            if (_selectedFilter != null) ...[
              SizedBox(height: res.hp(2)),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedFilter = null;
                  });
                },
                child: Text('View All Requests'),
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

  void _acceptRequest(HireRequest request) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      await _hireRequestRepository.acceptRequest(request.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Expanded(child: Text('Request accepted successfully!')),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to accept request: ${error.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _showDeclineDialog(HireRequest request) {
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Decline Request'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Are you sure you want to decline this request from ${request.posterName}?',
                ),
                SizedBox(height: 16),
                TextField(
                  controller: messageController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Optional: Add a reason for declining',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(context);
                  _declineRequest(request, messageController.text.trim());
                },
                child: Text('Decline', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }

  void _declineRequest(HireRequest request, String message) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      await _hireRequestRepository.declineRequest(
        request.id,
        message: message.isEmpty ? null : message,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.info, color: Colors.white),
                SizedBox(width: 8),
                Expanded(child: Text('Request declined')),
              ],
            ),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to decline request: ${error.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
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
