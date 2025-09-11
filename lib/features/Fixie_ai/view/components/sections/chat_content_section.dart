import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/Fixie_ai/view/components/empty_state_widget.dart';
import 'package:quick_pitch_app/features/Fixie_ai/view/widget/message_list_widget.dart';
import 'package:quick_pitch_app/features/Fixie_ai/viewmodel/bloc/chat_bloc.dart';

class ChatContentSection extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final Animation<double> pulseAnimation;
  final Responsive responsive;
  final ScrollController scrollController;
  final VoidCallback scrollToBottom;

  const ChatContentSection({
    super.key,
    required this.fadeAnimation,
    required this.pulseAnimation,
    required this.responsive,
    required this.scrollController,
    required this.scrollToBottom,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatLoaded) scrollToBottom();
      },
      builder: (context, state) {
        if (state is ChatInitial) {
          return EmptyStateWidget(
            fadeAnimation: fadeAnimation,
            pulseAnimation: pulseAnimation,
            responsive: responsive,
          );
        } else if (state is ChatLoaded) {
          return state.messages.isEmpty
              ? EmptyStateWidget(
                  fadeAnimation: fadeAnimation,
                  pulseAnimation: pulseAnimation,
                  responsive: responsive,
                )
              : MessageListWidget(
                  messages: state.messages,
                  isLoading: state.isLoading,
                  scrollController: scrollController,
                  responsive: responsive,
                );
        } else if (state is ChatError) {
          return Center(
            child: Text(
              'Something went wrong. Please try again.',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: responsive.sp(16),
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
