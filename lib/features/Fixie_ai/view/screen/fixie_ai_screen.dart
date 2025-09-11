import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/Fixie_ai/view/components/fixie_app_bar.dart';
import 'package:quick_pitch_app/features/Fixie_ai/view/components/quick_actions_section.dart';
import 'package:quick_pitch_app/features/Fixie_ai/view/components/sections/background_section.dart';
import 'package:quick_pitch_app/features/Fixie_ai/view/components/sections/chat_content_section.dart';
import 'package:quick_pitch_app/features/Fixie_ai/view/widget/help_dialog_widget.dart';
import 'package:quick_pitch_app/features/Fixie_ai/view/widget/input_area_widget.dart';
import 'package:quick_pitch_app/features/Fixie_ai/viewmodel/bloc/chat_bloc.dart';

class FixieAiScreen extends StatefulWidget {
  const FixieAiScreen({super.key});

  @override
  State<FixieAiScreen> createState() => _FixieAiScreenState();
}

class _FixieAiScreenState extends State<FixieAiScreen>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late AnimationController _backgroundController;

  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _backgroundAnimation;

  late Responsive _responsive;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeChat();
  }

  void _initializeAnimations() {
    _fadeController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _slideController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _pulseController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _backgroundController =
        AnimationController(vsync: this, duration: const Duration(seconds: 10));

    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack));
    _pulseAnimation =
        Tween<double>(begin: 0.8, end: 1.2).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
    _backgroundAnimation =
        CurvedAnimation(parent: _backgroundController, curve: Curves.linear);

    _fadeController.forward();
    _slideController.forward();
    _pulseController.repeat(reverse: true);
    _backgroundController.repeat();
  }

  void _initializeChat() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) context.read<ChatBloc>().add(InitializeChat());
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_textController.text.trim().isEmpty) return;
    final message = _textController.text.trim();
    _textController.clear();
    context.read<ChatBloc>().add(SendMessage(message));
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => HelpDialogWidget(responsive: _responsive),
    );
  }

  @override
  Widget build(BuildContext context) {
    _responsive = Responsive(context);

    return Scaffold(
      body: BackgroundSection(
        backgroundAnimation: _backgroundAnimation,
        child: SafeArea(
          child: Column(
            children: [
              FixieAppBar(
                fadeAnimation: _fadeAnimation,
                pulseAnimation: _pulseAnimation,
                responsive: _responsive,
                onHelpPressed: _showHelpDialog,
                onRefreshPressed: () => context.read<ChatBloc>().add(ClearChat()),
              ),
              QuickActionsSection(
                slideAnimation: _slideAnimation,
                responsive: _responsive,
                onActionPressed: (action) =>
                    context.read<ChatBloc>().add(SendQuickAction(action)),
              ),
              Expanded(
                child: ChatContentSection(
                  fadeAnimation: _fadeAnimation,
                  pulseAnimation: _pulseAnimation,
                  responsive: _responsive,
                  scrollController: _scrollController,
                  scrollToBottom: _scrollToBottom,
                ),
              ),
              InputAreaWidget(
                textController: _textController,
                responsive: _responsive,
                onSendMessage: _sendMessage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
