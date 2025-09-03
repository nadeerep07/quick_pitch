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

  const EarningsLoaded({
    required this.totalEarnings,
    required this.thisMonthEarnings,
    required this.paymentHistory,
    required this.monthlyEarnings,
  });

  @override
  List<Object?> get props => [totalEarnings, thisMonthEarnings, paymentHistory, monthlyEarnings];
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