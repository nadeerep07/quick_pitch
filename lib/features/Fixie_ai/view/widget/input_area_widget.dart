// lib/features/fixie_ai/view/fixie_ai_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/config/responsive.dart';
import 'package:quick_pitch_app/features/Fixie_ai/viewmodel/bloc/chat_bloc.dart';

class InputAreaWidget extends StatelessWidget {
  final TextEditingController textController;
  final Responsive responsive;
  final VoidCallback onSendMessage;

  const InputAreaWidget({
    super.key,
    required this.textController,
    required this.responsive,
    required this.onSendMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(responsive.wp(5)),
      padding: EdgeInsets.all(responsive.wp(1)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepPurple.withValues(alpha: 0.1),
            Colors.deepPurple.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(responsive.wp(7)),
        border: Border.all(color: Colors.deepPurple.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withValues(alpha: 0.1),
            blurRadius: responsive.wp(5),
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _buildTextField()),
          _buildSendButton(context),
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: textController,
      style: TextStyle(
        color: Colors.deepPurple.shade800,
        fontSize: responsive.sp(16),
      ),
      decoration: InputDecoration(
        hintText: 'Ask about pitches, decks, or business ideas...',
        hintStyle: TextStyle(
          color: Colors.deepPurple.shade400.withValues(alpha: 0.6),
          fontSize: responsive.sp(16),
        ),
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(
          horizontal: responsive.wp(6),
          vertical: responsive.hp(2),
        ),
      ),
      maxLines: null,
      textCapitalization: TextCapitalization.sentences,
      onSubmitted: (_) => onSendMessage(),
    );
  }

  Widget _buildSendButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: responsive.wp(1)),
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          final isLoading = state is ChatLoaded && state.isLoading;
          return InkWell(
            onTap: isLoading ? null : onSendMessage,
            borderRadius: BorderRadius.circular(responsive.wp(6)),
            child: Container(
              width: responsive.wp(12),
              height: responsive.wp(12),
              decoration: BoxDecoration(
                gradient: isLoading
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
                    blurRadius: responsive.wp(3),
                    spreadRadius: responsive.wp(0.5),
                  ),
                ],
              ),
              child: isLoading
                  ? SizedBox(
                      width: responsive.wp(5),
                      height: responsive.wp(5),
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: responsive.wp(5),
                    ),
            ),
          );
        },
      ),
    );
  }
}
