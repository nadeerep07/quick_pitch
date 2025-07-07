import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class FixerHomeScreen extends StatelessWidget {
  const FixerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: res.wp(5),
            vertical: res.hp(2),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 👤 Header
                Row(
                  children: [
                    CircleAvatar(
                      radius: res.hp(3.5),
                      backgroundImage:
                          AssetImage('assets/images/default_user.png'),
                    ),
                    SizedBox(width: res.wp(3)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, Fixer 👋',
                          style: TextStyle(
                            fontSize: res.sp(18),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'FIXER',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: res.sp(12),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),

                SizedBox(height: res.hp(3)),

                // 🔥 Featured / New Tasks List
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'New Tasks For You',
                      style: TextStyle(
                        fontSize: res.sp(18),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Open filter dialog
                      },
                      icon: Icon(Icons.filter_list_outlined),
                    ),
                  ],
                ),
                SizedBox(height: res.hp(1.5)),

                // 🔥 Featured Task Cards (List)
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 3, // mock count
                  itemBuilder: (_, index) => Container(
                    margin: EdgeInsets.only(bottom: res.hp(2)),
                    padding: EdgeInsets.all(res.hp(2)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fix AC urgently',
                          style: TextStyle(
                            fontSize: res.sp(16),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: res.hp(1)),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined,
                                size: res.sp(14), color: Colors.grey[700]),
                            SizedBox(width: 6),
                            Text(
                              'Kochi, Kerala',
                              style: TextStyle(
                                fontSize: res.sp(13),
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: res.hp(1)),
                        Text(
                          'Budget: ₹500',
                          style: TextStyle(
                            fontSize: res.sp(13),
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: res.hp(1.5)),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigate to details
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text('View Task'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Divider
                SizedBox(height: res.hp(3)),

                // 📋 Your Active Tasks
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Active Tasks',
                      style: TextStyle(
                        fontSize: res.sp(18),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to task list
                      },
                      child: Text('See All'),
                    )
                  ],
                ),
                SizedBox(height: res.hp(1.5)),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 2,
                  itemBuilder: (_, index) => Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    margin: EdgeInsets.only(bottom: res.hp(2)),
                    child: ListTile(
                      leading: Icon(Icons.build_circle_outlined),
                      title: Text('Fix TV'),
                      subtitle: Text('Status: In Progress'),
                      trailing: Icon(Icons.arrow_forward_ios, size: res.sp(14)),
                      onTap: () {
                        // Navigate to detail
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
