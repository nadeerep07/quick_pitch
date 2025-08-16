import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_pitch_app/features/chat/model/chat_model.dart';
import 'package:quick_pitch_app/features/chat/model/message_model.dart';
import 'package:quick_pitch_app/features/chat/service/chat_service.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class ChatRepository {
  final ChatService _service;
  ChatRepository({ChatService? service}) : _service = service ?? ChatService();

  Stream<List<ChatModel>> getUserChats(String userId) async* {
    final role = await detectUserRole(userId);
    if (role == null) {
      yield [];
      return;
    }

    yield* _service.getUserChatsSnapshot(userId).asyncMap((snapshot) {
      return snapshot.docs.map((doc) {
        return ChatModel.fromMapWithContext(doc.data(), userId);
      }).toList();
    });
  }

  Future<void> markMessagesAsRead(String chatId, String userId) {
    return _service.markMessagesAsRead(chatId, userId);
  }

  Stream<List<MessageModel>> getChatMessages(String chatId) {
    return _service.getMessagesSnapshot(chatId).map((snapshot) {
      return snapshot.docs.map((doc) => MessageModel.fromMap(doc.data())).toList();
    });
  }

  Future<void> sendMessage({
    required String chatId,
    required UserProfileModel sender,
    required UserProfileModel receiver,
    required String messageText,
    MessageType messageType = MessageType.text,
    List<AttachmentModel> attachments = const [],
  }) {
    final now = DateTime.now();
    
    // Determine last message text for chat preview
    String lastMessageText = messageText;
    if (messageType == MessageType.image && messageText.isEmpty) {
      lastMessageText = '📷 Image';
    } else if (messageType == MessageType.mixed) {
      lastMessageText = '📷 $messageText';
    } else if (attachments.isNotEmpty && messageText.isEmpty) {
      lastMessageText = '📎 Attachment';
    }

    return _service.updateChatAndSendMessage(
      chatId: chatId,
      messageData: {
        'text': messageText,
        'senderId': sender.uid,
        'receiverId': receiver.uid,
        'timestamp': now,
        'isRead': false,
        'messageType': messageType.name,
        'attachments': attachments.map((attachment) => attachment.toMap()).toList(),
      },
      chatUpdates: {
        'lastMessage': lastMessageText,
        'lastMessageTime': now,
        'unreadCount.${receiver.uid}': FieldValue.increment(1),
      },
    );
  }

  Future<String?> detectUserRole(String uid) async {
    final doc = await _service.getUserRoleDoc(uid);
    return doc.data()?['activeRole'] as String?;
  }

  Future<UserProfileModel> fetchCurrentUserProfileByRole(String uid, {required String role}) async {
    final doc = await _service.getUserProfileDoc(uid, role);
    return UserProfileModel.fromJson(doc.data()!);
  }
    
  Future<String> createOrGetChat({
    required UserProfileModel sender,
    required UserProfileModel receiver,
  }) async {
    if (sender.uid == receiver.uid) {
      throw Exception("Cannot create chat with self");
    }

    final chatId = '${sender.uid}-${sender.role}_${receiver.uid}-${receiver.role}';
    final doc = await _service.getChatDoc(chatId);

    if (!doc.exists) {
      await _service.createChat(chatId, {
        'chatId': chatId,
        'sender': sender.toRoleJson(),
        'receiver': receiver.toRoleJson(),
        'lastMessage': '',
        'lastMessageTime': DateTime.now(),
        'unreadCount': {sender.uid: 0, receiver.uid: 0},
        'isReceiverOnline': false,
      });
    }
    return chatId;
  }

  String generateChatId({
    required String userId1,
    required String role1,
    required String userId2,
    required String role2,
  }) {
    return '$userId1-${role1}_$userId2-$role2';
  }
}