import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/features/earnings/view/components/error_view.dart';
import 'package:quick_pitch_app/features/earnings/view/widget/earning_summary.dart';
import 'package:quick_pitch_app/features/earnings/view/widget/earnings_chart.dart';
import 'package:quick_pitch_app/features/earnings/view/widget/payment_history.dart';
import 'package:quick_pitch_app/features/earnings/viewmodel/cubit/earnings_cubit.dart';

class EarningScreen extends StatelessWidget {
  final String fixerId;

  const EarningScreen({
    super.key,
    required this.fixerId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EarningsCubit(
        firestore: FirebaseFirestore.instance,
        fixerId: fixerId,
      )..loadEarnings(),
      child: const EarningScreenView(),
    );
  }
}

class EarningScreenView extends StatelessWidget {
  const EarningScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Earnings'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<EarningsCubit, EarningsState>(
        builder: (context, state) {
          if (state is EarningsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is EarningsError) {
            return ErrorView();
          }

          if (state is EarningsLoaded) {
            return RefreshIndicator(
              onRefresh: () => context.read<EarningsCubit>().loadEarnings(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    EarningSummary(state: state),
                    const SizedBox(height: 24),
                    EarningsChart(monthlyEarnings: state.monthlyEarnings),
                    const SizedBox(height: 24),
                    PaymentHistory(payments: state.paymentHistory),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
