import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/app_colors.dart';
import 'package:quick_pitch_app/features/chat/viewmodel/chat/cubit/chat_list_view_model_cubit.dart';


class ChatListAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: BlocBuilder<ChatListViewModel, ChatListState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Messages',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              if (state is ChatListLoaded && state.currentRole != null)
                Text(
                  'Active as ${state.currentRole!.toUpperCase()}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
            ],
          );
        },
      ),
    );
  }
}

