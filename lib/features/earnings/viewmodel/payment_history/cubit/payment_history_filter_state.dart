import 'package:flutter/material.dart';

import 'payment_history_filter_cubit.dart';

class PaymentHistoryFilterState {
  final DateFilter selectedFilter;
  final DateTimeRange? customDateRange;

  const PaymentHistoryFilterState({
    required this.selectedFilter,
    this.customDateRange,
  });

  factory PaymentHistoryFilterState.initial() {
    return const PaymentHistoryFilterState(selectedFilter: DateFilter.all);
  }

  PaymentHistoryFilterState copyWith({
    DateFilter? selectedFilter,
    DateTimeRange? customDateRange,
  }) {
    return PaymentHistoryFilterState(
      selectedFilter: selectedFilter ?? this.selectedFilter,
      customDateRange: customDateRange,
    );
  }
}
