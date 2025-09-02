import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/work_detail/bottom_bar.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/work_detail/image_pager.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/view/widgets/work_detail/top_bar.dart';
import 'package:quick_pitch_app/features/fixer_work_upload/viewmodel/cubit/image_full_screen_dialog_dart_cubit.dart';

class ImageFullscreenDialog extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final ThemeData theme;

  const ImageFullscreenDialog({
    super.key,
    required this.images,
    required this.initialIndex,
    required this.theme,
  });

  @override
  State<ImageFullscreenDialog> createState() => _ImageFullscreenDialogState();
}

class _ImageFullscreenDialogState extends State<ImageFullscreenDialog>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();

    // Hide status bar for immersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ImageIndexCubit(widget.initialIndex),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: Stack(
            children: [
              ImagePager(
                controller: _pageController,
                images: widget.images,
              ),
              TopBar(images: widget.images),
              BottomBar(images: widget.images),
            ],
          ),
        ),
      ),
    );
  }
}

