import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/requests/fixer/view/screen/hire_requests_tab.dart';
import 'package:quick_pitch_app/features/requests/fixer/view/screen/pitch_status_tab.dart';

class FixerRequestScreen extends StatefulWidget {
  const FixerRequestScreen({super.key});

  @override
  State<FixerRequestScreen> createState() => _FixerRequestScreenState();
}

class _FixerRequestScreenState extends State<FixerRequestScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: _buildAppBar(res, colorScheme),
      body: Stack(
        children: [
          CustomPaint(painter: MainBackgroundPainter(), size: Size.infinite),
          Column(
            children: [
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [PitchStatusTab(), HireRequestsTab()],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(Responsive res, ColorScheme colorScheme) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'Requests',
        style: TextStyle(
          color: AppColors.primaryText,
          fontWeight: FontWeight.bold,
          fontSize: res.sp(18),
        ),
      ),
      centerTitle: true,
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: colorScheme.primary,
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurface.withOpacity(0.6),
        tabs: const [Tab(text: "Pitch Status"), Tab(text: "Hire Requests")],
      ),
    );
  }
}
