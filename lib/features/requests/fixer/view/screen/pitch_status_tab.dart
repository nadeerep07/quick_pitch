import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class PitchStatusTab extends StatelessWidget {
  const PitchStatusTab({super.key});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final List<Map<String, dynamic>> pitches = [
      {
        'jobTitle': 'Website Development',
        'client': 'Chin Chan',
        'status': 'accepted',
        'date': '2023-05-15',
        'clientImage': 'https://randomuser.me/api/portraits/men/45.jpg',
        'budget': '\$2,500',
        'duration': '3 months',
      },
      {
        'jobTitle': 'Mobile App Design',
        'client': 'Juline',
        'status': 'rejected',
        'date': '2023-05-10',
        'clientImage': 'https://randomuser.me/api/portraits/women/32.jpg',
        'budget': '\$1,800',
        'duration': '2 months',
      },
      {
        'jobTitle': 'SEO Optimization',
        'client': 'John',
        'status': 'pending',
        'date': '2023-05-18',
        'clientImage': 'https://randomuser.me/api/portraits/men/68.jpg',
        'budget': '\$1,200',
        'duration': '1 month',
      },
    ];

    return Column(
      children: [
        SizedBox(height: res.wp(3)),

        // Status summary chips
        SizedBox(
          height: res.wp(12),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: res.wp(4)),
            children: [
              _buildSummaryChip('All', 3, res, theme, isActive: true),
              SizedBox(width: res.wp(2)),
              _buildSummaryChip('Accepted', 1, res, theme),
              SizedBox(width: res.wp(2)),
              _buildSummaryChip('Pending', 1, res, theme),
              SizedBox(width: res.wp(2)),
              _buildSummaryChip('Declined', 1, res, theme),
            ],
          ),
        ),

        SizedBox(height: res.wp(3)),

        // Pitches list
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              // Add refresh functionality
              await Future.delayed(const Duration(seconds: 1));
            },
            child: ListView.separated(
              padding: EdgeInsets.fromLTRB(res.wp(4), 0, res.wp(4), res.wp(4)),
              itemCount: pitches.length,
              separatorBuilder: (context, index) => SizedBox(height: res.wp(3)),
              itemBuilder: (context, index) {
                final pitch = pitches[index];
                return _buildPitchCard(pitch, res, theme, isDark);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPitchCard(
    Map<String, dynamic> pitch,
    Responsive res,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(res.wp(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with client info and status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Client avatar with online indicator
                Stack(
                  children: [
                    CircleAvatar(
                      radius: res.wp(6),
                      backgroundImage: NetworkImage(pitch['clientImage']),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: res.wp(3),
                        height: res.wp(3),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.cardColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(width: res.wp(3)),

                // Client info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pitch['client'],
                        style: TextStyle(
                          fontSize: res.sp(16),
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryText,
                        ),
                      ),
                      SizedBox(height: res.wp(1)),
                      Text(
                        'Submitted ${_formatDate(pitch['date'])}',
                        style: TextStyle(
                          fontSize: res.sp(12),
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),

                // Status indicator
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: res.wp(3),
                        vertical: res.wp(1),
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          pitch['status'],
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: res.wp(2),
                            height: res.wp(2),
                            decoration: BoxDecoration(
                              color: _getStatusColor(pitch['status']),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: res.wp(1.5)),
                          Text(
                            pitch['status'].toString().toUpperCase(),
                            style: TextStyle(
                              fontSize: res.sp(10),
                              fontWeight: FontWeight.w600,
                              color: _getStatusColor(pitch['status']),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: res.wp(1)),
                    Text(
                      pitch['duration'],
                      style: TextStyle(
                        fontSize: res.sp(12),
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: res.wp(4)),

            // Job title
            Text(
              pitch['jobTitle'],
              style: TextStyle(
                fontSize: res.sp(18),
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),

            SizedBox(height: res.wp(3)),

            // Divider
            Divider(height: 1, color: theme.dividerColor.withOpacity(0.2)),

            SizedBox(height: res.wp(3)),

            // Footer with budget and actions
            Row(
              children: [
                // Budget
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: res.wp(3),
                    vertical: res.wp(1.5),
                  ),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: pitch['budget'],
                          style: TextStyle(
                            fontSize: res.sp(16),
                            fontWeight: FontWeight.w700,
                            color: theme.primaryColor,
                          ),
                        ),
                        TextSpan(
                          text: ' total budget',
                          style: TextStyle(
                            fontSize: res.sp(12),
                            color: theme.primaryColor.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Action buttons
                if (pitch['status'] == 'accepted')
                  _buildActionButton(
                    'View Details',
                    res,
                    theme,
                  ),
                if (pitch['status'] == 'rejected')
                  _buildActionButton(
                    'View Feedback',
                    res,
                    theme,
                  ),
                if (pitch['status'] == 'pending')
                  _buildActionButton('Re-Pitch', res, theme),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    Responsive res,
    ThemeData theme,
  ) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: res.wp(2),
          vertical: res.wp(1),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: res.sp(12), color: theme.primaryColor),
      ),
    );
  }

  Widget _buildSummaryChip(
    String label,
    int count,
    Responsive res,
    ThemeData theme, {
    bool isActive = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isActive ? theme.primaryColor : theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: isActive ? null : Border.all(color: theme.dividerColor),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: res.wp(4),
          vertical: res.wp(2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: res.sp(12),
                fontWeight: FontWeight.w500,
                color: isActive ? Colors.white : theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(width: res.wp(1.5)),
            Container(
              padding: EdgeInsets.all(res.wp(1)),
              decoration: BoxDecoration(
                color:
                    isActive
                        ? Colors.white
                        : theme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: res.sp(10),
                  fontWeight: FontWeight.bold,
                  color: isActive ? theme.primaryColor : theme.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(String date) {
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('MMM d, y').format(parsedDate);
    } catch (e) {
      return date;
    }
  }
}
