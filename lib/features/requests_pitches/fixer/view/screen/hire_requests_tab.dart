import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class HireRequestsTab extends StatelessWidget {
  const HireRequestsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    final List<Map<String, dynamic>> requests = [
      {
        'jobTitle': 'Social Media Management',
        'client': 'Sara',
        'date': '2023-05-16',
        'budget': '\$500',
        'status': 'Pending', // Added status field
        'clientImage': 'https://randomuser.me/api/portraits/women/45.jpg',
      },
      {
        'jobTitle': 'Logo Design',
        'client': 'John',
        'date': '2023-05-12',
        'budget': '\$300',
        'status': 'New',
        'clientImage': 'https://randomuser.me/api/portraits/men/32.jpg',
      },
      {
        'jobTitle': 'Content Writing',
        'client': 'Yana',
        'date': '2023-05-19',
        'budget': '\$200',
        'status': 'Pending',
        'clientImage': 'https://randomuser.me/api/portraits/women/68.jpg',
      },
    ];

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: res.wp(4),
            vertical: res.wp(3),
          ),
          child: Row(
            children: [
              const Spacer(),
              IconButton(
                icon: Icon(Icons.filter_list, size: res.wp(6)),
                onPressed: () {},
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: res.wp(2)),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return Container(
                margin: EdgeInsets.symmetric(
                  horizontal: res.wp(3),
                  vertical: res.wp(1.5),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(res.wp(3)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(res.wp(3)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with client info
                      Row(
                        children: [
                          CircleAvatar(
                            radius: res.wp(5),
                            backgroundImage: NetworkImage(
                              request['clientImage'],
                            ),
                          ),
                          SizedBox(width: res.wp(3)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  request['client'],
                                  style: TextStyle(
                                    fontSize: res.sp(16),
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryText,
                                  ),
                                ),
                                SizedBox(height: res.wp(0.5)),
                                Text(
                                  'Posted ${request['date']}',
                                  style: TextStyle(
                                    fontSize: res.sp(12),
                                    color: AppColors.secondaryText,
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
                              color: _getStatusColor(
                                request['status'],
                              ).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              request['status'],
                              style: TextStyle(
                                fontSize: res.sp(12),
                                color: _getStatusColor(request['status']),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: res.wp(4)),

                      // Job title
                      Text(
                        request['jobTitle'],
                        style: TextStyle(
                          fontSize: res.sp(18),
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                        ),
                      ),
                      SizedBox(height: res.wp(3)),

                      // Budget and actions
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: res.wp(3),
                              vertical: res.wp(1.5),
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withValues(alpha: .1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              request['budget'],
                              style: TextStyle(
                                fontSize: res.sp(16),
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                          const Spacer(),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: res.wp(4),
                                vertical: res.wp(2),
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              'Decline',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(width: res.wp(2)),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: res.wp(4),
                                vertical: res.wp(2),
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              'Accept',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'new':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.green;
      case 'declined':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
