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
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(chat.lastMessage),
          // Show role context for debugging/clarity
          Text(
            'You: ${_getCurrentUserRole()} → ${chat.receiver.role}',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
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

  String _getCurrentUserRole() {
    // Get current user role from chat context
    final currentUserId = AuthServices().currentUser?.uid;
    if (currentUserId == null) return 'unknown';
    
    if (chat.sender.uid == currentUserId) {
      return chat.sender.role;
    } else if (chat.receiver.uid == currentUserId) {
      return chat.receiver.role;
    }
    return 'unknown';
  }

  Future<void> _handleChatTap(BuildContext context) async {
    try {
      print("=== CHAT TILE TAP DEBUG ===");
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

      // IMPORTANT: Determine the other user based on who is NOT the current user
      final bool isCurrentUserSender = chat.sender.uid == currentUserId;
      final otherUser = isCurrentUserSender ? chat.receiver : chat.sender;
      final currentUserInChat = isCurrentUserSender ? chat.sender : chat.receiver;

      print("Current User ID: $currentUserId");
      print("Current User Active Role: $activeRole");
      print("Current User In Chat: ${currentUserInChat.uid} (${currentUserInChat.role})");
      print("Other User: ${otherUser.uid} (${otherUser.role})");
      print("Is Sender: $isCurrentUserSender");

      // Safety check to prevent self-chat
      if (otherUser.uid == currentUserId) {
        print("⚠️ Prevented self-chat in ChatTile");
        return;
      }

      // Check if current active role matches the role in this chat
      if (currentUserProfile.role != currentUserInChat.role) {
        print("⚠️ Role mismatch detected!");
        print("Active role: ${currentUserProfile.role}");
        print("Chat role: ${currentUserInChat.role}");
        
        // Find or create a new chat with the current active role
        final String newChatId = await chatRepository.createOrGetChat(
          sender: currentUserProfile,
          receiver: otherUser,
        );
        
        print("Using new/existing chat ID: $newChatId");
        
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => IndividualChatCubit(
                  chatRepository: chatRepository,
                  chatId: newChatId,
                  currentUserId: currentUserProfile.uid,
                )..loadMessages(),
                child: ChatScreen(
                  chatId: newChatId,
                  currentUser: currentUserProfile,
                  otherUser: otherUser,
                ),
              ),
            ),
          );
        }
        return;
      }

      // Use the existing chat ID from the ChatModel
      final chatId = chat.chatId;
      print("Using existing chat ID: $chatId");
      print("=== END DEBUG ===");

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