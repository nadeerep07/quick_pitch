import 'package:flutter/material.dart';
import 'package:quick_pitch_app/core/utils/date_formatter.dart';
import 'package:quick_pitch_app/features/earnings/viewmodel/payment_history/cubit/payment_history_filter_cubit.dart';

class FilterDisplayContainer extends StatelessWidget {
  final PaymentHistoryFilterState filterState;

  const FilterDisplayContainer({required this.filterState});

  @override
  Widget build(BuildContext context) {
    final displayText = _getDisplayText();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          fontSize: 14,
          color: Colors.blue.shade700,
          fontWeight: FontWeight.w500,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  String _getDisplayText() {
    if (filterState.selectedFilter == DateFilter.custom && 
        filterState.customDateRange != null) {
      return '${DateFormatter.formatDate(filterState.customDateRange!.start)} - ${DateFormatter.formatDate(filterState.customDateRange!.end)}';
    }
    return filterState.selectedFilter.label;
  }

 
}
