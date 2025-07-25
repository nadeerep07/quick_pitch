import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/main/fixer/view/screens/components/shimmer_widget.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class FixerHomeShimmer extends StatelessWidget {
  final Responsive res;
  const FixerHomeShimmer({super.key, required this.res});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Top Profile Section
          Row(
            children: [
              ShimmerWidget.circular(width: res.wp(15), height: res.wp(15)),
              SizedBox(width: res.wp(4)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerWidget.rect(width: res.wp(30), height: res.hp(2.5)),
                  SizedBox(height: res.hp(1)),
                  ShimmerWidget.rect(width: res.wp(15), height: res.hp(2)),
                ],
              ),
              const Spacer(),
              ShimmerWidget.circular(width: res.wp(8), height: res.wp(8)),
            ],
          ),
          SizedBox(height: res.hp(2)),

          // Filter Chips Row
          SizedBox(
            height: res.hp(5),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (_, __) => Padding(
                padding: EdgeInsets.symmetric(horizontal: res.wp(2)),
                child: ShimmerWidget.rect(width: res.wp(18), height: res.hp(4)),
              ),
            ),
          ),
          SizedBox(height: res.hp(2)),

          // Task Cards
          ListView.builder(
            itemCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, __) => Padding(
              padding: EdgeInsets.only(bottom: res.hp(2)),
              child: Container(
                padding: EdgeInsets.all(res.wp(3)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(res.wp(4)),
                ),
                child: Row(
                  children: [
                    // Image Placeholder
                    ShimmerWidget.rect(
                      width: res.wp(20),
                      height: res.wp(20),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    SizedBox(width: res.wp(3)),
                    // Text & Tags
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerWidget.rect(width: res.wp(30), height: res.hp(2)),
                          SizedBox(height: res.hp(1)),
                          ShimmerWidget.rect(width: res.wp(20), height: res.hp(2)),
                          SizedBox(height: res.hp(1)),
                          Row(
                            children: [
                              ShimmerWidget.rect(width: res.wp(15), height: res.hp(3)),
                              SizedBox(width: res.wp(2)),
                              ShimmerWidget.rect(width: res.wp(15), height: res.hp(3)),
                            ],
                          ),
                          SizedBox(height: res.hp(1)),
                          ShimmerWidget.rect(width: res.wp(40), height: res.hp(2)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
