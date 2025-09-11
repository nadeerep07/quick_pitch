import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/explore/poster/repository/explore_fixer_works_repository.dart';
import 'package:quick_pitch_app/features/explore/poster/view/widgets/fixer_work_page/fixer_works_listener.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';
import 'package:quick_pitch_app/features/explore/poster/viewmodel/fixer_wroks/cubit/fixer_works_cubit.dart';


class FixerWorksPage extends StatefulWidget {
  final UserProfileModel fixer;

  const FixerWorksPage({super.key, required this.fixer});

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

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _fixerWorksCubit.loadMoreWorks(widget.fixer.uid);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fadeController.dispose();
    _fixerWorksCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _fixerWorksCubit,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: FixerWorksListener(
          fixer: widget.fixer,
          scrollController: _scrollController,
          fadeAnimation: _fadeAnimation,
          fadeController: _fadeController,
          fixerWorksCubit: _fixerWorksCubit,
        ),
      ),
    );
  }
}
