import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_pitch_app/core/services/firebase/auth/auth_services.dart';
import 'package:quick_pitch_app/features/chat/fixer/model/chat_model.dart';
import 'package:quick_pitch_app/features/chat/fixer/repository/chat_repository.dart';
import 'package:quick_pitch_app/features/chat/fixer/view/screen/chat_screen.dart';
import 'package:quick_pitch_app/features/chat/fixer/viewmodel/individual_chat/cubit/individual_chat_cubit.dart';

class ChatTile extends StatelessWidget {
  final ChatModel chat;

  const ChatTile({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: chat.receiver.profileImageUrl != null
            ? NetworkImage(chat.receiver.profileImageUrl!)
            : null,
        child: chat.receiver.profileImageUrl == null
            ? const Icon(Icons.person)
            : null,
      ),
      title: Text(chat.receiver.name),
      subtitle: Text(chat.lastMessage),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _formatTime(chat.lastMessageTime),
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 4),
          if (chat.unreadCount > 0)
            CircleAvatar(
              radius: 10,
              backgroundColor: Colors.red,
              child: Text(
                '${chat.unreadCount}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
        ],
      ),
      onTap: () => _handleChatTap(context),
    );
  }

  Future<void> _handleChatTap(BuildContext context) async {
    try {
      print("Chat tapped: ${chat.chatId}");
      
      final authService = AuthServices();
      final currentUserId = authService.currentUser?.uid;
      if (currentUserId == null) {
        print("❌ No current user found");
        return;
      }

      // Determine current user's active role
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .get();
      
      final activeRole = userDoc.data()?['activeRole'];
      if (activeRole == null) {
        print("❌ No active role found for user");
        return;
      }

      // Get current user's profile
      final chatRepository = ChatRepository();
      final currentUserProfile = await chatRepository
          .fetchCurrentUserProfileByRole(currentUserId, role: activeRole);

      // Determine the other user (the one we're chatting with)
      final otherUser = chat.sender.uid == currentUserId
          ? chat.receiver
          : chat.sender;

      // Safety check to prevent self-chat
      if (otherUser.uid == currentUserId) {
        print("⚠️ Prevented self-chat in ChatTile");
        return;
      }

      // Use the existing chat ID from the ChatModel
      // This ensures consistency with the chat list
      final chatId = chat.chatId;

      print("Current user: ${currentUserProfile.uid} (${currentUserProfile.role})");
      print("Other user: ${otherUser.uid} (${otherUser.role})");
      print("Using chat ID: $chatId");

      // Navigate to chat screen
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => IndividualChatCubit(
                chatRepository: chatRepository,
                chatId: chatId,
                currentUserId: currentUserProfile.uid,
              )..loadMessages(),
              child: ChatScreen(
                chatId: chatId,
                currentUser: currentUserProfile,
                otherUser: otherUser,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      print("❌ Error in chat tap: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error opening chat: $e")),
        );
      }
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    if (messageDate == today) {
      final time = TimeOfDay.fromDateTime(dateTime);
      return "${time.hourOfPeriod}:${time.minute.toString().padLeft(2, '0')} ${time.period.name.toUpperCase()}";
    } else {
      final time = TimeOfDay.fromDateTime(dateTime);
      return "${dateTime.day}/${dateTime.month} ${time.hourOfPeriod}:${time.minute.toString().padLeft(2, '0')} ${time.period.name.toUpperCase()}";
    }
  }
}