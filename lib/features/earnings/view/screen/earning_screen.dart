import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/features/earnings/view/components/earning_filter_bard.dart';
import 'package:quick_pitch_app/features/earnings/view/components/error_view.dart';
import 'package:quick_pitch_app/features/earnings/view/components/earning_summary.dart';
import 'package:quick_pitch_app/features/earnings/view/widget/earnings_chart.dart';
import 'package:quick_pitch_app/features/earnings/view/widget/payment_history.dart';
import 'package:quick_pitch_app/features/earnings/viewmodel/cubit/earnings_cubit.dart';
import 'package:quick_pitch_app/features/earnings/viewmodel/payment_history/cubit/payment_history_filter_cubit.dart';

class EarningScreen extends StatelessWidget {
  final String fixerId;

  const EarningScreen({
    super.key,
    required this.fixerId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => EarningsCubit(
            firestore: FirebaseFirestore.instance,
            fixerId: fixerId,
          )..loadEarnings(),
        ),
        BlocProvider(
          create: (_) => EarningsFilterCubit(),
        ),
      ],
      child: const EarningsScreenView(),
    );
  }
}

class EarningsScreenView extends StatelessWidget {
  const EarningsScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Earnings'),
        backgroundColor: AppColors.transparent,
        foregroundColor: AppColors.primaryText,
        elevation: 0,
      ),
      body: BlocBuilder<EarningsCubit, EarningsState>(
        builder: (context, earningsState) {
          return switch (earningsState) {
            EarningsLoading() => const _LoadingView(),
            EarningsError() => const ErrorView(),
            EarningsLoaded() => _EarningsLoadedView(state: earningsState),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _EarningsLoadedView extends StatelessWidget {
  final EarningsLoaded state;

  const _EarningsLoadedView({required this.state});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EarningsFilterCubit, PaymentHistoryFilterState>(
      builder: (context, filterState) {
        final filterCubit = context.read<EarningsFilterCubit>();
        final filteredState = filterCubit.calculateFilteredEarnings(state);
        final isFiltered = filterState.selectedFilter != DateFilter.all;

        return CustomPaint(
          painter: MainBackgroundPainter(),
          child: RefreshIndicator(
            onRefresh: () => context.read<EarningsCubit>().loadEarnings(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  EarningsFilterBar(
                    filterState: filterState,
                    filterCubit: filterCubit,
                  ),
                  const SizedBox(height: 16),
                  EarningSummary(
                    state: filteredState,
                    isFiltered: isFiltered,
                  ),
                  const SizedBox(height: 24),
                  EarningsChart(
                    monthlyEarnings: filteredState.filteredMonthlyEarnings,
                  ),
                  const SizedBox(height: 24),
                  PaymentHistory(
                    payments: filteredState.filteredPaymentHistory,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}