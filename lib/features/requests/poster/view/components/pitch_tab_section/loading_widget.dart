import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/requests/poster/view/components/pitch_tab_section/poster_request_shimmer.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RequestShimmer();
  }
}
