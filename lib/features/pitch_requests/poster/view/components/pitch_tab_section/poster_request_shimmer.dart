import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class RequestShimmer extends StatelessWidget {
  const RequestShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return ListView.builder(
      padding: EdgeInsets.all(res.wp(4)),
      itemCount: 8, // number of shimmer cards
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: res.hp(2)),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: res.hp(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(res.wp(4)),
              ),
            ),
          ),
        );
      },
    );
  }
}
