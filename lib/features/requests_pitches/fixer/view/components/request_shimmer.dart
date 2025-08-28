import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';

class RequestsShimmer extends StatelessWidget {
  final Responsive res;
  
  const RequestsShimmer({super.key, required this.res});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(res.wp(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pitch Status header
            _buildSectionShimmer(height: res.wp(5), width: res.wp(30)),
            SizedBox(height: res.wp(3)),
            
            // Status chips
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildChipShimmer(width: res.wp(25)),
                _buildChipShimmer(width: res.wp(25)),
                _buildChipShimmer(width: res.wp(25)),
              ],
            ),
            SizedBox(height: res.wp(5)),
            
            // Divider
            Container(height: 1, color: Colors.grey[200]),
            SizedBox(height: res.wp(5)),
            
            // Request items (3 items like in screenshot)
            _buildRequestItemShimmer(),
            SizedBox(height: res.wp(4)),
            _buildRequestItemShimmer(),
            SizedBox(height: res.wp(4)),
            _buildRequestItemShimmer(),
            SizedBox(height: res.wp(5)),
            
            // Bottom navigation placeholder
            Container(
              height: res.wp(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionShimmer({required double height, required double width}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildChipShimmer({required double width}) {
    return Container(
      width: width,
      height: res.wp(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _buildRequestItemShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // User info row
        Row(
          children: [
            Container(
              width: res.wp(10),
              height: res.wp(10),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: res.wp(3)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionShimmer(
                  height: res.wp(4),
                  width: res.wp(40),
                ),
                SizedBox(height: res.wp(1)),
                _buildSectionShimmer(
                  height: res.wp(3.5),
                  width: res.wp(30),
                ),
              ],
            ),
            const Spacer(),
            _buildChipShimmer(width: res.wp(20)),
          ],
        ),
        SizedBox(height: res.wp(4)),
        
        // Pitch content (3 lines with varying widths)
        _buildSectionShimmer(
          height: res.wp(4),
          width: double.infinity,
        ),
        SizedBox(height: res.wp(2)),
        _buildSectionShimmer(
          height: res.wp(4),
          width: res.wp(80),
        ),
        SizedBox(height: res.wp(2)),
        _buildSectionShimmer(
          height: res.wp(4),
          width: res.wp(60),
        ),
        SizedBox(height: res.wp(4)),
        
        // Budget and timeline
        Row(
          children: [
            _buildSectionShimmer(
              height: res.wp(4),
              width: res.wp(25),
            ),
            SizedBox(width: res.wp(4)),
            _buildSectionShimmer(
              height: res.wp(4),
              width: res.wp(25),
            ),
          ],
        ),
        SizedBox(height: res.wp(4)),
        
        // Divider
        Container(height: 1, color: Colors.white),
      ],
    );
  }
}