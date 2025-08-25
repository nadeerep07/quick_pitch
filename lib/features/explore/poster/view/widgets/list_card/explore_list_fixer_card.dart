import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/list_card/fixer_card_skills.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/list_card/fixer_card_works_button.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/list_card/fixer_list_card_header.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';


class ExploreListFixerCard extends StatelessWidget {
  final UserProfileModel fixer;
  final Position? posterLocation;

  const ExploreListFixerCard({
    super.key,
    required this.fixer,
    required this.posterLocation,
  });

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return Container(
      margin: EdgeInsets.only(bottom: res.hp(2)),
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(res.wp(4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: res.wp(4),
                offset: Offset(0, res.hp(0.5)),
              ),
            ],
          ),
          padding: EdgeInsets.all(res.wp(4.5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FixerCardHeader(fixer: fixer, posterLocation: posterLocation),
              SizedBox(height: res.hp(2.5)),
              FixerCardSkills(fixer: fixer),
              SizedBox(height: res.hp(2.5)),
              FixerCardWorksButton(fixer: fixer),
            ],
          ),
        ),
      ),
    );
  }
}
