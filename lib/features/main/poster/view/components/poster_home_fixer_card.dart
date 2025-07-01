import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class poster_home_fixer_card extends StatelessWidget {
  const poster_home_fixer_card({
    super.key,
    required this.res,
    required this.name,
    required this.skill,
  });

  final Responsive res;
  final String name;
  final String skill;

  @override
  Widget build(BuildContext context) {
  return Container(
    width: res.wp(40),
    margin: EdgeInsets.only(right: res.wp(4)),
    padding: EdgeInsets.all(res.wp(3)),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=$name'),
          radius: 24,
        ),
        SizedBox(height: 8),
        Text(name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: res.sp(14),
            )),
        Text(skill,
            style: TextStyle(
              fontSize: res.sp(12),
              color: Colors.grey[600],
            )),
      ],
    ),
  );
}
}
