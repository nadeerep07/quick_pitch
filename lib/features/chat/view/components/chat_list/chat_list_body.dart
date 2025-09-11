import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/common/main_background_painter.dart';
import 'package:quick_pitch_app/features/chat/view/components/chat_list/chat_list_content.dart';
import 'package:quick_pitch_app/features/chat/view/widgets/chat_list/chat_error_widget.dart';
import 'package:quick_pitch_app/features/chat/view/widgets/chat_list/chat_list_shimmer.dart';
import 'package:quick_pitch_app/features/chat/viewmodel/chat/cubit/chat_list_view_model_cubit.dart';

class ChatListBody extends StatelessWidget {
  final ChatListViewModel viewModel;
  const ChatListBody({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatListViewModel, ChatListState>(
      listener: (context, state) {
        if (state is ChatListError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: MainBackgroundPainter())),
            Positioned.fill(
              child: switch (state) {
                ChatListLoading() => const Center(
                    child: ChatListShimmer(),
                  ),
                ChatListLoaded() =>
                    ChatListContent(state: state, viewModel: viewModel),
                ChatListError() => ChatErrorWidget(
                    message: state.message,
                    onRetry: () => viewModel.refreshChats(),
                  ),
                _ => const SizedBox.shrink(),
              },
            ),
          ],
        );
      },
    );
  }
}

