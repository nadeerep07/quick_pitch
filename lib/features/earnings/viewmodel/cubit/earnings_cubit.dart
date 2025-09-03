import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:quick_pitch_app/features/earnings/model/payment_model.dart';
import 'package:quick_pitch_app/features/task_pitching/model/pitch_model.dart';

part 'earnings_state.dart';

class EarningsCubit extends Cubit<EarningsState> {
  final FirebaseFirestore _firestore;
  final String fixerId;

  EarningsCubit({
    required FirebaseFirestore firestore,
    required this.fixerId,
  }) : _firestore = firestore, super(EarningsInitial());

  Future<void> loadEarnings() async {
    try {
      emit(EarningsLoading());

      // Query all completed pitches for the fixer
      final QuerySnapshot querySnapshot = await _firestore
          .collectionGroup('pitches')
          .where('fixerId', isEqualTo: fixerId)
          .where('paymentStatus', isEqualTo: 'completed')
          .orderBy('paymentCompletedAt', descending: true)
          .get();

      final List<PitchModel> completedPitches = querySnapshot.docs
          .map((doc) => PitchModel.fromJson(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();

      // Convert to payment models
      final List<PaymentModel> payments = completedPitches
          .map((pitch) => PaymentModel.fromPitch(pitch))
          .toList();

      // Calculate total earnings
      final double totalEarnings = payments.fold(
        0.0,
        (sum, payment) => sum + payment.amount,
      );

      // Calculate this month's earnings
      final DateTime now = DateTime.now();
      final DateTime startOfMonth = DateTime(now.year, now.month, 1);
      final double thisMonthEarnings = payments
          .where((payment) => payment.paidAt.isAfter(startOfMonth))
          .fold(0.0, (sum, payment) => sum + payment.amount);

      // Calculate monthly earnings for chart (last 6 months)
      final List<MonthlyEarning> monthlyEarnings = _calculateMonthlyEarnings(payments);

      emit(EarningsLoaded(
        totalEarnings: totalEarnings,
        thisMonthEarnings: thisMonthEarnings,
        paymentHistory: payments,
        monthlyEarnings: monthlyEarnings,
      ));
    } catch (e) {
      emit(EarningsError('Failed to load earnings: ${e.toString()}'));
    }
  }

  List<MonthlyEarning> _calculateMonthlyEarnings(List<PaymentModel> payments) {
    final Map<String, double> monthlyMap = {};
    final DateTime now = DateTime.now();

    // Initialize last 6 months with 0
    for (int i = 5; i >= 0; i--) {
      final DateTime month = DateTime(now.year, now.month - i, 1);
      final String monthKey = '${month.year}-${month.month.toString().padLeft(2, '0')}';
      monthlyMap[monthKey] = 0.0;
    }

    // Add earnings to corresponding months
    for (final payment in payments) {
      final String monthKey = '${payment.paidAt.year}-${payment.paidAt.month.toString().padLeft(2, '0')}';
      if (monthlyMap.containsKey(monthKey)) {
        monthlyMap[monthKey] = monthlyMap[monthKey]! + payment.amount;
      }
    }

    // Convert to list of MonthlyEarning objects
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