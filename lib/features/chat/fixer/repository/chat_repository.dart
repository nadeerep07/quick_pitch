import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_pitch_app/features/chat/fixer/model/chat_model.dart';
import 'package:quick_pitch_app/features/chat/fixer/model/message_model.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get chats for any user (fixed role detection)
  Stream<List<ChatModel>> getUserChats(String userId) async* {
    try {
      final userRole = await _detectUserRole(userId);
      
      if (userRole == null) {
        yield [];
        return;
      }
      
      // Get chats where user is either sender OR receiver
      yield* _firestore
          .collection('chats')
          .where(Filter.or(
            Filter('sender.uid', isEqualTo: userId),
            Filter('receiver.uid', isEqualTo: userId),
          ))
          .orderBy('lastMessageTime', descending: true)
          .snapshots()
          .asyncMap((snapshot) async {
            final List<ChatModel> chats = [];

            for (final doc in snapshot.docs) {
              try {
                final data = doc.data();
                final chat = ChatModel.fromMapWithContext(data, userId);
                chats.add(chat);
              } catch (e) {
                print('Error loading chat: $e');
              }
            }

            return chats;
          });
    } catch (e) {
      print('Error in getUserChats: $e');
      yield [];
    }
  }

  // Get chats for poster - FIXED
  Stream<List<ChatModel>> getChatsForPoster(String posterId) {
    return _firestore
        .collection('chats')
        .where(Filter.or(
          Filter('sender.uid', isEqualTo: posterId),
          Filter('receiver.uid', isEqualTo: posterId),
        ))
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          final List<ChatModel> chats = [];

          for (final doc in snapshot.docs) {
            try {
              final data = doc.data();
              final chat = ChatModel.fromMapWithContext(data, posterId);
              chats.add(chat);
            } catch (e) {
              print('Error loading chat (poster): $e');
            }
          }

          return chats;
        });
  }

  // Get chats for fixer - FIXED
  Stream<List<ChatModel>> getChatsForFixer(String fixerId) {
    return _firestore
        .collection('chats')
        .where(Filter.or(
          Filter('sender.uid', isEqualTo: fixerId),
          Filter('receiver.uid', isEqualTo: fixerId),
        ))
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          final List<ChatModel> chats = [];

          for (final doc in snapshot.docs) {
            try {
              final data = doc.data();
              final chat = ChatModel.fromMapWithContext(data, fixerId);
              chats.add(chat);
            } catch (e) {
              print('Error loading chat (fixer): $e');
            }
          }

          return chats;
        });
  }

  // Get messages for a specific chat
  Stream<List<MessageModel>> getChatMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromMap(doc.data()))
            .toList());
  }

  // Send a message - FIXED
  Future<void> sendMessage({
    required String chatId,
    required UserProfileModel sender,
    required UserProfileModel receiver,
    required String messageText,
  }) async {
    final timestamp = DateTime.now();
    final chatDoc = _firestore.collection('chats').doc(chatId);

    try {
      // Create batch for atomic operations
      final batch = _firestore.batch();

      // Update chat metadata
      batch.set(chatDoc, {
        'chatId': chatId,
        'sender': sender.toRoleJson(),
        'receiver': receiver.toRoleJson(),
        'lastMessage': messageText,
        'lastMessageTime': timestamp,
        'unreadCount': FieldValue.increment(1),
        'isReceiverOnline': false,
     //   'participants': [sender.uid, receiver.uid],
      }, SetOptions(merge: true));

      // Add message to messages subcollection
      final messageDoc = chatDoc.collection('messages').doc();
      batch.set(messageDoc, {
        'text': messageText,
        'senderId': sender.uid,
        'receiverId': receiver.uid,
        'timestamp': timestamp,
      });

      await batch.commit();
    } catch (e) {
      print('Error sending message: $e');
      throw e;
    }
  }

  // FIXED: Generate consistent chat ID
  String generateChatId({
    required String userId1,
    required String role1,
    required String userId2,
    required String role2,
  }) {
    // Always use consistent ordering regardless of who initiates the chat
    final List<String> users = [
      '$userId1-$role1',
      '$userId2-$role2',
    ];
    users.sort(); // This ensures consistent ordering
    
    return '${users[0]}_${users[1]}';
  }

  // FIXED: Create or get existing chat
  Future<String> createOrGetChat({
    required UserProfileModel sender,
    required UserProfileModel receiver,
  }) async {
    if (sender.uid == receiver.uid) {
      throw Exception("❌ Cannot create chat with self");
    }

    final chatId = generateChatId(
      userId1: sender.uid,
      role1: sender.role,
      userId2: receiver.uid,
      role2: receiver.role,
    );

    try {
      final chatDoc = await _firestore.collection('chats').doc(chatId).get();

      if (!chatDoc.exists) {
        await _firestore.collection('chats').doc(chatId).set({
          'chatId': chatId,
          'sender': sender.toRoleJson(),
          'receiver': receiver.toRoleJson(),
          'lastMessage': '',
          'lastMessageTime': DateTime.now(),
          'unreadCount': 0,
          'isReceiverOnline': false,
         // 'participants': [sender.uid, receiver.uid],
        });
      }

      return chatId;
    } catch (e) {
      print('Error creating/getting chat: $e');
      throw e;
    }
  }

  // Mark messages as read
  Future<void> markAsRead(String chatId) async {
    try {
      await _firestore.collection('chats').doc(chatId).update({
        'unreadCount': 0,
      });
    } catch (e) {
      print('Error marking as read: $e');
    }
  }

  // Helper methods
  Future<UserProfileModel> fetchCurrentUserProfileByRole(String uid, {required String role}) async {
    try {
      final userSnap = await _firestore
          .collection('users')
          .doc(uid)
          .collection('roles')
          .doc(role)
          .get();

      if (!userSnap.exists) {
        throw Exception("User role ($role) not found");
      }

      return UserProfileModel.fromJson(userSnap.data()!);
    } catch (e) {
      print('Error fetching user profile: $e');
      throw e;
    }
  }

  Future<String?> _detectUserRole(String uid) async {
    try {
      final userDoc = await _firestore.collection('users').doc(uid).get();
      
      if (userDoc.exists) {
        final activeRole = userDoc.data()?['activeRole'];
        return activeRole;
      }
      
      return null;
    } catch (e) {
      print('Error detecting user role: $e');
      return null;
    }
  }

  // Update online status - FIXED
  Future<void> updateUserOnlineStatus(String userId, bool isOnline) async {
    try {
      // Update all chats where this user is involved
      final chatsQuery = await _firestore
          .collection('chats')
          .where(Filter.or(
            Filter('sender.uid', isEqualTo: userId),
            Filter('receiver.uid', isEqualTo: userId),
          ))
          .get();

      final batch = _firestore.batch();

      for (final doc in chatsQuery.docs) {
        final data = doc.data();
        // Only update if this user is the receiver in this chat context
        if (data['receiver']?['uid'] == userId) {
          batch.update(doc.reference, {'isReceiverOnline': isOnline});
        }
      }

      await batch.commit();
    } catch (e) {
      print('Error updating online status: $e');
    }
  }
}