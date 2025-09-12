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

    //  print('Loading earnings for fixerId: $fixerId');

      // Load both pitch and hire request earnings in parallel
      final results = await Future.wait([
        _loadPitchEarnings(),
        _loadHireRequestEarnings(),
      ]);

      final List<PaymentModel> pitchPayments = results[0];
      final List<PaymentModel> hirePayments = results[1];

      // print('Pitch payments: ${pitchPayments.length}');
      // print('Hire payments: ${hirePayments.length}');

      // Combine all payments
      final List<PaymentModel> allPayments = [
        ...pitchPayments,
        ...hirePayments,
      ]..sort((a, b) => b.paidAt.compareTo(a.paidAt)); // Sort by date descending

      // Calculate total earnings
      final double totalEarnings = allPayments.fold(
        0.0,
        (sums, payment) => sums + payment.amount,
      );

      // Calculate this month's earnings
      final DateTime now = DateTime.now();
      final DateTime startOfMonth = DateTime(now.year, now.month, 1);
      final double thisMonthEarnings = allPayments
          .where((payment) => payment.paidAt.isAfter(startOfMonth))
          .fold(0.0, (sums, payment) => sums + payment.amount);

      // Calculate monthly earnings for chart (last 6 months)
      final List<MonthlyEarning> monthlyEarnings = _calculateMonthlyEarnings(allPayments);

      // Calculate earnings breakdown
      final double pitchEarnings = pitchPayments.fold(0.0, (sums, payment) => sums + payment.amount);
      final double hireEarnings = hirePayments.fold(0.0, (sums, payment) => sums + payment.amount);

    //  print('Total earnings: $totalEarnings (Pitch: $pitchEarnings, Hire: $hireEarnings)');

      emit(EarningsLoaded(
        totalEarnings: totalEarnings,
        thisMonthEarnings: thisMonthEarnings,
        paymentHistory: allPayments,
        monthlyEarnings: monthlyEarnings,
        pitchEarnings: pitchEarnings,
        hireRequestEarnings: hireEarnings,
      ));
    } catch (e) {
   //   print('Error in loadEarnings: $e');
      emit(EarningsError('Failed to load earnings: ${e.toString()}'));
    }
  }

  Future<List<PaymentModel>> _loadPitchEarnings() async {
    try {
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

      return completedPitches
          .map((pitch) => PaymentModel.fromPitch(pitch))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<PaymentModel>> _loadHireRequestEarnings() async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('hire_requests')
          .where('fixerId', isEqualTo: fixerId)
          .where('paymentStatus', isEqualTo: 'completed')
          .orderBy('paymentCompletedAt', descending: true)
          .get();
// print('Hire requests fetched: ${querySnapshot.docs.length}');
      final List<PaymentModel> hirePayments = [];

      for (final doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
       //   print('Hire request data: $data');  // 👈 log raw data
        // Try to get poster details from the hire request or associated task
        String posterName = 'Unknown Client';
        String? posterImage;
        
        if (data['posterName'] != null) {
          posterName = data['posterName'];
          posterImage = data['posterImage'];
        } else if (data['clientId'] != null) {
          // Fetch client details if needed
          try {
            final clientDoc = await _firestore
                .collection('users')
                .doc(data['clientId'])
                .get();
            
            if (clientDoc.exists) {
              final clientData = clientDoc.data() as Map<String, dynamic>;
              posterName = clientData['name'] ?? clientData['displayName'] ?? 'Unknown Client';
              posterImage = clientData['profileImage'] ?? clientData['photoURL'];
            }
          } catch (e) {
            // Continue with default values if client fetch fails
         //     print('Error fetching hire request earnings: $e');
          }
        }

        final payment = PaymentModel(
          id: doc.id,
          taskId: data['fixerWorkId'] ?? data['taskId'] ?? doc.id,
          posterName: posterName,
          posterImage: posterImage,
          amount: (data['paidAmount'] ?? 0.0).toDouble(),
          paidAt: (data['paymentCompletedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          transactionId: data['transactionId'] ?? '',
          status: data['paymentStatus'] ?? 'completed',
          paymentType: 'hire_request', // Add this field to distinguish payment types
        );

        hirePayments.add(payment);
      }

      return hirePayments;
    } catch (e) {
      return [];
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