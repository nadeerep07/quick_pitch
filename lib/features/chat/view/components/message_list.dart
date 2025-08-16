import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/features/chat/view/components/chat_background_painter.dart';
import 'package:quick_pitch_app/features/chat/view/components/empty_state.dart';
import 'package:quick_pitch_app/features/chat/view/components/error_state.dart';
import 'package:quick_pitch_app/features/chat/view/widgets/message_list_view.dart';
import 'package:quick_pitch_app/features/chat/viewmodel/individual_chat/cubit/individual_chat_cubit.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';



class MessageList extends StatelessWidget {
  final UserProfileModel currentUser;
  final UserProfileModel otherUser;
  final ScrollController scrollController;

  const MessageList({
    super.key,
    required this.currentUser,
    required this.otherUser,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IndividualChatCubit, IndividualChatState>(
      builder: (context, state) {
        if (state is IndividualChatLoading) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        } else if (state is IndividualChatLoaded || state is IndividualChatSending) {
          final messages = state is IndividualChatLoaded
              ? (state).messages
              : (state as IndividualChatSending).messages;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (scrollController.hasClients) {
              scrollController.jumpTo(0); // Always stay at bottom
            }
          });

          return CustomPaint(
            painter: ChatBackgroundPainter(),
            child: messages.isEmpty
                ? const EmptyState()
                : MessageListView(
                    messages: messages,
                    currentUser: currentUser,
                    otherUser: otherUser,
                    scrollController: scrollController,
                  ),
          );
        } else if (state is IndividualChatError) {
          return ErrorState(errorMessage: state.message);
        }
        return const SizedBox();
      },
    );
  }
}
