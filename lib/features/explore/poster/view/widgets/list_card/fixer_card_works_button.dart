import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/explore/poster/view/screen/fixer_work_page.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class FixerCardWorksButton extends StatelessWidget {
  final UserProfileModel fixer;

  const FixerCardWorksButton({super.key, required this.fixer});

  Future<int> _getWorksCount() async {
    try {
      final query = await FirebaseFirestore.instance
          .collection('fixer_works')
          .where('fixerId', isEqualTo: fixer.uid)
          .get();
      return query.docs.length;
    } catch (_) {
      return 0;
    }
  }

  void _navigateToAllWorks(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FixerWorksPage(fixer: fixer)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return FutureBuilder<int>(
      future: _getWorksCount(),
      builder: (context, snapshot) {
        final worksCount = snapshot.data ?? 0;

        return GestureDetector(
          onTap: worksCount > 0 ? () => _navigateToAllWorks(context) : null,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: res.hp(1.8),
              horizontal: res.wp(4),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: worksCount > 0
                    ? [Colors.green[100]!, Colors.green[50]!]
                    : [Colors.grey[100]!, Colors.grey[50]!],
              ),
              borderRadius: BorderRadius.circular(res.wp(3)),
              border: Border.all(
                color: worksCount > 0
                    ? Colors.green.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  worksCount > 0 ? Icons.work_rounded : Icons.work_outline_rounded,
                  size: res.sp(18),
                  color: worksCount > 0 ? Colors.green[700] : Colors.grey[600],
                ),
                SizedBox(width: res.wp(2)),
                Text(
                  snapshot.connectionState == ConnectionState.waiting
                      ? 'Loading...'
                      : worksCount > 0
                          ? 'View Fixer Works ($worksCount)'
                          : 'No works uploaded',
                  style: TextStyle(
                    fontSize: res.sp(15),
                    fontWeight: FontWeight.w600,
                    color: worksCount > 0 ? Colors.green[700] : Colors.grey[600],
                    letterSpacing: 0.1,
                  ),
                ),
                if (worksCount > 0) ...[
                  SizedBox(width: res.wp(2)),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: res.sp(14),
                    color: Colors.green[700],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
