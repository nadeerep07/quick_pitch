import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/bubble_background_painter.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/confirm_button.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/drag_handle.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/header_section.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/search_field.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/skills_list.dart';

class AllSkillsBottomSheet extends StatelessWidget {
  final List<String> skills;
  final List<String> selectedSkills;
  final Function(String) onToggleSkill;

  const AllSkillsBottomSheet({
    super.key,
    required this.skills,
    required this.selectedSkills,
    required this.onToggleSkill,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;
    final isDarkMode = theme.brightness == Brightness.dark;

    final searchController = TextEditingController();
    final selected = ValueNotifier<List<String>>(List.from(selectedSkills));
    final filtered = ValueNotifier<List<String>>(List.from(skills));

    searchController.addListener(() {
      final query = searchController.text.toLowerCase();
      filtered.value =
          skills.where((s) => s.toLowerCase().contains(query)).toList();
    });

    void toggleSkill(String skill) {
      final current = List<String>.from(selected.value);
      if (current.contains(skill)) {
        current.remove(skill);
      } else {
        current.add(skill);
      }
      selected.value = current;
      onToggleSkill(skill);
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        color: isDarkMode ? Colors.grey[900] : Colors.white,
      ),
      child: Stack(
        children: [
          // Background
          Positioned.fill(
            child: CustomPaint(
              painter: BubbleBackgroundPainter(
                primaryColor: primaryColor.withValues(alpha:0.1),
                secondaryColor: secondaryColor.withValues(alpha:0.05),
                isDarkMode: isDarkMode,
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(
              top: 24,
              left: 24,
              right: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DragHandle(isDarkMode: isDarkMode),
                const SizedBox(height: 20),
                HeaderSection(theme: theme, isDarkMode: isDarkMode, primaryColor: primaryColor),
                const SizedBox(height: 24),
                SearchField(controller: searchController, isDarkMode: isDarkMode),
                const SizedBox(height: 24),
                Expanded(
                  child: SkillsList(
                    filtered: filtered,
                    selected: selected,
                    isDarkMode: isDarkMode,
                    primaryColor: primaryColor,
                    onToggleSkill: toggleSkill,
                  ),
                ),
                const SizedBox(height: 24),
                ConfirmButton(primaryColor: primaryColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
