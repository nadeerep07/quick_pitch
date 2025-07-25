import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/main/fixer/view/screens/components/home_card/card_budget.dart';
import 'package:quick_pitch_app/features/main/fixer/view/screens/components/home_card/card_description.dart';
import 'package:quick_pitch_app/features/main/fixer/view/screens/components/home_card/card_image.dart';
import 'package:quick_pitch_app/features/main/fixer/view/screens/components/home_card/card_location.dart';
import 'package:quick_pitch_app/features/main/fixer/view/screens/components/home_card/skills_required.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String postedTime;
  final String budget;
  final String description;
  final String location;
  final List skills;
  final List<String>? imageUrls;
  final VoidCallback onTap;

  const TaskCard({
    super.key,
    required this.title,
    required this.postedTime,
    required this.budget,
    required this.description,
    required this.location,
    required this.skills,
    required this.onTap,
    this.imageUrls,
  });

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: res.hp(2)),
        padding: EdgeInsets.all(res.hp(1.5)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardImage(imageUrls: imageUrls, res: res),
            SizedBox(width: res.wp(4)),
            Expanded(child: _buildContent(res)),
          ],
        ),
      ),
    );
  }

  ///  Right Content Section
  Widget _buildContent(Responsive res) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPostedTime(res),
        SizedBox(height: res.hp(0.3)),
        _buildTitleAndActions(res),
        SizedBox(height: res.hp(0.4)),
        CardBudget(budget: budget, res: res),
        SizedBox(height: res.hp(0.4)),
        CardDescription(description: description, res: res),
        SizedBox(height: res.hp(0.4)),
        SkillsRequired(skills: skills, res: res),
        SizedBox(height: res.hp(0.6)),
        CardLocation(location: location, res: res),
      ],
    );
  }

  Widget _buildPostedTime(Responsive res) {
    return Text(
      'Posted $postedTime ago',
      style: TextStyle(fontSize: res.sp(11), color: Colors.grey[600]),
    );
  }

  Widget _buildTitleAndActions(Responsive res) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: res.sp(14.5),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(width: 4),
      ],
    );
  }
}
