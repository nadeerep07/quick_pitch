import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/earnings/view/widget/filter/custom_date_range_display.dart';
import 'package:quick_pitch_app/features/earnings/view/widget/filter/filter_bottom_sheet_header.dart';
import 'package:quick_pitch_app/features/earnings/viewmodel/payment_history/cubit/payment_history_filter_cubit.dart';

class FilterBottomSheet extends StatelessWidget {
  final PaymentHistoryFilterState filterState;
  final EarningsFilterCubit filterCubit;

  const FilterBottomSheet({
    super.key,
    required this.filterState,
    required this.filterCubit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FilterBottomSheetHeader(),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ..._buildFilterOptions(context),
                  if (filterState.customDateRange != null) 
                    CustomDateRangeDisplay(
                      dateRange: filterState.customDateRange!,
                      onEditPressed: () => _selectCustomDateRange(context),
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFilterOptions(BuildContext context) {
    return DateFilter.values.map((filter) => RadioListTile<DateFilter>(
      title: Text(filter.label),
      value: filter,
      groupValue: filterState.selectedFilter,
      onChanged: (value) => _handleFilterSelection(context, value),
    )).toList();
  }

  void _handleFilterSelection(BuildContext context, DateFilter? value) {
    if (value == null) return;
    
    if (value == DateFilter.custom) {
      Navigator.pop(context);
      _selectCustomDateRange(context);
    } else {
      filterCubit.setFilter(value);
      Navigator.pop(context);
    }
  }

  Future<void> _selectCustomDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: filterCubit.state.customDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Colors.blue,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      filterCubit.setFilter(DateFilter.custom, customRange: picked);
    }
  }

}
