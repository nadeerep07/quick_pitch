import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/earnings/view/widget/filter/change_filter_button.dart';
import 'package:quick_pitch_app/features/earnings/view/widget/filter/filter_bottom_sheet.dart';
import 'package:quick_pitch_app/features/earnings/view/widget/filter/filter_display_container.dart';
import 'package:quick_pitch_app/features/earnings/viewmodel/payment_history/cubit/payment_history_filter_cubit.dart';

class EarningsFilterBar extends StatelessWidget {
  final PaymentHistoryFilterState filterState;
  final EarningsFilterCubit filterCubit;

  const EarningsFilterBar({
    super.key,
    required this.filterState,
    required this.filterCubit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.filter_list, color: Colors.blue),
          const SizedBox(width: 8),
          const Text(
            'Filter Period:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: FilterDisplayContainer(filterState: filterState),
          ),
          const SizedBox(width: 12),
          ChangeFilterButton(
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => FilterBottomSheet(
        filterState: filterState,
        filterCubit: filterCubit,
      ),
    );
  }
}
