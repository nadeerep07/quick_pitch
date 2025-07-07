import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class PosterHomeFixerCard extends StatelessWidget {
  const PosterHomeFixerCard({
    super.key,
    required this.res,
    required this.name,
    required this.skill,
    required this.imageUrl,
  });

  final Responsive res;
  final String name;
  final String skill;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: res.wp(40),
      margin: EdgeInsets.only(right: res.wp(4)),
      padding: EdgeInsets.all(res.wp(4)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: CircleAvatar(
              radius: res.wp(10),
              backgroundColor: Colors.grey[200],
              child: CircleAvatar(
                radius: res.wp(9),
                backgroundImage: NetworkImage(imageUrl),
              ),
            ),
          ),
          SizedBox(height: res.hp(1.5)),
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: res.sp(14),
            ),
          ),
          SizedBox(height: res.hp(0.5)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: res.wp(2.5),
              vertical: res.hp(0.5),
            ),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              skill,
              style: TextStyle(
                fontSize: res.sp(11),
                color: Colors.blue.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
