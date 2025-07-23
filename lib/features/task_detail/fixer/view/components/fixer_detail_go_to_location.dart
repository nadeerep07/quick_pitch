import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/task_detail/fixer/viewmodel/cubit/fixer_detail_cubit.dart';

class FixerDetailGoToLocation extends StatelessWidget {
  const FixerDetailGoToLocation({
    super.key,
    required this.context,
    required this.label,
    required this.location,
    required this.res,
  });

  final BuildContext context;
  final String label;
  final String location;
  final Responsive res;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: res.sp(13), fontWeight: FontWeight.w600),
        ),
        SizedBox(height: res.hp(1)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                location,
                style: TextStyle(fontSize: res.sp(13)),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ElevatedButton.icon(
              onPressed:
                  () => context.read<FixerDetailCubit>().launchMaps(location),
              icon: const Icon(Icons.location_on_outlined),
              label: const Text("View on Map"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: res.wp(3),
                  vertical: res.hp(1),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
