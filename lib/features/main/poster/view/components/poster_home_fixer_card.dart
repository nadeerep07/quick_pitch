import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/main/poster/viewmodel/home/cubit/poster_home_cubit.dart';
import 'package:quick_pitch_app/features/user_details/fixer/view/screen/fixer_detail_screen.dart';

class PosterHomeFixerCard extends StatelessWidget {
  const PosterHomeFixerCard({
    super.key,
    required this.context,
    required this.res,
    required this.fixer,
  });

  final BuildContext context;
  final Responsive res;
  final dynamic fixer;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FixerDetailScreen(fixerData: fixer),
          ),
        ).then((shouldRefresh) {
          if (shouldRefresh == true && context.mounted) {
            context.read<PosterHomeCubit>().streamPosterHomeData();
          }
        });
      },
      child: Container(
        width: res.wp(32),
        padding: EdgeInsets.all(res.wp(3)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            // Fixer Avatar
            CircleAvatar(
              radius: res.wp(6),
              backgroundColor: const Color(0xFFF1F5F9),
              backgroundImage: NetworkImage(
                fixer.profileImageUrl ?? 'https://i.pravatar.cc/150?img=3',
              ),
              child:
                  fixer.profileImageUrl == null
                      ? Icon(
                        Icons.person,
                        color: const Color(0xFF94A3B8),
                        size: res.wp(6),
                      )
                      : null,
            ),

            SizedBox(height: res.hp(1)),

            // Fixer Name
            Text(
              fixer.name,
              style: TextStyle(
                fontSize: res.sp(12),
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E293B),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: res.hp(0.5)),

            // Fixer Skill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                fixer.fixerData?.skills?.first ?? 'General',
                style: TextStyle(
                  fontSize: res.sp(10),
                  color: const Color(0xFF3B82F6),
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
