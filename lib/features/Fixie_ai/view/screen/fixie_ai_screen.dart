import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/features/Fixie_ai/model/chat_message.dart';
import 'package:quick_pitch_app/features/Fixie_ai/view/components/animated_message_bubble.dart';
import 'package:quick_pitch_app/features/Fixie_ai/view/components/message_typing_indicator.dart';
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

  @override
  void initState() {
    super.initState();
    _initializeAnimations();

    // Initialize chat after a delay
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        context.read<ChatBloc>().add(InitializeChat());
      }
    });
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_backgroundController);

    _fadeController.forward();
    _slideController.forward();
    _pulseController.repeat(reverse: true);
    _backgroundController.repeat();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.deepPurple.shade50.withValues(alpha: 0.3),
                  Colors.deepPurple.shade100.withValues(alpha: 0.2),
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
            child: CustomPaint(
              painter: MainBackgroundPainter(),
              child: SafeArea(
                child: Column(
                  children: [
                    _buildModernAppBar(),
                    _buildQuickActions(),
                    Expanded(
                      child: BlocConsumer<ChatBloc, ChatState>(
                        listener: (context, state) {
                          if (state is ChatLoaded) {
                            _scrollToBottom();
                          }
                        },
                        builder: (context, state) {
                          if (state is ChatInitial) {
                            return _buildEmptyState();
                          } else if (state is ChatLoaded) {
                            return state.messages.isEmpty
                                ? _buildEmptyState()
                                : _buildMessageList(
                                  state.messages,
                                  state.isLoading,
                                );
                          } else if (state is ChatError) {
                            return Center(
                              child: Text(
                                'Something went wrong. Please try again.',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            );
                          }

                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ),
                    _buildModernInputArea(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildModernAppBar() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.shade100.withValues(alpha: 0.3),
              Colors.deepPurple.shade50.withValues(alpha: 0.1),
            ],
          ),
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(24),
          ),
          border: Border.all(color: Colors.deepPurple.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepPurple.shade400,
                          Colors.deepPurple.shade600,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withValues(alpha: 0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback:
                        (bounds) => LinearGradient(
                          colors: [
                            Colors.deepPurple.shade600,
                            Colors.deepPurple.shade800,
                          ],
                        ).createShader(bounds),
                    child: const Text(
                      'Fixie AI',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    'Your AI Pitch Assistant',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.deepPurple.shade600.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.deepPurple.withValues(alpha: 0.2),
                  ),
                ),
                child: Icon(
                  Icons.help_outline,
                  color: Colors.deepPurple.shade600,
                  size: 20,
                ),
              ),
              onPressed: _showHelpDialog,
            ),
            const SizedBox(width: 8),
            BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                return IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.deepPurple.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Icon(
                      Icons.refresh,
                      color: Colors.deepPurple.shade600,
                      size: 20,
                    ),
                  ),
                  onPressed:
                      (state is ChatLoaded && state.messages.length > 1)
                          ? () => context.read<ChatBloc>().add(ClearChat())
                          : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        height: 70,
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            _buildModernActionChip(
              'Structure my pitch',
              Icons.rocket_launch,
              Colors.deepPurple.shade500,
            ),
            _buildModernActionChip(
              'Improve my Pitch',
              Icons.trending_up,
              Colors.deepPurple.shade600,
            ),
            _buildModernActionChip(
              'Market analysis',
              Icons.analytics,
              Colors.deepPurple.shade800,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernActionChip(String label, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: () => context.read<ChatBloc>().add(SendQuickAction(label)),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.2),
                color.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value * 0.1 + 0.9,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepPurple.shade400,
                          Colors.deepPurple.shade600,
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withValues(alpha: 0.3),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            ShaderMask(
              shaderCallback:
                  (bounds) => LinearGradient(
                    colors: [
                      Colors.deepPurple.shade600,
                      Colors.deepPurple.shade800,
                    ],
                  ).createShader(bounds),
              child: const Text(
                'Ready to craft your perfect pitch?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'I\'ll help you create compelling presentations\nthat captivate investors and audiences',
              style: TextStyle(
                fontSize: 16,
                color: Colors.deepPurple.shade600.withValues(alpha: 0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple.withValues(alpha: 0.1),
                    Colors.deepPurple.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.deepPurple.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                'Try the quick actions above or start typing',
                style: TextStyle(
                  color: Colors.deepPurple.shade600.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList(List<ChatMessage> messages, bool isLoading) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: messages.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == messages.length && isLoading) {
          return const TypingIndicator();
        }
        return AnimatedMessageBubble(
          key: ValueKey(messages[index].timestamp.millisecondsSinceEpoch),
          message: messages[index],
          index: index,
        );
      },
    );
  }

  Widget _buildModernInputArea() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepPurple.withValues(alpha: 0.1),
            Colors.deepPurple.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.deepPurple.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              style: TextStyle(color: Colors.deepPurple.shade800, fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Ask about pitches, decks, or business ideas...',
                hintStyle: TextStyle(
                  color: Colors.deepPurple.shade400.withValues(alpha: 0.6),
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 4),
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                final isLoading = state is ChatLoaded && state.isLoading;
                return InkWell(
                  onTap: isLoading ? null : _sendMessage,
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient:
                          isLoading
                              ? LinearGradient(
                                colors: [
                                  Colors.grey.shade400,
                                  Colors.grey.shade500,
                                ],
                              )
                              : LinearGradient(
                                colors: [
                                  Colors.deepPurple.shade500,
                                  Colors.deepPurple.shade700,
                                ],
                              ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (isLoading ? Colors.grey : Colors.deepPurple)
                              .withValues(alpha: 0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child:
                        isLoading
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : const Icon(
                              Icons.send_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: ShaderMask(
              shaderCallback:
                  (bounds) => LinearGradient(
                    colors: [
                      Colors.deepPurple.shade600,
                      Colors.deepPurple.shade800,
                    ],
                  ).createShader(bounds),
              child: const Text(
                'How Fixie AI can help',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            content: Text(
              'Structure your business pitch\n'
              'Improve your presentation deck\n'
              'Practice investor questions\n'
              'Get market analysis tips\n'
              'Refine your business strategy\n'
              'Perfect your pitch delivery\n\n'
              'Just ask me anything related to pitching and business presentations!',
              style: TextStyle(color: Colors.deepPurple.shade700, height: 1.5),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.deepPurple.shade500,
                        Colors.deepPurple.shade700,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Got it',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
  }
}

// animated_message_bubble.dart


// main.dart - Wrap your app with BlocProvider
// Add this to your main.dart file:
/*
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(),
      child: MaterialApp(
        home: FixieAiScreen(),
      ),
    );
  }
}
*/