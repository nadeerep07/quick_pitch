import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/fixer_work_selection/model/work_request_model.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/widgets/screen_widget/client_details_card.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/widgets/screen_widget/complete_button.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/widgets/screen_widget/payment_status_card.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/widgets/screen_widget/status_card.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/widgets/screen_widget/work_details_card.dart';
import 'package:quick_pitch_app/features/pitch_detail/fixer/widgets/screen_widget/work_images_card.dart';
import 'package:quick_pitch_app/features/pitch_requests/fixer/viewmodel/bloc/hire_requests_bloc.dart';
import 'package:quick_pitch_app/features/pitch_requests/fixer/viewmodel/bloc/hire_requests_state.dart';


class HireRequestDetailScreen extends StatelessWidget {
  final HireRequest request;

  const HireRequestDetailScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Details'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: BlocListener<HireRequestsBloc, HireRequestsState>(
        listener: (context, state) {
          if (state is RequestProcessingSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
            if (state.message.contains('completed')) {
              Navigator.pop(context);
            }
          } else if (state is RequestProcessingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: theme.colorScheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(res.wp(4)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatusCard(request: request),
              SizedBox(height: res.wp(6)),
              if (_shouldShowPaymentSection()) ...[
                PaymentStatusCard(request: request),
                SizedBox(height: res.wp(4)),
              ],
              ClientDetailsCard(request: request),
              SizedBox(height: res.wp(4)),
              WorkDetailsCard(request: request),
              if (request.workImages.isNotEmpty) ...[
                SizedBox(height: res.wp(4)),
                WorkImagesCard(request: request),
              ],
              SizedBox(height: res.wp(6)),
              if (request.status == HireRequestStatus.accepted)
                CompleteButton(request: request),
            ],
          ),
        ),
      ),
    );
  }

  bool _shouldShowPaymentSection() {
    return request.status == HireRequestStatus.completed ||
        request.paymentStatus != null;
  }
}



