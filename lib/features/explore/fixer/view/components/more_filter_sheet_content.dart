import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quick_pitch_app/core/common/app_button.dart';
import 'package:quick_pitch_app/features/explore/fixer/viewmodel/cubit/explore_screen_cubit.dart';

class MoreFilterSheetContent extends StatelessWidget {
  final List<String> filters;
  final ExploreScreenState state;
  final void Function({
    required String selectedFilter,
    required double currentBudget,
    required String? preferredTime,
    required DateTime? selectedDeadline,
  }) onApply;

  final VoidCallback onClear;

  const MoreFilterSheetContent({
    super.key,
    required this.filters,
    required this.state,
    required this.onApply,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    String selectedFilter = state.selectedFilter;
    double currentBudget = state.currentBudget;
    String? preferredTime = state.preferredTime;
    DateTime? selectedDeadline = state.selectedDeadline;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: StatefulBuilder(
        builder: (context, setModalState) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title & Clear Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'More Filters',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        setModalState(() {
                          selectedFilter = 'All';
                          currentBudget = 10000;
                          preferredTime = null;
                          selectedDeadline = null;
                        });
                        onClear();
                      },
                      child: const Text("Clear Filters"),
                    ),
                  ],
                ),
                const Divider(),

                // Skill Filter
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: filters.map((filter) {
                    final isSelected = selectedFilter == filter;
                    return ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (_) {
                        setModalState(() {
                          selectedFilter = isSelected ? 'All' : filter;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Budget Slider
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Max Budget (₹)",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Slider(
                      value: currentBudget,
                      min: 0,
                      max: state.maxBudget,
                      divisions: 20,
                      label: "₹${currentBudget.toInt()}",
                      onChanged: (value) {
                        setModalState(() {
                          currentBudget = value;
                        });
                      },
                    ),
                  ],
                ),

                // Preferred Time
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Preferred Time",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Wrap(
                      spacing: 10,
                      children: ['Morning', 'Afternoon', 'Evening'].map((time) {
                        final isSelected = preferredTime == time;
                        return ChoiceChip(
                          label: Text(time),
                          selected: isSelected,
                          onSelected: (_) {
                            setModalState(() {
                              preferredTime = isSelected ? null : time;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Deadline Picker
                Row(
                  children: [
                    const Text(
                      "Due Before:",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      icon: const Icon(Icons.calendar_today, size: 18),
                      label: Text(
                        selectedDeadline == null
                            ? 'Select Date'
                            : DateFormat.yMMMd().format(selectedDeadline!),
                      ),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setModalState(() {
                            selectedDeadline = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

               
                AppButton(text:"Apply Filters" , onPressed: () {
                      onApply(
                        selectedFilter: selectedFilter,
                        currentBudget: currentBudget,
                        preferredTime: preferredTime,
                        selectedDeadline: selectedDeadline,
                      );
                    },),
                    SizedBox(height: 5,)]
            ),
          );
        },
      ),
    );
  }
}
