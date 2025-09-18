import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/earnings/model/payment_model.dart';
import 'package:quick_pitch_app/features/earnings/viewmodel/cubit/earnings_cubit.dart';

enum DateFilter {
  all('All Time'),
  today('Today'),
  thisWeek('This Week'),
  lastMonth('Last Month'),
  custom('Custom Range');

  const DateFilter(this.label);
  final String label;
}

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

class EarningsFilterCubit extends Cubit<PaymentHistoryFilterState> {
  EarningsFilterCubit() : super(PaymentHistoryFilterState.initial());

  void setFilter(DateFilter filter, {DateTimeRange? customRange}) {
    emit(state.copyWith(
      selectedFilter: filter,
      customDateRange: filter == DateFilter.custom ? customRange : null,
    ));
  }

  List<PaymentModel> getFilteredPayments(List<PaymentModel> payments) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return payments.where((payment) {
      final paymentDate = payment.paidAt;
      
      switch (state.selectedFilter) {
        case DateFilter.all:
          return true;
        case DateFilter.today:
          final paymentDay = DateTime(paymentDate.year, paymentDate.month, paymentDate.day);
          return paymentDay.isAtSameMomentAs(today);
        case DateFilter.thisWeek:
          final weekStart = today.subtract(Duration(days: today.weekday - 1));
          return paymentDate.isAfter(weekStart.subtract(const Duration(days: 1)));

        case DateFilter.lastMonth:
          final lastMonthStart = DateTime(now.year, now.month - 1, 1);
          final lastMonthEnd = DateTime(now.year, now.month, 1);
          return paymentDate.isAfter(lastMonthStart.subtract(const Duration(days: 1))) &&
                 paymentDate.isBefore(lastMonthEnd);
        case DateFilter.custom:
          if (state.customDateRange == null) return true;
          return paymentDate.isAfter(state.customDateRange!.start.subtract(const Duration(days: 1))) &&
                 paymentDate.isBefore(state.customDateRange!.end.add(const Duration(days: 1)));
      }
    }).toList();
  }

  EarningsLoaded calculateFilteredEarnings(EarningsLoaded originalState) {
    final filteredPayments = getFilteredPayments(originalState.paymentHistory);
    
    // Calculate filtered totals
    final filteredTotalEarnings = filteredPayments.fold(
      0.0,
      (sum, payment) => sum + payment.amount,
    );

    final filteredPitchEarnings = filteredPayments
        .where((payment) => payment.paymentType == 'pitch')
        .fold(0.0, (sum, payment) => sum + payment.amount);

    final filteredHireRequestEarnings = filteredPayments
        .where((payment) => payment.paymentType == 'hire_request')
        .fold(0.0, (sum, payment) => sum + payment.amount);

    // Calculate filtered monthly earnings
    final filteredMonthlyEarnings = _calculateFilteredMonthlyEarnings(filteredPayments);

    return originalState.copyWithFilteredData(
      filteredTotalEarnings: filteredTotalEarnings,
      filteredPaymentHistory: filteredPayments,
      filteredMonthlyEarnings: filteredMonthlyEarnings,
      filteredPitchEarnings: filteredPitchEarnings,
      filteredHireRequestEarnings: filteredHireRequestEarnings,
      filteredCompletedJobs: filteredPayments.length,
    );
  }

  List<MonthlyEarning> _calculateFilteredMonthlyEarnings(List<PaymentModel> payments) {
    final Map<String, double> monthlyMap = {};
    
    // Get date range for chart
    DateTime startDate;
    DateTime endDate = DateTime.now();
    
    switch (state.selectedFilter) {
      case DateFilter.all:
        // Last 6 months for all time
        startDate = DateTime(endDate.year, endDate.month - 5, 1);
        break;
      case DateFilter.today:
        startDate = endDate;
        endDate = startDate;
        break;
      case DateFilter.thisWeek:
        startDate = endDate.subtract(Duration(days: endDate.weekday - 1));
        break;
      case DateFilter.lastMonth:
        startDate = DateTime(endDate.year, endDate.month - 1, 1);
        endDate = DateTime(endDate.year, endDate.month, 0);
        break;
      case DateFilter.custom:
        if (state.customDateRange != null) {
          startDate = state.customDateRange!.start;
          endDate = state.customDateRange!.end;
        } else {
          startDate = DateTime(endDate.year, endDate.month - 5, 1);
        }
        break;
    }

    // Initialize months in range
    DateTime current = DateTime(startDate.year, startDate.month, 1);
    final DateTime end = DateTime(endDate.year, endDate.month, 1);
    
    while (current.isBefore(end.add(const Duration(days: 32)))) {
      final monthKey = '${current.year}-${current.month.toString().padLeft(2, '0')}';
      monthlyMap[monthKey] = 0.0;
      current = DateTime(current.year, current.month + 1, 1);
    }

    // Add earnings to corresponding months
    for (final payment in payments) {
      final monthKey = '${payment.paidAt.year}-${payment.paidAt.month.toString().padLeft(2, '0')}';
      if (monthlyMap.containsKey(monthKey)) {
        monthlyMap[monthKey] = monthlyMap[monthKey]! + payment.amount;
      }
    }

    // Convert to list
    return monthlyMap.entries.map((entry) {
      final parts = entry.key.split('-');
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final date = DateTime(year, month, 1);
      
      return MonthlyEarning(
        month: _getMonthName(month),
        amount: entry.value,
        date: date,
      );
    }).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  String _getMonthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month];
  }
}