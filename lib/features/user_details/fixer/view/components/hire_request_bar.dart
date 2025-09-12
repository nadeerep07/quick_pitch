import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/view/screen/fixer_work_selection_screen.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class HireRequestBar extends StatelessWidget {
final UserProfileModel fixerData;
  final bool isLoading;

  const HireRequestBar({
    super.key,
    required this.fixerData,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
        padding: EdgeInsets.all(res.wp(4)),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: colorScheme.outline.withValues(alpha:0.2),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: res.hp(1.5)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FixerWorkSelectionScreen(
                          fixerData: fixerData,
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.work_outline,
                    color: colorScheme.onPrimary,
                    size: res.sp(18),
                  ),
                  label: Text(
                    'Hire ${fixerData.name.split(' ').first}',
                    style: TextStyle(
                      fontSize: res.sp(14),
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}