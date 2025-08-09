import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_pitch_app/features/chat/fixer/model/chat_model.dart';
import 'package:quick_pitch_app/features/chat/fixer/model/message_model.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get chats for any user (filtered by current active role)
  Stream<List<ChatModel>> getUserChats(String userId) async* {
    try {
      final userRole = await detectUserRole(userId);
      
      if (userRole == null) {
        yield [];
        return;
      }
      
      print("🔍 Loading chats for user: $userId with role: $userRole");
      
      // Get ALL chats where user is involved, then filter by role
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
                
                // Check if user's role in this chat matches their current active role
                final senderUid = data['sender']?['uid'];
                final senderRole = data['sender']?['role'];
                final receiverUid = data['receiver']?['uid'];
                final receiverRole = data['receiver']?['role'];
                
                bool shouldIncludeChat = false;
                
                if (senderUid == userId && senderRole == userRole) {
                  shouldIncludeChat = true;
                } else if (receiverUid == userId && receiverRole == userRole) {
                  shouldIncludeChat = true;
                }
                
                if (shouldIncludeChat) {
                  final chat = ChatModel.fromMapWithContext(data, userId);
                  chats.add(chat);
                  print("✅ Including chat: ${chat.chatId} (user role: $userRole)");
                } else {
                  print("❌ Excluding chat: ${doc.id} (user role mismatch)");
                }
                
              } catch (e) {
                print('Error loading chat: $e');
              }
            }

            print("📋 Total chats for role $userRole: ${chats.length}");
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

  // FIXED: Generate role-specific chat ID - NO MORE SORTING
  String generateChatId({
    required String userId1,
    required String role1,
    required String userId2,
    required String role2,
  }) {
    // Create role-specific chat ID without sorting
    // This ensures A(poster)->B(fixer) is different from A(fixer)->B(poster)
    return '${userId1}-${role1}_${userId2}-${role2}';
  }

  // FIXED: Create or get existing chat with proper role-specific logic
  Future<String> createOrGetChat({
    required UserProfileModel sender,
    required UserProfileModel receiver,
  }) async {
    if (sender.uid == receiver.uid) {
      throw Exception("❌ Cannot create chat with self");
    }

    // Generate the primary chat ID (sender->receiver)
    final primaryChatId = generateChatId(
      userId1: sender.uid,
      role1: sender.role,
      userId2: receiver.uid,
      role2: receiver.role,
    );

    // Generate the reverse chat ID (receiver->sender) to check for existing chats
    final reverseChatId = generateChatId(
      userId1: receiver.uid,
      role1: receiver.role,
      userId2: sender.uid,
      role2: sender.role,
    );

    try {
      // Check if primary chat exists
      final primaryChatDoc = await _firestore.collection('chats').doc(primaryChatId).get();
      if (primaryChatDoc.exists) {
        return primaryChatId;
      }

      // Check if reverse chat exists
      final reverseChatDoc = await _firestore.collection('chats').doc(reverseChatId).get();
      if (reverseChatDoc.exists) {
        return reverseChatId;
      }

      // Create new chat with primary ID
      await _firestore.collection('chats').doc(primaryChatId).set({
        'chatId': primaryChatId,
        'sender': sender.toRoleJson(),
        'receiver': receiver.toRoleJson(),
        'lastMessage': '',
        'lastMessageTime': DateTime.now(),
        'unreadCount': 0,
        'isReceiverOnline': false,
        // Add role-specific metadata for better querying
        'senderRole': sender.role,
        'receiverRole': receiver.role,
        'participantRoles': ['${sender.uid}-${sender.role}', '${receiver.uid}-${receiver.role}'],
      });

      return primaryChatId;
    } catch (e) {
      print('Error creating/getting chat: $e');
      throw e;
    }
  }

  // NEW: Get chat between specific users with specific roles
  Future<String?> findExistingChat({
    required String userId1,
    required String role1,
    required String userId2,
    required String role2,
  }) async {
    try {
      // Try both possible chat IDs
      final chatId1 = generateChatId(
        userId1: userId1,
        role1: role1,
        userId2: userId2,
        role2: role2,
      );
      
      final chatId2 = generateChatId(
        userId1: userId2,
        role1: role2,
        userId2: userId1,
        role2: role1,
      );

      final chat1Doc = await _firestore.collection('chats').doc(chatId1).get();
      if (chat1Doc.exists) return chatId1;

      final chat2Doc = await _firestore.collection('chats').doc(chatId2).get();
      if (chat2Doc.exists) return chatId2;

      return null;
    } catch (e) {
      print('Error finding existing chat: $e');
      return null;
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

  Future<String?> detectUserRole(String uid) async {
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