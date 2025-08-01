import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class FixerDetailPosterCard extends StatelessWidget {
  const FixerDetailPosterCard({
    super.key,
    required this.poster,
    required this.res,
  });

  final UserProfileModel poster;
  final Responsive res;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(res.hp(1.5)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
      ),
      child: Row(
        children: [
               ClipRRect(
            borderRadius: BorderRadius.circular(80), // circular profile image
            child: poster.profileImageUrl != null
                ? FadeInImage.assetNetwork(
                    placeholder: 'assets/images/avatar_photo_placeholder.jpg',
                    image: poster.profileImageUrl!,
                    width: res.wp(12),
                    height: res.wp(12),
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    "assets/images/avatar_photo_placeholder.jpg",
                    width: res.wp(12),
                    height: res.wp(12),
                    fit: BoxFit.cover,
                  ),
          ),
          SizedBox(width: res.wp(4)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(poster.name, style: TextStyle(fontSize: res.sp(13), fontWeight: FontWeight.w600)),
              Text("Member since ${DateFormat.yMMMM().format(poster.createdAt)}",
                  style: TextStyle(fontSize: res.sp(11), color: Colors.grey[600])),
            ],
          )
        ],
      ),
    );
  }
}
