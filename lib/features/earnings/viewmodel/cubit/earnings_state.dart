part of 'earnings_cubit.dart';

abstract class EarningsState extends Equatable {
  const EarningsState();

  @override
  List<Object?> get props => [];
}

class EarningsInitial extends EarningsState {}

class EarningsLoading extends EarningsState {}

class EarningsLoaded extends EarningsState {
  final double totalEarnings;
  final double thisMonthEarnings;
  final List<PaymentModel> paymentHistory;
  final List<MonthlyEarning> monthlyEarnings;
  final double pitchEarnings;
  final double hireRequestEarnings;
  
  // Filtered data
  final double filteredTotalEarnings;
  final List<PaymentModel> filteredPaymentHistory;
  final List<MonthlyEarning> filteredMonthlyEarnings;
  final double filteredPitchEarnings;
  final double filteredHireRequestEarnings;
  final int filteredCompletedJobs;

  const EarningsLoaded({
    required this.totalEarnings,
    required this.thisMonthEarnings,
    required this.paymentHistory,
    required this.monthlyEarnings,
    required this.pitchEarnings,
    required this.hireRequestEarnings,
    this.filteredTotalEarnings = 0,
    this.filteredPaymentHistory = const [],
    this.filteredMonthlyEarnings = const [],
    this.filteredPitchEarnings = 0,
    this.filteredHireRequestEarnings = 0,
    this.filteredCompletedJobs = 0,
  });

  EarningsLoaded copyWithFilteredData({
    required double filteredTotalEarnings,
    required List<PaymentModel> filteredPaymentHistory,
    required List<MonthlyEarning> filteredMonthlyEarnings,
    required double filteredPitchEarnings,
    required double filteredHireRequestEarnings,
    required int filteredCompletedJobs,
  }) {
    return EarningsLoaded(
      totalEarnings: totalEarnings,
      thisMonthEarnings: thisMonthEarnings,
      paymentHistory: paymentHistory,
      monthlyEarnings: monthlyEarnings,
      pitchEarnings: pitchEarnings,
      hireRequestEarnings: hireRequestEarnings,
      filteredTotalEarnings: filteredTotalEarnings,
      filteredPaymentHistory: filteredPaymentHistory,
      filteredMonthlyEarnings: filteredMonthlyEarnings,
      filteredPitchEarnings: filteredPitchEarnings,
      filteredHireRequestEarnings: filteredHireRequestEarnings,
      filteredCompletedJobs: filteredCompletedJobs,
    );
  }

  @override
  List<Object?> get props => [
    totalEarnings, 
    thisMonthEarnings, 
    paymentHistory, 
    monthlyEarnings,
    pitchEarnings,
    hireRequestEarnings,
    filteredTotalEarnings,
    filteredPaymentHistory,
    filteredMonthlyEarnings,
    filteredPitchEarnings,
    filteredHireRequestEarnings,
    filteredCompletedJobs,
  ];
}

class EarningsError extends EarningsState {
  final String message;

  const EarningsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Monthly Earning Model for Chart
class MonthlyEarning {
  final String month;
  final double amount;
  final DateTime date;

  MonthlyEarning({
    required this.month,
    required this.amount,
    required this.date,
  });
}