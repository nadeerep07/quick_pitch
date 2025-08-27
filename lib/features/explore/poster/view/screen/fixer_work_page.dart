// Updated FixerWorksPage
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/explore/poster/repository/explore_fixer_works_repository.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/fixer_work_page/fixer_works_app_bar.dart';
import 'package:quick_pitch_app/features/explore/poster/view/components/explore_fixer_work_page/fixer_works_content.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/fixer_wroks/cubit/fixer_works_cubit.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/fixer_wroks/cubit/fixer_works_state.dart';

class FixerWorksPage extends StatefulWidget {
  final UserProfileModel fixer;

  const FixerWorksPage({
    super.key,
    required this.fixer,
  });

  @override
  State<FixerWorksPage> createState() => _FixerWorksPageState();
}

class _FixerWorksPageState extends State<FixerWorksPage> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late FixerWorksCubit _fixerWorksCubit;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    
    _fixerWorksCubit = FixerWorksCubit(ExploreFixerWorksRepository());
    _fixerWorksCubit.loadFixerWorks(widget.fixer.uid);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fadeController.dispose();
    _fixerWorksCubit.close();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _fixerWorksCubit.loadMoreWorks(widget.fixer.uid);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _fixerWorksCubit,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: BlocConsumer<FixerWorksCubit, FixerWorksState>(
          listener: (context, state) {
            if (state is FixerWorksError) {
              _showErrorSnackBar(state.message);
            } else if (state is FixerWorksLoaded) {
              _fadeController.forward();
            }
          },
          builder: (context, state) {
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                FixerWorksAppBar(
                  fixer: widget.fixer,
                  state: state,
                  onClose: () => Navigator.of(context).pop(),
                ),
                SliverToBoxAdapter(
                  child: FixerWorksContent(
                    state: state,
                    fixer: widget.fixer,
                    fadeAnimation: _fadeAnimation,
                    onRefresh: () => _fixerWorksCubit.refreshWorks(widget.fixer.uid),
                    onRetry: () => _fixerWorksCubit.loadFixerWorks(widget.fixer.uid),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
