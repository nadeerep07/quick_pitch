import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/Fixie_ai/model/chat_message.dart';

class AnimatedMessageBubble extends StatefulWidget {
  final ChatMessage message;
  final int index;

  const AnimatedMessageBubble({super.key, required this.message, required this.index});

  @override
  State<AnimatedMessageBubble> createState() => _AnimatedMessageBubbleState();
}

class _AnimatedMessageBubbleState extends State<AnimatedMessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

@override
void initState() {
  super.initState();
  _controller = AnimationController(
    duration: Duration(milliseconds: 300 + (widget.index * 50).clamp(0, 500)),
    vsync: this,
  );

  _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0)
      .animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

  _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
      .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (mounted) _controller.forward();
  });
}


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: widget.message.isUser 
                    ? MainAxisAlignment.end 
                    : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!widget.message.isUser) ...[
                    _buildAvatar(),
                    const SizedBox(width: 12),
                  ],
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        gradient: widget.message.isUser
                            ? LinearGradient(
                                colors: [Colors.deepPurple.shade500, Colors.deepPurple.shade700],
                              )
                            : widget.message.isError
                                ? LinearGradient(
                                    colors: [Colors.red.withValues(alpha: 0.2), Colors.red.withValues(alpha: 0.1)],
                                  )
                                : LinearGradient(
                                    colors: [
                                      Colors.deepPurple.withValues(alpha: 0.1),
                                      Colors.deepPurple.withValues(alpha: 0.05),
                                    ],
                                  ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: widget.message.isUser
                              ? Colors.transparent
                              : Colors.deepPurple.withValues(alpha: 0.2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (widget.message.isUser ? Colors.deepPurple : Colors.deepPurple)
                                .withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.message.text,
                            style: TextStyle(
                              color: widget.message.isUser
                                  ? Colors.white
                                  : widget.message.isError
                                      ? Colors.red.shade600
                                      : Colors.deepPurple.shade800,
                              fontSize: 16,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _formatTime(widget.message.timestamp),
                            style: TextStyle(
                              color: (widget.message.isUser ? Colors.white : Colors.deepPurple.shade600)
                                  .withValues(alpha: 0.6),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (widget.message.isUser) ...[
                    const SizedBox(width: 12),
                    _buildUserAvatar(),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        gradient: widget.message.isError
            ? LinearGradient(colors: [Colors.red.shade400, Colors.red.shade600])
            : LinearGradient(colors: [Colors.deepPurple.shade500, Colors.deepPurple.shade700]),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: (widget.message.isError ? Colors.red : Colors.deepPurple).withValues(alpha: 0.3),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(
        widget.message.isError ? Icons.error_outline : Icons.auto_awesome,
        size: 18,
        color: Colors.white,
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.withValues(alpha: 0.3), Colors.deepPurple.withValues(alpha: 0.2)],
        ),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.deepPurple.withValues(alpha: 0.4)),
      ),
      child: Icon(
        Icons.person_rounded,
        size: 18,
        color: Colors.deepPurple.shade600,
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

// modern_typing_indicator.dart
