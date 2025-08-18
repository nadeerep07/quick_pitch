import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/explore/poster/view/components/bubble_background_painter.dart';

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
      filtered.value = skills.where((s) => s.toLowerCase().contains(query)).toList();
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
          // Custom painted background
          Positioned.fill(
            child: CustomPaint(
              painter: BubbleBackgroundPainter(
                primaryColor: primaryColor.withOpacity(0.1),
                secondaryColor: secondaryColor.withOpacity(0.05),
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
                // Draggable handle
                Center(
                  child: Container(
                    width: 48,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[600] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Header with decorative elements
                Stack(
                  children: [
                    Positioned(
                      right: 0,
                      top: -10,
                      child: Icon(
                        Icons.auto_awesome,
                        size: 40,
                        color: primaryColor.withOpacity(0.3),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Build Your Skills",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Select the skills you want to highlight",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Search field
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: isDarkMode ? Colors.grey[800]!.withOpacity(0.6) : Colors.grey[50],
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    hintText: "Search skills...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Skills list
                Expanded(
                  child: ValueListenableBuilder<List<String>>(
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
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                      ),
                                    ),
                                    selected: isSelected,
                                    onSelected: (_) => toggleSkill(skill),
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
                  ),
                ),
                const SizedBox(height: 24),
                
                // Confirm button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    child: const Text(
                      "Confirm Selection",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
