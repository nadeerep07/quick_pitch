import 'package:flutter/material.dart';

class SkillsList extends StatelessWidget {
  final ValueNotifier<List<String>> filtered;
  final ValueNotifier<List<String>> selected;
  final bool isDarkMode;
  final Color primaryColor;
  final Function(String) onToggleSkill;

  const SkillsList({super.key, 
    required this.filtered,
    required this.selected,
    required this.isDarkMode,
    required this.primaryColor,
    required this.onToggleSkill,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder<List<String>>(
      valueListenable: filtered,
      builder: (context, filteredSkills, _) {
        return ValueListenableBuilder<List<String>>(
          valueListenable: selected,
          builder: (context, selectedSkills, _) {
            if (filteredSkills.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 48,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "No matching skills found",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: filteredSkills.map((skill) {
                  final isSelected = selectedSkills.contains(skill);
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              )
                            ]
                          : null,
                    ),
                    child: FilterChip(
                      label: Text(
                        skill,
                        style: TextStyle(
                          color: isSelected
                              ? primaryColor
                              : isDarkMode
                                  ? Colors.white
                                  : Colors.black87,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (_) => onToggleSkill(skill),
                      selectedColor: primaryColor.withOpacity(0.15),
                      checkmarkColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected
                              ? primaryColor
                              : isDarkMode
                                  ? Colors.grey[700]!
                                  : Colors.grey[300]!,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      backgroundColor: isDarkMode
                          ? Colors.grey[800]!.withOpacity(0.6)
                          : Colors.white,
                    ),
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }
}
